const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const path = require('path');
require('dotenv').config();

const apiRoutes = require('./routes/api.routes');
const db = require('./config/db');

const app = express();
const PORT = process.env.PORT || 5000;

// Global Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Base Health Check
app.get('/health', async (req, res) => {
  try {
    const dbCheck = await db.query('SELECT NOW() AS now');
    const dbTime = dbCheck.rows && dbCheck.rows[0] 
      ? (dbCheck.rows[0].now || Object.values(dbCheck.rows[0])[0]) 
      : new Date();

    res.json({
      status: 'healthy',
      database: 'connected',
      db_type: db.dbType || 'mysql',
      db_time: dbTime,
      uptime: process.uptime(),
    });
  } catch (err) {
    res.status(500).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: err.message,
    });
  }
});

// Mount API Routes
app.use('/api', apiRoutes);

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Resource not found' });
});

// Centralized Error Handling Middleware
app.use((err, req, res, next) => {
  console.error('[Global Error Handler]:', err.stack);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal server error',
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`====================================================`);
  console.log(`🚀 Node Express Backend running on http://localhost:${PORT}`);
  console.log(`📡 Connected to Python Recognizer at: ${process.env.RECOGNIZER_SERVICE_URL || 'http://localhost:8000'}`);
  console.log(`====================================================`);

  // Initialize and verify database tables (e.g. Hindu Gods table)
  const { initTables } = require('./config/initDb');
  initTables().catch((e) => {
    console.warn('[DB Init Notice]:', e.message);
  });
});

