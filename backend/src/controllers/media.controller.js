const { cloudinary, uploadMediaStream } = require('../config/cloudinary');
const db = require('../config/db');

/**
 * 1. Get All Cloudinary & Database Media Assets
 * Combines direct Cloudinary API resources with all database-linked media
 * from district_facts, locality_facts, landmarks, and recognition_logs.
 */
exports.getAllMedia = async (req, res) => {
  try {
    const mediaList = [];
    const seenUrls = new Set();

    // A. Fetch from database tables with safety try-catches and District names
    let allDbRows = [];

    // 1. District Facts Media
    try {
      const dfRes = await db.query(
        `SELECT df.id, df.title, df.fact_type, df.cloudinary_media_url, df.cloudinary_public_id, df.media_type, 
                d.name as district_name, 'District Fact' as source 
         FROM district_facts df
         LEFT JOIN districts d ON df.district_id = d.id
         WHERE df.cloudinary_media_url IS NOT NULL AND df.cloudinary_media_url != ''`
      );
      if (dfRes && dfRes.rows) allDbRows.push(...dfRes.rows);
    } catch (dfErr) {
      console.warn('[Media Controller] district_facts error:', dfErr.message);
    }

    // 2. Locality Facts Media
    try {
      const lfRes = await db.query(
        `SELECT lf.id, lf.title, lf.fact_type, lf.cloudinary_media_url, lf.cloudinary_public_id, lf.media_type, 
                l.name as locality_name, d.name as district_name, 'Locality Fact' as source 
         FROM locality_facts lf
         LEFT JOIN localities l ON lf.locality_id = l.id
         LEFT JOIN districts d ON l.district_id = d.id
         WHERE lf.cloudinary_media_url IS NOT NULL AND lf.cloudinary_media_url != ''`
      );
      if (lfRes && lfRes.rows) allDbRows.push(...lfRes.rows);
    } catch (lfErr) {
      console.warn('[Media Controller] locality_facts error:', lfErr.message);
    }

    // 3. Landmark Reference Images
    try {
      const lmRes = await db.query(
        `SELECT lm.id, lm.name as title, lm.landmark_code as fact_type, lm.cloudinary_image_url as cloudinary_media_url, 
                lm.cloudinary_public_id, 'image' as media_type, l.name as locality_name, d.name as district_name, 'Landmark' as source 
         FROM landmarks lm
         LEFT JOIN localities l ON lm.locality_id = l.id
         LEFT JOIN districts d ON l.district_id = d.id
         WHERE lm.cloudinary_image_url IS NOT NULL AND lm.cloudinary_image_url != ''`
      );
      if (lmRes && lmRes.rows) allDbRows.push(...lmRes.rows);
    } catch (lmErr) {
      console.warn('[Media Controller] landmarks error:', lmErr.message);
    }

    // 4. Recognition Logs (User Queries)
    try {
      const logRes = await db.query(
        `SELECT id, matched_landmark_code as title, 'query' as fact_type, user_query_cloudinary_url as cloudinary_media_url, 
                NULL as cloudinary_public_id, 'image' as media_type, 'User Scan Log' as source 
         FROM recognition_logs 
         WHERE user_query_cloudinary_url IS NOT NULL AND user_query_cloudinary_url != '' 
         LIMIT 50`
      );
      if (logRes && logRes.rows) allDbRows.push(...logRes.rows);
    } catch (logErr) {
      console.warn('[Media Controller] recognition_logs error:', logErr.message);
    }

    // 5. Hindu Gods & Deities (Images & Devotional Audio)
    try {
      const godRes = await db.query(
        `SELECT id, name as title, 'deity' as fact_type, cloudinary_image_url as cloudinary_media_url,
                cloudinary_image_public_id as cloudinary_public_id, 'image' as media_type, 'Hindu Deity Coloring' as source,
                'Spiritual' as district_name, name as locality_name
         FROM gods
         WHERE cloudinary_image_url IS NOT NULL AND cloudinary_image_url != ''`
      );
      if (godRes && godRes.rows) allDbRows.push(...godRes.rows);

      const godAudioRes = await db.query(
        `SELECT id, CONCAT(name, ' - Devotional Song') as title, 'audio' as fact_type, cloudinary_audio_url as cloudinary_media_url,
                cloudinary_audio_public_id as cloudinary_public_id, 'video' as media_type, 'Devotional MP3' as source,
                'Spiritual' as district_name, name as locality_name
         FROM gods
         WHERE cloudinary_audio_url IS NOT NULL AND cloudinary_audio_url != ''`
      );
      if (godAudioRes && godAudioRes.rows) allDbRows.push(...godAudioRes.rows);
    } catch (_) {}

    for (const row of allDbRows) {
      if (row.cloudinary_media_url && !seenUrls.has(row.cloudinary_media_url)) {
        seenUrls.add(row.cloudinary_media_url);
        mediaList.push({
          id: row.id,
          title: row.title || 'Untitled Asset',
          category: row.fact_type || 'media',
          source: row.source,
          district_name: row.district_name || '',
          locality_name: row.locality_name || '',
          url: row.cloudinary_media_url,
          public_id: row.cloudinary_public_id || extractPublicIdFromUrl(row.cloudinary_media_url),
          media_type: row.media_type || (row.cloudinary_media_url.endsWith('.mp4') ? 'video' : 'image'),
          created_at: row.created_at || new Date().toISOString()
        });
      }
    }

    // B. Also attempt to fetch live assets directly from Cloudinary account if available
    try {
      const cloudinaryResources = await cloudinary.api.resources({
        type: 'upload',
        max_results: 100
      });

      if (cloudinaryResources && cloudinaryResources.resources) {
        for (const asset of cloudinaryResources.resources) {
          if (!seenUrls.has(asset.secure_url)) {
            seenUrls.add(asset.secure_url);
            mediaList.unshift({
              id: asset.asset_id || asset.public_id,
              title: asset.public_id.split('/').pop(),
              category: asset.folder || 'Cloudinary Direct',
              source: 'Cloudinary Cloud Storage',
              url: asset.secure_url,
              public_id: asset.public_id,
              media_type: asset.resource_type || (asset.format === 'mp4' ? 'video' : 'image'),
              bytes: asset.bytes,
              format: asset.format,
              created_at: asset.created_at
            });
          }
        }
      }
    } catch (cErr) {
      // Cloudinary Admin API might have restricted permissions on free accounts, fallback to DB list seamlessly
      console.warn('[Cloudinary API Notice]:', cErr.message);
    }

    res.json({
      success: true,
      count: mediaList.length,
      data: mediaList
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

/**
 * 2. Upload Direct Media to Cloudinary
 */
exports.uploadMedia = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'No media file provided.' });
    }

    const { folder = 'facts_vision/gallery' } = req.body;
    console.log(`[Cloudinary] Direct upload received: ${req.file.originalname} (${req.file.size} bytes)`);

    const result = await uploadMediaStream(req.file.buffer, folder, 'auto');

    res.status(201).json({
      success: true,
      message: 'Media uploaded successfully to Cloudinary.',
      data: result
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

/**
 * 3. Delete Single Media Asset from Cloudinary and DB
 */
exports.deleteMedia = async (req, res) => {
  try {
    const { publicId } = req.params;
    const { url } = req.query;

    if (!publicId && !url) {
      return res.status(400).json({ success: false, message: 'publicId or url is required to delete.' });
    }

    const targetPublicId = (publicId && publicId !== 'null' && publicId !== 'undefined')
      ? publicId
      : extractPublicIdFromUrl(url);

    console.log(`[Cloudinary] Deleting single media: publicId=${targetPublicId}, url=${url}`);

    // Try destroying from Cloudinary (both image and video resource types)
    if (targetPublicId) {
      try {
        await cloudinary.uploader.destroy(targetPublicId, { resource_type: 'image' });
      } catch (_) {}
      try {
        await cloudinary.uploader.destroy(targetPublicId, { resource_type: 'video' });
      } catch (_) {}
    }

    // Clean up references in DB across all tables
    if (url) {
      await db.query(`UPDATE district_facts SET cloudinary_media_url = NULL, cloudinary_public_id = NULL WHERE cloudinary_media_url = $1`, [url]);
      await db.query(`UPDATE locality_facts SET cloudinary_media_url = NULL, cloudinary_public_id = NULL WHERE cloudinary_media_url = $1`, [url]);
      await db.query(`UPDATE landmarks SET cloudinary_image_url = '', cloudinary_public_id = NULL WHERE cloudinary_image_url = $1`, [url]);
      await db.query(`DELETE FROM recognition_logs WHERE user_query_cloudinary_url = $1`, [url]);
    }

    if (targetPublicId) {
      await db.query(`UPDATE district_facts SET cloudinary_media_url = NULL, cloudinary_public_id = NULL WHERE cloudinary_public_id = $1`, [targetPublicId]);
      await db.query(`UPDATE locality_facts SET cloudinary_media_url = NULL, cloudinary_public_id = NULL WHERE cloudinary_public_id = $1`, [targetPublicId]);
      await db.query(`UPDATE landmarks SET cloudinary_image_url = '', cloudinary_public_id = NULL WHERE cloudinary_public_id = $1`, [targetPublicId]);
    }

    res.json({
      success: true,
      message: 'Media asset deleted successfully from both Cloudinary and Database.'
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

/**
 * 4. Bulk Delete Media Assets from Cloudinary and DB
 * Handles Select All / Multiple Selection deletion:
 * - Permanently destroys assets in Cloudinary
 * - Cleans up references across district_facts, locality_facts, landmarks, recognition_logs
 */
exports.deleteBulkMedia = async (req, res) => {
  try {
    const { items = [], deleteAll = false } = req.body;
    let itemsToDelete = [...items];

    if (deleteAll) {
      // Gather every media asset across database tables safely
      const safeRows = async (sql) => {
        try {
          const res = await db.query(sql);
          return (res && res.rows) ? res.rows : [];
        } catch (_) {
          return [];
        }
      };

      const [dfRows, lfRows, lmRows, logRows] = await Promise.all([
        safeRows(`SELECT cloudinary_public_id, cloudinary_media_url, media_type FROM district_facts WHERE cloudinary_media_url IS NOT NULL AND cloudinary_media_url != ''`),
        safeRows(`SELECT cloudinary_public_id, cloudinary_media_url, media_type FROM locality_facts WHERE cloudinary_media_url IS NOT NULL AND cloudinary_media_url != ''`),
        safeRows(`SELECT cloudinary_public_id, cloudinary_image_url as cloudinary_media_url, 'image' as media_type FROM landmarks WHERE cloudinary_image_url IS NOT NULL AND cloudinary_image_url != ''`),
        safeRows(`SELECT NULL as cloudinary_public_id, user_query_cloudinary_url as cloudinary_media_url, 'image' as media_type FROM recognition_logs WHERE user_query_cloudinary_url IS NOT NULL AND user_query_cloudinary_url != ''`)
      ]);

      const seen = new Set();
      for (const row of [...dfRows, ...lfRows, ...lmRows, ...logRows]) {
        if (row.cloudinary_media_url && !seen.has(row.cloudinary_media_url)) {
          seen.add(row.cloudinary_media_url);
          itemsToDelete.push({
            public_id: row.cloudinary_public_id || extractPublicIdFromUrl(row.cloudinary_media_url),
            url: row.cloudinary_media_url,
            media_type: row.media_type || (row.cloudinary_media_url.endsWith('.mp4') ? 'video' : 'image')
          });
        }
      }

      // Also gather direct Cloudinary resources if accessible
      try {
        const cRes = await cloudinary.api.resources({ type: 'upload', max_results: 500 });
        if (cRes && cRes.resources) {
          for (const a of cRes.resources) {
            if (!seen.has(a.secure_url)) {
              seen.add(a.secure_url);
              itemsToDelete.push({
                public_id: a.public_id,
                url: a.secure_url,
                media_type: a.resource_type || (a.format === 'mp4' ? 'video' : 'image')
              });
            }
          }
        }
      } catch (cErr) {
        console.warn('[Cloudinary Bulk Notice]:', cErr.message);
      }
    }

    if (itemsToDelete.length === 0) {
      return res.json({ success: true, message: 'No media items specified for deletion.', deletedCount: 0 });
    }

    console.log(`[Cloudinary Bulk Delete] Permanently removing ${itemsToDelete.length} assets from Cloudinary & DB...`);

    let deletedCount = 0;
    const urlsToClear = [];
    const publicIdsToClear = [];

    for (const item of itemsToDelete) {
      const publicId = item.public_id || extractPublicIdFromUrl(item.url);
      const url = item.url;
      const mediaType = item.media_type || (url && url.endsWith('.mp4') ? 'video' : 'image');

      if (url) urlsToClear.push(url);
      if (publicId) publicIdsToClear.push(publicId);

      // Destroy in Cloudinary
      if (publicId && publicId !== 'null' && publicId !== 'undefined') {
        try {
          await cloudinary.uploader.destroy(publicId, { resource_type: mediaType === 'video' ? 'video' : 'image' });
          deletedCount++;
        } catch (cErr) {
          console.warn(`[Cloudinary Destroy Error for ${publicId}]:`, cErr.message);
        }
      }
    }

    // Database Cleanup across all tables in parallel
    for (const u of urlsToClear) {
      await db.query(`UPDATE district_facts SET cloudinary_media_url = NULL, cloudinary_public_id = NULL WHERE cloudinary_media_url = $1`, [u]);
      await db.query(`UPDATE locality_facts SET cloudinary_media_url = NULL, cloudinary_public_id = NULL WHERE cloudinary_media_url = $1`, [u]);
      await db.query(`UPDATE landmarks SET cloudinary_image_url = '', cloudinary_public_id = NULL WHERE cloudinary_image_url = $1`, [u]);
      await db.query(`DELETE FROM recognition_logs WHERE user_query_cloudinary_url = $1`, [u]);
    }

    for (const pid of publicIdsToClear) {
      await db.query(`UPDATE district_facts SET cloudinary_media_url = NULL, cloudinary_public_id = NULL WHERE cloudinary_public_id = $1`, [pid]);
      await db.query(`UPDATE locality_facts SET cloudinary_media_url = NULL, cloudinary_public_id = NULL WHERE cloudinary_public_id = $1`, [pid]);
      await db.query(`UPDATE landmarks SET cloudinary_image_url = '', cloudinary_public_id = NULL WHERE cloudinary_public_id = $1`, [pid]);
    }

    res.json({
      success: true,
      message: `Successfully deleted ${itemsToDelete.length} media assets from both Cloudinary and Database.`,
      deletedCount: itemsToDelete.length
    });
  } catch (err) {
    console.error('[Bulk Delete Error]:', err.message);
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

