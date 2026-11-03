const axios = require('axios');
const FormData = require('form-data');
const db = require('../config/db');
const { uploadMediaStream, cloudinary } = require('../config/cloudinary');

const RECOGNIZER_URL = process.env.RECOGNIZER_SERVICE_URL || 'http://localhost:8000';

function extractPublicId(url) {
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

/**
 * 1. Get all Hindu Gods & Deities
 */
exports.getAllGods = async (req, res) => {
  try {
    const result = await db.query(
      `SELECT * FROM gods WHERE is_active = true ORDER BY id ASC`
    );
    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows,
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

/**
 * 2. Get single God by ID
 */
exports.getGodById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('SELECT * FROM gods WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'God not found' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

/**
 * 3. Create / Register a new God (with Image and MP3 Audio)
 */
exports.createGod = async (req, res) => {
  try {
    const {
      name,
      god_code,
      title,
      description,
      mantra_sloka,
      glow_color = '#FFD700',
      audio_title,
    } = req.body;

    if (!name || !god_code) {
      return res.status(400).json({
        success: false,
        message: 'God name and unique god code are required.',
      });
    }

    const cleanCode = god_code.trim().toUpperCase();

    // Check if files attached
    const imageFile = req.files && req.files.image ? req.files.image[0] : req.file;
    const audioFile = req.files && req.files.audio ? req.files.audio[0] : null;

    if (!imageFile) {
      return res.status(400).json({
        success: false,
        message: 'A reference image/coloring book drawing is required for computer vision matching.',
      });
    }

    // Step A: Upload Deity / Coloring Image to Cloudinary (folder: facts_vision/gods/images)
    console.log(`[God Registration] Uploading image for ${name} to Cloudinary...`);
    const imageUpload = await uploadMediaStream(imageFile.buffer, 'facts_vision/gods/images', 'image');

    // Step B: Upload Devotional MP3 Audio to Cloudinary (folder: facts_vision/gods/audio)
    let audioUrl = null;
    let audioPublicId = null;

    if (audioFile) {
      console.log(`[God Registration] Uploading audio (${audioFile.size} bytes) for ${name} to Cloudinary...`);
      const audioUpload = await uploadMediaStream(audioFile.buffer, 'facts_vision/gods/audio', 'video');
      audioUrl = audioUpload.secure_url;
      audioPublicId = audioUpload.public_id;
    } else if (req.body.cloudinary_audio_url) {
      audioUrl = req.body.cloudinary_audio_url;
      audioPublicId = extractPublicId(audioUrl);
    }

    // Step C: Send Reference Image to Python OpenCV Recognizer for Keypoint Indexing
    try {
      console.log(`[God OpenCV] Indexing keypoints for ${cleanCode}...`);
      const form = new FormData();
      form.append('landmark_code', cleanCode);
      form.append('file', imageFile.buffer, {
        filename: `${cleanCode}.jpg`,
        contentType: imageFile.mimetype || 'image/jpeg',
      });

      await axios.post(`${RECOGNIZER_URL}/register-reference`, form, {
        headers: form.getHeaders(),
        timeout: 10000,
      });
      console.log(`[God OpenCV] Successfully indexed ${cleanCode} in OpenCV memory!`);
    } catch (recErr) {
      console.warn(`[God Warning] OpenCV recognizer sync issue:`, recErr.message);
    }

    // Step D: Insert into Database
    const result = await db.query(
      `INSERT INTO gods 
       (name, god_code, title, description, mantra_sloka, glow_color, 
        cloudinary_image_url, cloudinary_image_public_id, 
        cloudinary_audio_url, cloudinary_audio_public_id, audio_title)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [
        name.trim(),
        cleanCode,
        title || `${name} - Divine Coloring Book`,
        description,
        mantra_sloka,
        glow_color || '#FFD700',
        imageUpload.secure_url,
        imageUpload.public_id,
        audioUrl,
        audioPublicId,
        audio_title || `${name} Devotional Audio`,
      ]
    );

    res.status(201).json({
      success: true,
      message: `Deity "${name}" registered successfully with visual index & audio!`,
      data: result.rows[0],
    });
  } catch (err) {
    if (err.code === '23505' || err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ success: false, message: 'God code already exists.' });
    }
    res.status(500).json({ success: false, error: err.message });
  }
};

/**
 * 4. Update an existing God (Media replacement syncs with Cloudinary & DB)
 */
exports.updateGod = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      name,
      god_code,
      title,
      description,
      mantra_sloka,
      glow_color,
      audio_title,
    } = req.body;

    const existingRes = await db.query('SELECT * FROM gods WHERE id = $1', [id]);
    if (existingRes.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'God not found' });
    }

    const current = existingRes.rows[0];
    const cleanCode = god_code ? god_code.trim().toUpperCase() : current.god_code;

    let imageUrl = current.cloudinary_image_url;
    let imagePublicId = current.cloudinary_image_public_id;
    let audioUrl = current.cloudinary_audio_url;
    let audioPublicId = current.cloudinary_audio_public_id;

    const imageFile = req.files && req.files.image ? req.files.image[0] : null;
    const audioFile = req.files && req.files.audio ? req.files.audio[0] : null;

    // Handle Image Replacement
    if (imageFile) {
      // 1. Destroy old image in Cloudinary
      const oldImgPid = current.cloudinary_image_public_id || extractPublicId(current.cloudinary_image_url);
      if (oldImgPid) {
        try {
          await cloudinary.uploader.destroy(oldImgPid, { resource_type: 'image' });
        } catch (_) {}
      }

      // 2. Upload new image
      const imageUpload = await uploadMediaStream(imageFile.buffer, 'facts_vision/gods/images', 'image');
      imageUrl = imageUpload.secure_url;
      imagePublicId = imageUpload.public_id;

      // 3. Re-index in OpenCV
      try {
        const form = new FormData();
        form.append('landmark_code', cleanCode);
        form.append('file', imageFile.buffer, {
          filename: `${cleanCode}.jpg`,
          contentType: imageFile.mimetype || 'image/jpeg',
        });
        await axios.post(`${RECOGNIZER_URL}/register-reference`, form, {
          headers: form.getHeaders(),
          timeout: 10000,
        });
      } catch (recErr) {
        console.warn(`[God Update] OpenCV sync notice:`, recErr.message);
      }
    }

    // Handle Audio Replacement
    if (audioFile) {
      // 1. Destroy old audio in Cloudinary
      const oldAudioPid = current.cloudinary_audio_public_id || extractPublicId(current.cloudinary_audio_url);
      if (oldAudioPid) {
        try {
          await cloudinary.uploader.destroy(oldAudioPid, { resource_type: 'video' });
        } catch (_) {}
      }

      // 2. Upload new audio
      const audioUpload = await uploadMediaStream(audioFile.buffer, 'facts_vision/gods/audio', 'video');
      audioUrl = audioUpload.secure_url;
      audioPublicId = audioUpload.public_id;
    }

    // Update in Database
    const updated = await db.query(
      `UPDATE gods 
       SET name = COALESCE($1, name),
           god_code = COALESCE($2, god_code),
           title = COALESCE($3, title),
           description = COALESCE($4, description),
           mantra_sloka = COALESCE($5, mantra_sloka),
           glow_color = COALESCE($6, glow_color),
           audio_title = COALESCE($7, audio_title),
           cloudinary_image_url = $8,
           cloudinary_image_public_id = $9,
           cloudinary_audio_url = $10,
           cloudinary_audio_public_id = $11
       WHERE id = $12
       RETURNING *`,
      [
        name ? name.trim() : null,
        cleanCode,
        title,
        description,
        mantra_sloka,
        glow_color,
        audio_title,
        imageUrl,
        imagePublicId,
        audioUrl,
        audioPublicId,
        id,
      ]
    );

    res.json({
      success: true,
      message: 'Deity details updated successfully in both Cloudinary and Database.',
      data: updated.rows[0],
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

/**
 * 5. Delete God (Permanently removes image and audio from Cloudinary & DB)
 */
exports.deleteGod = async (req, res) => {
  try {
    const { id } = req.params;
    const existing = await db.query('SELECT * FROM gods WHERE id = $1', [id]);
    if (existing.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'God not found' });
    }

    const row = existing.rows[0];

    // Destroy Cloudinary Image
    const imgPid = row.cloudinary_image_public_id || extractPublicId(row.cloudinary_image_url);
    if (imgPid) {
      try {
        await cloudinary.uploader.destroy(imgPid, { resource_type: 'image' });
      } catch (_) {}
    }

    // Destroy Cloudinary Audio
    const audioPid = row.cloudinary_audio_public_id || extractPublicId(row.cloudinary_audio_url);
    if (audioPid) {
      try {
        await cloudinary.uploader.destroy(audioPid, { resource_type: 'video' });
      } catch (_) {}
    }

    // Delete row from Database
    await db.query('DELETE FROM gods WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'Deity, reference image, and MP3 audio permanently removed from Cloudinary and Database.',
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

/**
 * 6. Sync all active God reference images with Python OpenCV Recognizer
 */
exports.syncGodsWithRecognizer = async (req, res) => {
  try {
    const result = await db.query('SELECT god_code, cloudinary_image_url FROM gods WHERE is_active = true');
    let synced = 0;
    const errors = [];

    for (const g of result.rows) {
      if (!g.cloudinary_image_url) continue;
      try {
        const imgRes = await axios.get(g.cloudinary_image_url, { responseType: 'arraybuffer' });
        const form = new FormData();
        form.append('landmark_code', g.god_code);
        form.append('file', Buffer.from(imgRes.data), {
          filename: `${g.god_code}.jpg`,
          contentType: 'image/jpeg',
        });

        await axios.post(`${RECOGNIZER_URL}/register-reference`, form, {
          headers: form.getHeaders(),
          timeout: 10000,
        });
        synced++;
      } catch (err) {
        errors.push({ code: g.god_code, error: err.message });
      }
    }

    res.json({
      success: true,
      message: `Synced ${synced} deities into OpenCV feature memory.`,
      synced_count: synced,
      total_in_db: result.rows.length,
      errors,
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

