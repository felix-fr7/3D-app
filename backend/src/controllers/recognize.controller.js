const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
const path = require('path');
const db = require('../config/db');
const { uploadMediaStream } = require('../config/cloudinary');

const RECOGNIZER_URL = process.env.RECOGNIZER_SERVICE_URL || 'http://localhost:8000';
const MIN_CONFIDENCE = parseFloat(process.env.MIN_RECOGNITION_CONFIDENCE || '0.35');

/**
 * Main Recognition Handler:
 * 1. Takes image buffer from mobile app.
 * 2. Forwards to Python OpenCV service for feature matching.
 * 3. If matched, retrieves strictly separated District Facts & Locality Facts from PostgreSQL.
 * 4. Logs audit information (uploading query image to Cloudinary for trace URL).
 */
exports.recognizeImage = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No image file provided. Please attach a photo in the form-data (key: image).',
      });
    }

    console.log(`[Recognition] Forwarding image (${req.file.size} bytes) to Python Recognizer...`);

    // 1. Prepare Multipart Form for Python FastAPI Service
    const formData = new FormData();
    formData.append('file', req.file.buffer, {
      filename: req.file.originalname || 'query.jpg',
      contentType: req.file.mimetype || 'image/jpeg',
    });

    // 2. Call Python OpenCV Microservice
    let recognizerResponse;
    try {
      recognizerResponse = await axios.post(`${RECOGNIZER_URL}/recognize`, formData, {
        headers: {
          ...formData.getHeaders(),
        },
        timeout: 10000, // 10 seconds timeout
      });
    } catch (recErr) {
      console.error('[Recognition] Python service error:', recErr.message);
      return res.status(502).json({
        success: false,
        message: 'Recognition service is temporarily unreachable or busy.',
        error: recErr.message,
      });
    }

    const { matched_code, confidence, good_matches_count, is_matched } = recognizerResponse.data;
    console.log(`[Recognition] Result: code=${matched_code}, confidence=${confidence}, is_matched=${is_matched}`);

    // If no match found or below confidence threshold
    if (!is_matched || !matched_code || confidence < MIN_CONFIDENCE) {
      return res.status(200).json({
        success: true,
        matched: false,
        confidence: confidence || 0.0,
        good_matches: good_matches_count || 0,
        message: 'Image not matched. Please Retry! (படம் பொருந்தவில்லை, மீண்டும் முயற்சி செய்யவும்)',
      });
    }

    // 3. Check if the recognized code belongs to a Hindu God / Deity
    const godResult = await db.query(
      `SELECT id, name, god_code, title, description, mantra_sloka, glow_color,
              cloudinary_image_url, cloudinary_audio_url, audio_title
       FROM gods
       WHERE god_code = $1 AND is_active = true`,
      [matched_code]
    );

    if (godResult.rows.length > 0) {
      const god = godResult.rows[0];

      // Pure in-memory recognition: NEVER upload user query photo to Cloudinary!
      // Optional: Log lightweight trace without uploading image bytes
      db.query(
        `INSERT INTO recognition_logs (matched_landmark_code, confidence_score, user_query_cloudinary_url, ip_address)
         VALUES ($1, $2, $3, $4)`,
        [matched_code, confidence, null, req.ip]
      ).catch(() => {});

      return res.status(200).json({
        success: true,
        matched: true,
        match_type: 'god',
        confidence: confidence,
        good_matches: good_matches_count,
        god: {
          id: god.id,
          name: god.name,
          code: god.god_code,
          title: god.title,
          description: god.description,
          mantra_sloka: god.mantra_sloka,
          glow_color: god.glow_color || '#FFD700',
          image_url: god.cloudinary_image_url,
          audio_url: (() => {
            if (god.cloudinary_audio_url && god.cloudinary_audio_url.startsWith('http')) {
              return god.cloudinary_audio_url;
            }
            const host = req.get('host') || '127.0.0.1:5000';
            const protocol = req.protocol || 'http';
            if (god.cloudinary_audio_url && god.cloudinary_audio_url.startsWith('/')) {
              return `${protocol}://${host}${god.cloudinary_audio_url}`;
            }
            const localAudioPath = path.join(__dirname, '..', '..', 'public', 'audio', `${god.god_code}.mp3`);
            if (fs.existsSync(localAudioPath)) {
              return `${protocol}://${host}/audio/${god.god_code}.mp3`;
            }
            return god.cloudinary_audio_url || null;
          })(),
          audio_title: god.audio_title || `${god.name} Devotional Audio`,
        },
      });
    }

    // 4. Query Database for Landmark Details
    const landmarkResult = await db.query(
      `SELECT id, locality_id, name, landmark_code, description, cloudinary_image_url
       FROM landmarks 
       WHERE landmark_code = $1 AND is_active = true`,
      [matched_code]
    );

    if (landmarkResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: `Recognized landmark code '${matched_code}' is not registered in the database catalog.`,
      });
    }

    const landmark = landmarkResult.rows[0];

    // 4. Fetch Locality & Strictly Separated Locality Facts (Universal ANSI SQL)
    const localityResult = await db.query(
      `SELECT id, district_id, name, pincode, latitude, longitude, description
       FROM localities 
       WHERE id = $1`,
      [landmark.locality_id]
    );

    const localityData = localityResult.rows[0] || {};

    const localityFactsResult = await db.query(
      `SELECT id, title, fact_type, content, cloudinary_media_url AS media_url, media_type
       FROM locality_facts
       WHERE locality_id = $1
       ORDER BY id ASC`,
      [landmark.locality_id]
    );
    localityData.locality_facts = localityFactsResult.rows || [];

    // 5. Fetch District & Strictly Separated District Facts (Universal ANSI SQL)
    const districtResult = await db.query(
      `SELECT id, name, code, state, description
       FROM districts 
       WHERE id = $1`,
      [localityData.district_id]
    );

    const districtData = districtResult.rows[0] || {};

    const districtFactsResult = await db.query(
      `SELECT id, title, fact_type, content, cloudinary_media_url AS media_url, media_type, source_attribution AS source
       FROM district_facts
       WHERE district_id = $1
       ORDER BY id ASC`,
      [localityData.district_id]
    );
    districtData.district_facts = districtFactsResult.rows || [];

    // 6. Optional lightweight audit trace (Never upload user query photo to Cloudinary)
    db.query(
      `INSERT INTO recognition_logs (matched_landmark_code, confidence_score, user_query_cloudinary_url, ip_address)
       VALUES ($1, $2, $3, $4)`,
      [matched_code, confidence, null, req.ip]
    ).catch(() => {});

    // 7. Return Final Response with Strictly Separated Fact Categories
    return res.status(200).json({
      success: true,
      matched: true,
      match_type: 'landmark',
      confidence: confidence,
      good_matches: good_matches_count,
      landmark: {
        id: landmark.id,
        name: landmark.name,
        code: landmark.landmark_code,
        description: landmark.description,
        reference_image_url: landmark.cloudinary_image_url,
      },
      // Strictly Locality Facts
      locality: {
        id: localityData.id,
        name: localityData.name,
        pincode: localityData.pincode,
        coordinates: {
          lat: localityData.latitude,
          lng: localityData.longitude,
        },
        description: localityData.description,
        facts: localityData.locality_facts || [],
      },
      // Strictly District Facts
      district: {
        id: districtData.id,
        name: districtData.name,
        code: districtData.code,
        state: districtData.state,
        description: districtData.description,
        facts: districtData.district_facts || [],
      },
    });
  } catch (error) {
    console.error('[Recognition Controller] Fatal error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error during image recognition.',
      error: error.message,
    });
  }
};

