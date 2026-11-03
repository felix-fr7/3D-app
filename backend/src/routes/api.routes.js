const express = require('express');
const multer = require('multer');
const router = express.Router();

const recognizeController = require('../controllers/recognize.controller');
const districtController = require('../controllers/district.controller');
const localityController = require('../controllers/locality.controller');
const landmarkController = require('../controllers/landmark.controller');
const mediaController = require('../controllers/media.controller');
const godController = require('../controllers/god.controller');
const db = require('../config/db');

// Multer in-memory storage configuration
const storage = multer.memoryStorage();
const upload = multer({
  storage,
  limits: { fileSize: 30 * 1024 * 1024 }, // 30 MB maximum (for videos/high-res images)
});

const godUpload = upload.fields([
  { name: 'image', maxCount: 1 },
  { name: 'audio', maxCount: 1 }
]);

// ==========================================
// 1. RECOGNITION ROUTE (Used by Mobile App)
// ==========================================
router.post('/recognize', upload.single('image'), recognizeController.recognizeImage);

// Direct Cultural Media Sync Route
router.get('/sync-media', districtController.syncAuthenticMedia);
router.post('/sync-media', districtController.syncAuthenticMedia);

// ==========================================
// 2. DISTRICT & STRICT DISTRICT FACTS ROUTES
// ==========================================
router.get('/districts', districtController.getAllDistricts);
router.get('/districts/sync-media', districtController.syncAuthenticMedia);
router.post('/districts/sync-media', districtController.syncAuthenticMedia);
router.post('/purge-all-data', districtController.purgeAllData);
router.delete('/purge-all-data', districtController.purgeAllData);
router.get('/districts/:id', districtController.getDistrictById);
router.post('/districts', districtController.createDistrict);
router.delete('/districts/:id', districtController.deleteDistrict);
router.post('/district-facts', upload.single('media'), districtController.addDistrictFact);
router.put('/district-facts/:id', upload.single('media'), districtController.updateDistrictFact);
router.delete('/district-facts/:id', districtController.deleteDistrictFact);

// ==========================================
// 3. LOCALITY & STRICT LOCALITY FACTS ROUTES
// ==========================================
router.get('/localities', localityController.getAllLocalities);
router.get('/localities/:id', localityController.getLocalityById);
router.post('/localities', localityController.createLocality);
router.delete('/localities/:id', localityController.deleteLocality);
router.post('/locality-facts', upload.single('media'), localityController.addLocalityFact);
router.put('/locality-facts/:id', upload.single('media'), localityController.updateLocalityFact);
router.delete('/locality-facts/:id', localityController.deleteLocalityFact);

// ==========================================
// 4. CLOUDINARY MEDIA ASSETS GALLERY ROUTES
// ==========================================
router.get('/media', mediaController.getAllMedia);
router.post('/media/upload', upload.single('media'), mediaController.uploadMedia);
router.post('/media/bulk-delete', mediaController.deleteBulkMedia);
router.delete('/media/bulk', mediaController.deleteBulkMedia);
router.delete('/media/:publicId', mediaController.deleteMedia);
router.delete('/media', mediaController.deleteMedia);

// ==========================================
// 4. LANDMARKS & REFERENCE MEDIA ROUTES
// ==========================================
router.get('/landmarks', landmarkController.getAllLandmarks);
router.post('/landmarks', upload.single('image'), landmarkController.createLandmark);
router.put('/landmarks/:id', upload.single('image'), landmarkController.updateLandmark);
router.delete('/landmarks/:id', landmarkController.deleteLandmark);
router.get('/recognition/sync', landmarkController.syncLandmarksWithRecognizer);
router.post('/recognition/sync', landmarkController.syncLandmarksWithRecognizer);

// ==========================================
// 6. HINDU GODS & COLORING BOOK DEITIES ROUTES
// ==========================================
router.get('/gods', godController.getAllGods);
router.get('/gods/:id', godController.getGodById);
router.post('/gods', godUpload, godController.createGod);
router.put('/gods/:id', godUpload, godController.updateGod);
router.delete('/gods/:id', godController.deleteGod);
router.get('/gods-sync', godController.syncGodsWithRecognizer);
router.post('/gods-sync', godController.syncGodsWithRecognizer);

// ==========================================
// 7. AUDIT & ANALYTICS ROUTES
// ==========================================
router.get('/logs', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT * FROM recognition_logs ORDER BY created_at DESC LIMIT 50`
    );
    res.json({ success: true, count: result.rows.length, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

module.exports = router;

