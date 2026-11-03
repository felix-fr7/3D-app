-- ========================================================
-- Full-Stack Image Recognition & Facts Discovery Platform
-- PostgreSQL Database Schema
-- NOTE: Media bytes are NEVER stored in PostgreSQL.
--       Only Cloudinary secure URLs and metadata are stored.
-- ========================================================

-- Enable UUID extension if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. DISTRICTS TABLE
CREATE TABLE IF NOT EXISTS districts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(20) NOT NULL UNIQUE, -- e.g., 'MDU', 'CHN', 'TNJ'
    state VARCHAR(100) DEFAULT 'Tamil Nadu',
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. DISTRICT FACTS TABLE (Strictly District-level details)
-- Culture, history, geography, governance, state-level significance
CREATE TABLE IF NOT EXISTS district_facts (
    id SERIAL PRIMARY KEY,
    district_id INTEGER NOT NULL REFERENCES districts(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    fact_type VARCHAR(50) NOT NULL DEFAULT 'history', -- 'history', 'culture', 'economy', 'demographics'
    content TEXT NOT NULL,
    cloudinary_media_url TEXT,                        -- Only Cloudinary URL (No raw bytes)
    cloudinary_public_id VARCHAR(255),
    media_type VARCHAR(20) DEFAULT 'image',           -- 'image', 'video', 'gif'
    source_attribution VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. LOCALITIES TABLE (Towns, Neighborhoods, Villages inside a District)
CREATE TABLE IF NOT EXISTS localities (
    id SERIAL PRIMARY KEY,
    district_id INTEGER NOT NULL REFERENCES districts(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    pincode VARCHAR(10),
    latitude NUMERIC(10, 7),
    longitude NUMERIC(10, 7),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. LOCALITY FACTS TABLE (Strictly Local neighborhood/street/village details)
-- Local folklore, street food, neighborhood legends, native festivals
CREATE TABLE IF NOT EXISTS locality_facts (
    id SERIAL PRIMARY KEY,
    locality_id INTEGER NOT NULL REFERENCES localities(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    fact_type VARCHAR(50) NOT NULL DEFAULT 'specialty', -- 'specialty', 'folklore', 'food', 'temple', 'art'
    content TEXT NOT NULL,
    cloudinary_media_url TEXT,                          -- Only Cloudinary URL
    cloudinary_public_id VARCHAR(255),
    media_type VARCHAR(20) DEFAULT 'image',             -- 'image', 'video', 'gif'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. LANDMARKS & REFERENCE IMAGES (For Computer Vision matching)
CREATE TABLE IF NOT EXISTS landmarks (
    id SERIAL PRIMARY KEY,
    locality_id INTEGER NOT NULL REFERENCES localities(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    landmark_code VARCHAR(100) NOT NULL UNIQUE,         -- e.g., 'LMK_MADURAI_MEENAKSHI_01'
    description TEXT,
    cloudinary_image_url TEXT NOT NULL,                 -- Main reference photo in Cloudinary
    cloudinary_public_id VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. RECOGNITION AUDIT LOGS
CREATE TABLE IF NOT EXISTS recognition_logs (
    id BIGSERIAL PRIMARY KEY,
    matched_landmark_code VARCHAR(100),
    confidence_score NUMERIC(5, 4),                     -- e.g., 0.8752
    user_query_cloudinary_url TEXT,                     -- Uploaded query photo in Cloudinary (URL only)
    device_info VARCHAR(150),
    ip_address VARCHAR(45),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for lightning fast queries
CREATE INDEX IF NOT EXISTS idx_district_facts_dist_id ON district_facts(district_id);
CREATE INDEX IF NOT EXISTS idx_localities_dist_id ON localities(district_id);
CREATE INDEX IF NOT EXISTS idx_locality_facts_loc_id ON locality_facts(locality_id);
CREATE INDEX IF NOT EXISTS idx_landmarks_code ON landmarks(landmark_code);
CREATE INDEX IF NOT EXISTS idx_landmarks_loc_id ON landmarks(locality_id);

-- ========================================================
-- SEED INITIAL DATA (Demo Tamil Nadu District & Locality Facts)
-- ========================================================

-- Insert District: Madurai
INSERT INTO districts (name, code, description) 
VALUES ('Madurai', 'MDU', 'Known as Thoonga Nagaram (The City that Never Sleeps) and the cultural capital of Tamil Nadu.')
ON CONFLICT (name) DO NOTHING;

-- Insert District Facts for Madurai
INSERT INTO district_facts (district_id, title, fact_type, content, cloudinary_media_url, media_type)
VALUES 
(
  1, 
  'Pandyan Dynasty Heritage', 
  'history', 
  'Madurai was the seat of all three Tamil Sangams (gatherings of poets). It served as the capital of the ancient Pandyan Kingdom for centuries.',
  'https://res.cloudinary.com/demo/image/upload/sample.jpg',
  'image'
),
(
  1, 
  'Jallikattu Cultural Tradition', 
  'culture', 
  'The worldwide famous bull-taming festival Alanganallur Jallikattu takes place in Madurai district every Pongal season.',
  'https://res.cloudinary.com/demo/video/upload/dog.mp4',
  'video'
);

-- Insert Locality: Meenakshi Amman Temple Zone
INSERT INTO localities (district_id, name, pincode, latitude, longitude, description)
VALUES 
(
  1, 
  'Meenakshi Temple Precinct', 
  '625001', 
  9.9195, 
  78.1193, 
  'The concentric square street layout surrounding the historic Meenakshi Sundareswarar temple.'
)
ON CONFLICT DO NOTHING;

-- Insert Locality Facts
INSERT INTO locality_facts (locality_id, title, fact_type, content, cloudinary_media_url, media_type)
VALUES 
(
  1, 
  'Famous Jigarthanda Origin', 
  'food', 
  'East Masi Street in this locality is the original birthplace of Madurais authentic Jigarthanda dessert made with almond gum and reduced milk.',
  'https://res.cloudinary.com/demo/image/upload/sample.jpg',
  'image'
),
(
  1, 
  'Pillars of Musical Mystery', 
  'specialty', 
  'Inside this localitys temple corridor, there are 5 musical pillars carved out of a single monolithic granite stone that resonate with swaras when tapped.',
  'https://res.cloudinary.com/demo/image/upload/sample.jpg',
  'image'
);

-- Insert Landmark
INSERT INTO landmarks (locality_id, name, landmark_code, description, cloudinary_image_url)
VALUES 
(
  1, 
  'Meenakshi Amman Temple South Tower', 
  'LMK_MADURAI_MEENAKSHI_01', 
  'The tallest gopuram of Madurai Meenakshi temple measuring over 160 feet with intricate sculptures.',
  'https://res.cloudinary.com/demo/image/upload/sample.jpg'
)
ON CONFLICT (landmark_code) DO NOTHING;

