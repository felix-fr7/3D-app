const db = require('../config/db');
const { uploadMediaStream } = require('../config/cloudinary');

// 1. Get all localities (can filter by district_id)
exports.getAllLocalities = async (req, res) => {
  try {
    const { district_id } = req.query;
    let queryText = `
      SELECT l.*, d.name as district_name,
             (SELECT COUNT(*) FROM locality_facts lf WHERE lf.locality_id = l.id) as facts_count
      FROM localities l
      JOIN districts d ON l.district_id = d.id
    `;
    const params = [];

    if (district_id) {
      queryText += ' WHERE l.district_id = $1';
      params.push(district_id);
    }

    queryText += ' ORDER BY l.name ASC';

    const result = await db.query(queryText, params);
    res.json({ success: true, count: result.rows.length, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 2. Get single locality with all its locality facts
exports.getLocalityById = async (req, res) => {
  try {
    const { id } = req.params;
    const localityRes = await db.query(
      `SELECT l.*, d.name as district_name 
       FROM localities l
       JOIN districts d ON l.district_id = d.id
       WHERE l.id = $1`,
      [id]
    );

    if (localityRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Locality not found' });
    }

    const factsRes = await db.query(
      'SELECT * FROM locality_facts WHERE locality_id = $1 ORDER BY id ASC',
      [id]
    );

    res.json({
      success: true,
      data: {
        ...localityRes.rows[0],
        locality_facts: factsRes.rows,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 3. Create a new Locality under a District
exports.createLocality = async (req, res) => {
  try {
    const { district_id, name, pincode, latitude, longitude, description } = req.body;
    if (!district_id || !name) {
      return res.status(400).json({ success: false, message: 'district_id and name are required.' });
    }

    const result = await db.query(
      `INSERT INTO localities (district_id, name, pincode, latitude, longitude, description)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [district_id, name.trim(), pincode, latitude || null, longitude || null, description]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 4. Add a Locality Fact (with Cloudinary media upload: image/video/gif)
exports.addLocalityFact = async (req, res) => {
  try {
    const { locality_id, title, fact_type, content } = req.body;
    if (!locality_id || !title || !content) {
      return res.status(400).json({
        success: false,
        message: 'locality_id, title, and content are required.',
      });
    }

    let cloudinaryUrl = null;
    let cloudinaryPublicId = null;
    let mediaType = 'none';

    // If an image, video, or gif file was uploaded:
    if (req.file) {
      console.log(`[Cloudinary] Uploading locality fact media (${req.file.mimetype})...`);
      const uploadRes = await uploadMediaStream(req.file.buffer, 'facts_vision/locality_facts', 'auto');
      cloudinaryUrl = uploadRes.secure_url;
      cloudinaryPublicId = uploadRes.public_id;
      mediaType = req.file.mimetype.startsWith('video/') ? 'video' : req.file.mimetype.includes('gif') ? 'gif' : 'image';
    }

    // Insert only Cloudinary URL into PostgreSQL (Strict rule)
    const result = await db.query(
      `INSERT INTO locality_facts 
       (locality_id, title, fact_type, content, cloudinary_media_url, cloudinary_public_id, media_type)
       VALUES ($1, $2, COALESCE($3, 'specialty'), $4, $5, $6, $7)
       RETURNING *`,
      [locality_id, title, fact_type, content, cloudinaryUrl, cloudinaryPublicId, mediaType]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 5. Update a Locality Fact (Syncs changes in DB and Cloudinary)
exports.updateLocalityFact = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, fact_type, content } = req.body;

    const existingRes = await db.query('SELECT * FROM locality_facts WHERE id = $1', [id]);
    if (existingRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Locality fact not found' });
    }

    const currentFact = existingRes.rows[0];
    let cloudinaryUrl = currentFact.cloudinary_media_url;
    let cloudinaryPublicId = currentFact.cloudinary_public_id;
    let mediaType = currentFact.media_type;

    if (req.file) {
      // 1. Permanently destroy old media in Cloudinary so orphaned assets don't remain
      const oldPublicId = currentFact.cloudinary_public_id || extractPublicIdFromUrl(currentFact.cloudinary_media_url);
      if (oldPublicId) {
        try {
          const { cloudinary } = require('../config/cloudinary');
          await cloudinary.uploader.destroy(oldPublicId, {
            resource_type: currentFact.media_type === 'video' ? 'video' : 'image'
          });
          console.log(`[Cloudinary] Old media destroyed for Locality Fact #${id}: ${oldPublicId}`);
        } catch (cErr) {
          console.warn('[Cloudinary Destroy Old Media Notice]:', cErr.message);
        }
      }

      // 2. Upload replacement media to Cloudinary
      console.log(`[Cloudinary] Replacing media for Locality Fact #${id}...`);
      const uploadRes = await uploadMediaStream(req.file.buffer, 'facts_vision/locality_facts', 'auto');
      cloudinaryUrl = uploadRes.secure_url;
      cloudinaryPublicId = uploadRes.public_id;
      mediaType = req.file.mimetype.startsWith('video/') ? 'video' : req.file.mimetype.includes('gif') ? 'gif' : 'image';
    }

    const updatedRes = await db.query(
      `UPDATE locality_facts 
       SET title = COALESCE($1, title),
           fact_type = COALESCE($2, fact_type),
           content = COALESCE($3, content),
           cloudinary_media_url = $4,
           cloudinary_public_id = $5,
           media_type = $6
       WHERE id = $7
       RETURNING *`,
      [title, fact_type, content, cloudinaryUrl, cloudinaryPublicId, mediaType, id]
    );

    res.json({
      success: true,
      message: 'Locality fact updated successfully in both Cloudinary and Database.',
      data: updatedRes.rows[0]
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 6. Delete a Locality Fact (Syncs deletion across both Cloudinary and DB)
exports.deleteLocalityFact = async (req, res) => {
  try {
    const { id } = req.params;
    const existingRes = await db.query('SELECT * FROM locality_facts WHERE id = $1', [id]);
    if (existingRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Locality fact not found' });
    }

    const fact = existingRes.rows[0];
    const targetPublicId = fact.cloudinary_public_id || extractPublicIdFromUrl(fact.cloudinary_media_url);

    // 1. Destroy asset in Cloudinary
    if (targetPublicId) {
      try {
        const { cloudinary } = require('../config/cloudinary');
        await cloudinary.uploader.destroy(targetPublicId, {
          resource_type: fact.media_type === 'video' ? 'video' : 'image'
        });
        console.log(`[Cloudinary] Asset permanently destroyed for Locality Fact #${id}: ${targetPublicId}`);
      } catch (cErr) {
        console.warn('[Cloudinary Destroy Notice]:', cErr.message);
      }
    }

    // 2. Delete row from Database
    await db.query('DELETE FROM locality_facts WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'Locality fact deleted successfully from both Cloudinary and Database.'
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 7. Delete a Locality (and cascade its facts & Cloudinary assets)
exports.deleteLocality = async (req, res) => {
  try {
    const { id } = req.params;

    // Destroy all attached Cloudinary assets for this locality's facts
    try {
      const factsRes = await db.query('SELECT cloudinary_public_id, cloudinary_media_url, media_type FROM locality_facts WHERE locality_id = $1', [id]);
      const { cloudinary } = require('../config/cloudinary');
      for (const f of factsRes.rows) {
        const pid = f.cloudinary_public_id || extractPublicIdFromUrl(f.cloudinary_media_url);
        if (pid) {
          try {
            await cloudinary.uploader.destroy(pid, { resource_type: f.media_type === 'video' ? 'video' : 'image' });
          } catch (_) {}
        }
      }
    } catch (cErr) {
      console.warn('[Cloudinary Locality Cascade Notice]:', cErr.message);
    }

    await db.query('DELETE FROM locality_facts WHERE locality_id = $1', [id]);
    await db.query('DELETE FROM landmarks WHERE locality_id = $1', [id]);
    const deleteRes = await db.query('DELETE FROM localities WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'Locality and its associated media assets removed successfully from both Cloudinary and Database.'
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

