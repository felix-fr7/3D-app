const { Pool } = require('pg');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '..', '..', '.env') });
require('dotenv').config();

// Determine Database Type: 'mysql' or 'postgres'
const DB_TYPE = (process.env.DB_TYPE || (process.env.DB_PORT === '3306' ? 'mysql' : 'postgres')).toLowerCase();

let pool = null;
let mysqlPool = null;

if (DB_TYPE === 'mysql') {
  const mysql = require('mysql2/promise');
  mysqlPool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'facts_vision_db',
    waitForConnections: true,
    connectionLimit: 20,
    queueLimit: 0,
    decimalNumbers: true,
  });

  mysqlPool.getConnection()
    .then((conn) => {
      console.log(`[MySQL] Connected to MySQL database "${process.env.DB_NAME || 'facts_vision_db'}" on port ${process.env.DB_PORT || 3306} successfully.`);
      conn.release();
    })
    .catch((err) => {
      console.error(`\n❌ [MySQL Connection Error]: ${err.message}`);
      if (err.code === 'ECONNREFUSED') {
        console.error(`👉 Cause: MySQL service is NOT running on port ${process.env.DB_PORT || 3306}. Please start MySQL.`);
      } else if (err.code === 'ER_ACCESS_DENIED_ERROR') {
        console.error(`👉 Cause: MySQL password/user error! Check DB_USER and DB_PASSWORD in backend/.env`);
      } else if (err.code === 'ER_BAD_DB_ERROR') {
        console.error(`👉 Cause: Database "${process.env.DB_NAME || 'facts_vision_db'}" does not exist in MySQL! Run database/schema_mysql.sql`);
      }
    });
} else {
  // PostgreSQL Pool
  pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5432', 10),
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    database: process.env.DB_NAME || 'facts_vision_db',
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 5000,
  });

  pool.on('connect', () => {
    console.log(`[PostgreSQL] Connected to PostgreSQL database "${process.env.DB_NAME || 'facts_vision_db'}" on port ${process.env.DB_PORT || 5432} successfully.`);
  });

  pool.on('error', (err) => {
    console.error('[PostgreSQL] Unexpected error on idle client:', err.message);
  });
}

/**
 * Universal Query Adapter:
 * Seamlessly handles parameter binding ($1, $2 vs ?),
 * result normalization ({ rows: [...] }),
 * and error messages across both MySQL and PostgreSQL.
 */
async function query(text, params = []) {
  try {
    if (DB_TYPE === 'mysql') {
      // 1. Convert PostgreSQL style casting (e.g. ::int, ::text)
      let mysqlQuery = text.replace(/::[a-zA-Z_]+/g, '');

      // 2. Handle RETURNING * for MySQL (INSERTS & UPDATES)
      const isInsert = /^\s*INSERT\s+INTO\s+([a-zA-Z0-9_]+)/i.test(mysqlQuery);
      const isUpdate = /^\s*UPDATE\s+([a-zA-Z0-9_]+)/i.test(mysqlQuery);
      let tableName = null;
      if (isInsert) {
        const match = mysqlQuery.match(/^\s*INSERT\s+INTO\s+([a-zA-Z0-9_]+)/i);
        tableName = match ? match[1] : null;
      } else if (isUpdate) {
        const match = mysqlQuery.match(/^\s*UPDATE\s+([a-zA-Z0-9_]+)/i);
        tableName = match ? match[1] : null;
      }
      mysqlQuery = mysqlQuery.replace(/\s+RETURNING\s+\*/i, '');

      // 3. Convert $1, $2, $3 to ? for MySQL
      mysqlQuery = mysqlQuery.replace(/\$\d+/g, '?');

      const [result] = await mysqlPool.query(mysqlQuery, params);

      // If it was an INSERT and we need the inserted row
      if (isInsert && result && result.insertId && tableName) {
        const [rows] = await mysqlPool.query(`SELECT * FROM ${tableName} WHERE id = ?`, [result.insertId]);
        return { rows: rows, rowCount: 1, insertId: result.insertId };
      }

      // If it was an UPDATE and we need the updated row
      if (isUpdate && tableName) {
        const lastParam = params[params.length - 1];
        if (lastParam) {
          const [rows] = await mysqlPool.query(`SELECT * FROM ${tableName} WHERE id = ?`, [lastParam]);
          return { rows: rows, rowCount: rows.length };
        }
      }

      if (Array.isArray(result)) {
        return { rows: result, rowCount: result.length };
      } else {
        return { rows: [], affectedRows: result.affectedRows, insertId: result.insertId };
      }
    } else {
      // PostgreSQL
      return await pool.query(text, params);
    }
  } catch (err) {
    console.error(`\n❌ [Database Query Error]: ${err.message}`);
    throw err;
  }
}

module.exports = {
  query,
  pool: DB_TYPE === 'mysql' ? mysqlPool : pool,
  dbType: DB_TYPE,
};
