const axios = require('axios');
const FormData = require('form-data');
const db = require('../config/db');
const { uploadMediaStream } = require('../config/cloudinary');

const RECOGNIZER_URL = process.env.RECOGNIZER_SERVICE_URL || 'http://localhost:8000';

// 1. Get all landmarks
exports.getAllLandmarks = async (req, res) => {
  try {
    const result = await db.query(
      `SELECT lm.*, l.name as locality_name, d.name as district_name
       FROM landmarks lm
       JOIN localities l ON lm.locality_id = l.id
       JOIN districts d ON l.district_id = d.id
       ORDER BY lm.id DESC`
    );
    res.json({ success: true, count: result.rows.length, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 2. Register a new Landmark with Reference Image
// Flow:
// a) Upload reference photo to Cloudinary
// b) Forward reference photo to Python Recognizer (OpenCV indexes keypoints)
// c) Save metadata & Cloudinary URL into PostgreSQL
exports.createLandmark = async (req, res) => {
  try {
    const { locality_id, name, landmark_code, description } = req.body;
    if (!locality_id || !name || !landmark_code) {
      return res.status(400).json({
        success: false,
        message: 'locality_id, name, and landmark_code are required.',
      });
    }

    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'Reference image file is required for landmark OpenCV indexing.',
      });
    }

    const cleanCode = landmark_code.trim().toUpperCase();

    // Step A: Upload reference image to Cloudinary
    console.log(`[Landmark] Uploading reference photo for ${cleanCode} to Cloudinary...`);
    const cloudinaryRes = await uploadMediaStream(
      req.file.buffer,
      'facts_vision/reference_landmarks',
      'image'
    );

    // Step B: Send reference image to Python OpenCV Recognizer Service
    try {
      console.log(`[Landmark] Registering reference features with Python Recognizer...`);
      const form = new FormData();
      form.append('landmark_code', cleanCode);
      form.append('file', req.file.buffer, {
        filename: `${cleanCode}.jpg`,
        contentType: req.file.mimetype || 'image/jpeg',
      });

      await axios.post(`${RECOGNIZER_URL}/register-reference`, form, {
        headers: form.getHeaders(),
        timeout: 8000,
      });
      console.log(`[Landmark] Successfully indexed in OpenCV memory!`);
    } catch (recErr) {
      console.warn(`[Landmark Warning] Could not sync with Python Recognizer:`, recErr.message);
    }

    // Step C: Save in PostgreSQL (Only URL, no raw bytes)
    const result = await db.query(
      `INSERT INTO landmarks 
       (locality_id, name, landmark_code, description, cloudinary_image_url, cloudinary_public_id)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [locality_id, name.trim(), cleanCode, description, cloudinaryRes.secure_url, cloudinaryRes.public_id]
    );

    res.status(201).json({
      success: true,
      message: 'Landmark registered and indexed successfully.',
      data: result.rows[0],
    });
  } catch (err) {
    if (err.code === '23505' || err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ success: false, message: 'Landmark code already exists.' });
    }
    res.status(500).json({ success: false, error: err.message });
  }
};

// 3. Rebuild / Sync All Database Landmarks with Python OpenCV Recognizer
exports.syncLandmarksWithRecognizer = async (req, res) => {
  try {
    const result = await db.query(
      `SELECT landmark_code, cloudinary_image_url 
       FROM landmarks 
       WHERE is_active = true`
    );

    let synced = 0;
    const errors = [];

    for (const lm of result.rows) {
      if (!lm.cloudinary_image_url) continue;
      try {
        console.log(`[Sync] Downloading ${lm.landmark_code} from Cloudinary...`);
        const imgRes = await axios.get(lm.cloudinary_image_url, { responseType: 'arraybuffer' });
        
        const form = new FormData();
        form.append('landmark_code', lm.landmark_code);
        form.append('file', Buffer.from(imgRes.data), {
          filename: `${lm.landmark_code}.jpg`,
          contentType: 'image/jpeg',
        });

        await axios.post(`${RECOGNIZER_URL}/register-reference`, form, {
          headers: form.getHeaders(),
          timeout: 10000,
        });
        synced++;
        console.log(`[Sync] Indexed ${lm.landmark_code} successfully!`);
      } catch (err) {
        console.warn(`[Sync Warning] Failed to index ${lm.landmark_code}:`, err.message);
        errors.push({ code: lm.landmark_code, error: err.message });
      }
    }

    res.json({
      success: true,
      message: `Successfully synced ${synced} landmarks into Python OpenCV memory.`,
      synced_count: synced,
      total_in_db: result.rows.length,
      errors,
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// 4. Update a Landmark (Syncs changes in DB and Cloudinary)
exports.updateLandmark = async (req, res) => {
  try {
    const { id } = req.params;
    const { locality_id, name, landmark_code, description } = req.body;

    const existingRes = await db.query('SELECT * FROM landmarks WHERE id = $1', [id]);
    if (existingRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Landmark not found.' });
    }

    const currentLm = existingRes.rows[0];
    let cloudinaryUrl = currentLm.cloudinary_image_url;
    let cloudinaryPublicId = currentLm.cloudinary_public_id;
    const cleanCode = landmark_code ? landmark_code.trim().toUpperCase() : currentLm.landmark_code;

    if (req.file) {
      // 1. Permanently destroy old reference image in Cloudinary
      const oldPid = currentLm.cloudinary_public_id || extractPublicIdFromUrl(currentLm.cloudinary_image_url);
      if (oldPid) {
        try {
          const { cloudinary } = require('../config/cloudinary');
          await cloudinary.uploader.destroy(oldPid, { resource_type: 'image' });
          console.log(`[Cloudinary] Old landmark photo destroyed for #${id}: ${oldPid}`);
        } catch (cErr) {
          console.warn('[Cloudinary Landmark Destroy Notice]:', cErr.message);
        }
      }

      // 2. Upload replacement reference photo to Cloudinary
      console.log(`[Cloudinary] Uploading new reference photo for Landmark #${id}...`);
      const uploadRes = await uploadMediaStream(req.file.buffer, 'facts_vision/reference_landmarks', 'image');
      cloudinaryUrl = uploadRes.secure_url;
      cloudinaryPublicId = uploadRes.public_id;

      // 3. Re-register keypoints in Python OpenCV Recognizer
      try {
        const form = new FormData();
        form.append('landmark_code', cleanCode);
        form.append('file', req.file.buffer, {
          filename: `${cleanCode}.jpg`,
          contentType: req.file.mimetype || 'image/jpeg',
        });
        await axios.post(`${RECOGNIZER_URL}/register-reference`, form, {
          headers: form.getHeaders(),
          timeout: 8000,
        });
        console.log(`[Landmark OpenCV] Updated keypoint index for ${cleanCode}`);
      } catch (recErr) {
        console.warn(`[Landmark Warning] OpenCV sync failed:`, recErr.message);
      }
    }

    const updatedRes = await db.query(
      `UPDATE landmarks 
       SET locality_id = COALESCE($1, locality_id),
           name = COALESCE($2, name),
           landmark_code = COALESCE($3, landmark_code),
           description = COALESCE($4, description),
           cloudinary_image_url = $5,
           cloudinary_public_id = $6
       WHERE id = $7
       RETURNING *`,
      [locality_id, name ? name.trim() : null, cleanCode, description, cloudinaryUrl, cloudinaryPublicId, id]
    );

    res.json({
      success: true,
      message: 'Landmark updated successfully in both Cloudinary and Database.',
      data: updatedRes.rows[0],
    });
  } catch (err) {
    if (err.code === '23505' || err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ success: false, message: 'Landmark code already exists.' });
    }
    res.status(500).json({ success: false, error: err.message });
  }
};

// 5. Delete a Landmark (Syncs deletion across Cloudinary & DB)
exports.deleteLandmark = async (req, res) => {
  try {
    const { id } = req.params;
    const existingRes = await db.query('SELECT * FROM landmarks WHERE id = $1', [id]);
    if (existingRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Landmark not found.' });
    }

    const lm = existingRes.rows[0];
    const targetPid = lm.cloudinary_public_id || extractPublicIdFromUrl(lm.cloudinary_image_url);

    // 1. Destroy asset in Cloudinary
    if (targetPid) {
      try {
        const { cloudinary } = require('../config/cloudinary');
        await cloudinary.uploader.destroy(targetPid, { resource_type: 'image' });
        console.log(`[Cloudinary] Asset permanently destroyed for Landmark #${id}: ${targetPid}`);
      } catch (cErr) {
        console.warn('[Cloudinary Landmark Destroy Notice]:', cErr.message);
      }
    }

    // 2. Delete row from Database
    await db.query('DELETE FROM landmarks WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'Landmark deleted successfully from both Cloudinary and Database.',
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

