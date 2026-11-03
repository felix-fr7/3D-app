const db = require('../config/db');
const { uploadMediaStream } = require('../config/cloudinary');

// 1. Get all districts
exports.getAllDistricts = async (req, res) => {
  try {
    const result = await db.query(
      `SELECT d.*, COUNT(df.id) as facts_count
       FROM districts d
       LEFT JOIN district_facts df ON d.id = df.district_id
       GROUP BY d.id
       ORDER BY d.name ASC`
    );
    res.json({ success: true, count: result.rows.length, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 2. Get single district with all its district facts
exports.getDistrictById = async (req, res) => {
  try {
    const { id } = req.params;
    if (id === 'sync-media') {
      return exports.syncAuthenticMedia(req, res);
    }
    const districtRes = await db.query('SELECT * FROM districts WHERE id = $1', [id]);
    if (districtRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'District not found' });
    }

    const factsRes = await db.query(
      'SELECT * FROM district_facts WHERE district_id = $1 ORDER BY id ASC',
      [id]
    );

    res.json({
      success: true,
      data: {
        ...districtRes.rows[0],
        district_facts: factsRes.rows,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 3. Create a new district
exports.createDistrict = async (req, res) => {
  try {
    const { name, code, state, description } = req.body;
    if (!name || !code) {
      return res.status(400).json({ success: false, message: 'District name and code are required.' });
    }

    const result = await db.query(
      `INSERT INTO districts (name, code, state, description)
       VALUES ($1, UPPER($2), COALESCE($3, 'Tamil Nadu'), $4)
       RETURNING *`,
      [name.trim(), code.trim(), state, description]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    if (err.code === '23505') {
      return res.status(409).json({ success: false, message: 'District name or code already exists.' });
    }
    res.status(500).json({ success: false, error: err.message });
  }
};

// 3b. Delete an entire District (and cascade facts & Cloudinary media)
exports.deleteDistrict = async (req, res) => {
  try {
    const { id } = req.params;

    // Destroy Cloudinary assets for all facts under this district
    try {
      const { cloudinary } = require('../config/cloudinary');
      const factsRes = await db.query('SELECT cloudinary_public_id, cloudinary_media_url, media_type FROM district_facts WHERE district_id = $1', [id]);
      for (const f of factsRes.rows) {
        const pid = f.cloudinary_public_id || extractPublicIdFromUrl(f.cloudinary_media_url);
        if (pid) {
          try {
            await cloudinary.uploader.destroy(pid, { resource_type: f.media_type === 'video' ? 'video' : 'image' });
          } catch (_) {}
        }
      }
    } catch (_) {}

    await db.query('DELETE FROM district_facts WHERE district_id = $1', [id]);
    await db.query('DELETE FROM districts WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'District and associated facts permanently deleted.'
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 3c. Complete Purge of All Data from Cloudinary & Database
exports.purgeAllData = async (req, res) => {
  try {
    const { cloudinary } = require('../config/cloudinary');

    // 1. Destroy Cloudinary assets
    try {
      const [df, lf, lm] = await Promise.all([
        db.query(`SELECT cloudinary_public_id, cloudinary_media_url, media_type FROM district_facts`),
        db.query(`SELECT cloudinary_public_id, cloudinary_media_url, media_type FROM locality_facts`),
        db.query(`SELECT cloudinary_public_id, cloudinary_image_url as cloudinary_media_url, 'image' as media_type FROM landmarks`)
      ]);

      const seen = new Set();
      for (const row of [...df.rows, ...lf.rows, ...lm.rows]) {
        const pid = row.cloudinary_public_id || extractPublicIdFromUrl(row.cloudinary_media_url);
        if (pid && !seen.has(pid)) {
          seen.add(pid);
          try {
            await cloudinary.uploader.destroy(pid, { resource_type: row.media_type === 'video' ? 'video' : 'image' });
          } catch (_) {}
        }
      }

      await cloudinary.api.delete_resources_by_prefix('facts_vision/', { resource_type: 'image' }).catch(() => {});
      await cloudinary.api.delete_resources_by_prefix('facts_vision/', { resource_type: 'video' }).catch(() => {});
    } catch (cErr) {
      console.warn('[Purge Cloudinary Warning]:', cErr.message);
    }

    // 2. Wipe Database tables
    if (db.dbType === 'mysql') {
      await db.query('SET FOREIGN_KEY_CHECKS = 0');
      await db.query('DELETE FROM recognition_logs');
      await db.query('DELETE FROM landmarks');
      await db.query('DELETE FROM locality_facts');
      await db.query('DELETE FROM localities');
      await db.query('DELETE FROM district_facts');
      await db.query('DELETE FROM districts');
      await db.query('ALTER TABLE recognition_logs AUTO_INCREMENT = 1').catch(() => {});
      await db.query('ALTER TABLE landmarks AUTO_INCREMENT = 1').catch(() => {});
      await db.query('ALTER TABLE locality_facts AUTO_INCREMENT = 1').catch(() => {});
      await db.query('ALTER TABLE localities AUTO_INCREMENT = 1').catch(() => {});
      await db.query('ALTER TABLE district_facts AUTO_INCREMENT = 1').catch(() => {});
      await db.query('ALTER TABLE districts AUTO_INCREMENT = 1').catch(() => {});
      await db.query('SET FOREIGN_KEY_CHECKS = 1');
    } else {
      await db.query('TRUNCATE TABLE recognition_logs, landmarks, locality_facts, localities, district_facts, districts RESTART IDENTITY CASCADE');
    }

    res.json({
      success: true,
      message: 'All districts, localities, facts, and Cloudinary media assets have been completely deleted.'
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 4. Add a District Fact (with Cloudinary media upload: image/video/gif)
exports.addDistrictFact = async (req, res) => {
  try {
    const { district_id, title, fact_type, content, source_attribution } = req.body;
    if (!district_id || !title || !content) {
      return res.status(400).json({
        success: false,
        message: 'district_id, title, and content are required.',
      });
    }

    let cloudinaryUrl = null;
    let cloudinaryPublicId = null;
    let mediaType = 'none';

    // If an image, video, or gif file was uploaded:
    if (req.file) {
      console.log(`[Cloudinary] Uploading district fact media (${req.file.mimetype})...`);
      const uploadRes = await uploadMediaStream(req.file.buffer, 'facts_vision/district_facts', 'auto');
      cloudinaryUrl = uploadRes.secure_url;
      cloudinaryPublicId = uploadRes.public_id;
      mediaType = req.file.mimetype.startsWith('video/') ? 'video' : req.file.mimetype.includes('gif') ? 'gif' : 'image';
    }

    // Insert only Cloudinary URL into PostgreSQL
    const result = await db.query(
      `INSERT INTO district_facts 
       (district_id, title, fact_type, content, cloudinary_media_url, cloudinary_public_id, media_type, source_attribution)
       VALUES ($1, $2, COALESCE($3, 'history'), $4, $5, $6, $7, $8)
       RETURNING *`,
      [district_id, title, fact_type, content, cloudinaryUrl, cloudinaryPublicId, mediaType, source_attribution]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 4a. Update a District Fact (Syncs changes in DB and Cloudinary)
exports.updateDistrictFact = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, fact_type, content, source_attribution } = req.body;

    const existingRes = await db.query('SELECT * FROM district_facts WHERE id = $1', [id]);
    if (existingRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'District fact not found' });
    }

    const currentFact = existingRes.rows[0];
    let cloudinaryUrl = currentFact.cloudinary_media_url;
    let cloudinaryPublicId = currentFact.cloudinary_public_id;
    let mediaType = currentFact.media_type;

    if (req.file) {
      // 1. Permanently delete old media from Cloudinary so orphaned files don't linger
      const oldPublicId = currentFact.cloudinary_public_id || extractPublicIdFromUrl(currentFact.cloudinary_media_url);
      if (oldPublicId) {
        try {
          const { cloudinary } = require('../config/cloudinary');
          await cloudinary.uploader.destroy(oldPublicId, {
            resource_type: currentFact.media_type === 'video' ? 'video' : 'image'
          });
          console.log(`[Cloudinary] Old media destroyed for District Fact #${id}: ${oldPublicId}`);
        } catch (cErr) {
          console.warn('[Cloudinary Destroy Old Media Notice]:', cErr.message);
        }
      }

      // 2. Upload replacement media to Cloudinary
      console.log(`[Cloudinary] Uploading replacement media for District Fact #${id}...`);
      const uploadRes = await uploadMediaStream(req.file.buffer, 'facts_vision/district_facts', 'auto');
      cloudinaryUrl = uploadRes.secure_url;
      cloudinaryPublicId = uploadRes.public_id;
      mediaType = req.file.mimetype.startsWith('video/') ? 'video' : req.file.mimetype.includes('gif') ? 'gif' : 'image';
    }

    const updatedRes = await db.query(
      `UPDATE district_facts 
       SET title = COALESCE($1, title),
           fact_type = COALESCE($2, fact_type),
           content = COALESCE($3, content),
           source_attribution = COALESCE($4, source_attribution),
           cloudinary_media_url = $5,
           cloudinary_public_id = $6,
           media_type = $7
       WHERE id = $8
       RETURNING *`,
      [title, fact_type, content, source_attribution, cloudinaryUrl, cloudinaryPublicId, mediaType, id]
    );

    res.json({
      success: true,
      message: 'District fact updated successfully in both Cloudinary and Database.',
      data: updatedRes.rows[0]
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 4b. Delete a District Fact (Syncs deletion across both Cloudinary and DB)
exports.deleteDistrictFact = async (req, res) => {
  try {
    const { id } = req.params;
    const existingRes = await db.query('SELECT * FROM district_facts WHERE id = $1', [id]);
    if (existingRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'District fact not found' });
    }

    const fact = existingRes.rows[0];
    const targetPublicId = fact.cloudinary_public_id || extractPublicIdFromUrl(fact.cloudinary_media_url);

    // 1. Permanently destroy asset in Cloudinary
    if (targetPublicId) {
      try {
        const { cloudinary } = require('../config/cloudinary');
        await cloudinary.uploader.destroy(targetPublicId, {
          resource_type: fact.media_type === 'video' ? 'video' : 'image'
        });
        console.log(`[Cloudinary] Asset permanently destroyed for District Fact #${id}: ${targetPublicId}`);
      } catch (cErr) {
        console.warn('[Cloudinary Destroy Notice]:', cErr.message);
      }
    }

    // 2. Delete row from Database
    await db.query('DELETE FROM district_facts WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'District fact deleted successfully from both Cloudinary and Database.'
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

function extractPublicIdFromUrl(url) {
  if (!url || typeof url !== 'string') return null;
  try {
    const parts = url.split('/upload/');
    if (parts.length > 1) {
      const pathWithExt = parts[1].replace(/^v\d+\//, '');
      return pathWithExt.substring(0, pathWithExt.lastIndexOf('.')) || pathWithExt;
    }
  } catch (_) {}
  return null;
}

// 5. Apply Authentic Media & Cultural Facts to all 38 districts & localities
const { authenticDistrictMedia, authenticLocalityMedia } = require('../config/seedMediaData');

exports.syncAuthenticMedia = async (req, res) => {
  try {
    let districtUpdated = 0;
    let localityUpdated = 0;

    // A. Update or Insert District Facts
    for (const item of authenticDistrictMedia) {
      const existing = await db.query(
        `SELECT id FROM district_facts 
         WHERE district_id = $1 AND (fact_type = $2 OR title = $3)`,
        [item.district_id, item.fact_type, item.title]
      );

      if (existing.rows.length > 0) {
        await db.query(
          `UPDATE district_facts 
           SET title = $1, content = $2, cloudinary_media_url = $3, media_type = $4 
           WHERE id = $5`,
          [item.title, item.content, item.media_url, item.media_type, existing.rows[0].id]
        );
      } else {
        await db.query(
          `INSERT INTO district_facts 
           (district_id, title, fact_type, content, cloudinary_media_url, media_type)
           VALUES ($1, $2, $3, $4, $5, $6)`,
          [item.district_id, item.title, item.fact_type, item.content, item.media_url, item.media_type]
        );
      }
      districtUpdated++;
    }

    // B. Update or Insert Locality Facts
    for (const item of authenticLocalityMedia) {
      const existing = await db.query(
        `SELECT id FROM locality_facts 
         WHERE locality_id = $1 AND (fact_type = $2 OR title = $3)`,
        [item.locality_id, item.fact_type, item.title]
      );

      if (existing.rows.length > 0) {
        await db.query(
          `UPDATE locality_facts 
           SET title = $1, content = $2, cloudinary_media_url = $3, media_type = $4 
           WHERE id = $5`,
          [item.title, item.content, item.media_url, item.media_type, existing.rows[0].id]
        );
      } else {
        await db.query(
          `INSERT INTO locality_facts 
           (locality_id, title, fact_type, content, cloudinary_media_url, media_type)
           VALUES ($1, $2, $3, $4, $5, $6)`,
          [item.locality_id, item.title, item.fact_type, item.content, item.media_url, item.media_type]
        );
      }
      localityUpdated++;
    }

    // C. Explicit Virudhunagar & Ariyalur guarantees
    await db.query(
      `UPDATE locality_facts 
       SET title = 'Virudhunagar Ennai Parotta (Coin / Poricha Parotta)',
           content = 'Crispy shallow-fried golden coin parottas layered with softness and served with spicy mutton/chicken salna.',
           cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Famous_south_india_food_parotta.jpg?width=800',
           media_type = 'image'
       WHERE locality_id = 23 AND (fact_type = 'food' OR title LIKE '%Parotta%')`
    );

    await db.query(
      `UPDATE district_facts 
       SET title = 'Cretaceous Era Marine Ammonite Fossils & Gangaikonda Cholapuram',
           content = 'Ariyalur sedimentary limestone rocks preserve million-year-old dinosaur egg fossils, fossilized marine ammonites, and sea shells, alongside Rajendra Chola imperial Gangaikonda Cholapuram temple.',
           cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Gangaikonda_Cholapuram_Temple_Airavatesvara.jpg?width=800',
           media_type = 'image'
       WHERE district_id = 29`
    );

    // D. Clean up any remaining sample.jpg or broken placeholders across all facts
    await db.query(
      `UPDATE district_facts 
       SET cloudinary_media_url = 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=80'
       WHERE cloudinary_media_url LIKE '%sample.jpg' OR cloudinary_media_url IS NULL`
    );

    await db.query(
      `UPDATE locality_facts 
       SET cloudinary_media_url = 'https://images.unsplash.com/photo-1596178065887-1198b6148b2b?auto=format&fit=crop&w=1200&q=80'
       WHERE cloudinary_media_url LIKE '%sample.jpg' OR cloudinary_media_url IS NULL`
    );

    console.log(`[Media Sync] Successfully processed ${districtUpdated} district facts and ${localityUpdated} locality facts.`);

    if (res) {
      return res.json({
        success: true,
        message: 'Successfully updated all 38 districts and localities with authentic cultural photography, foods, monuments and videos.',
        district_facts_updated: districtUpdated,
        locality_facts_updated: localityUpdated,
      });
    }
  } catch (err) {
    console.error('[Media Sync Error]:', err.message);
    if (res) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }
};


