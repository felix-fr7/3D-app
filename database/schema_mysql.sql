-- ========================================================
-- Full-Stack Image Recognition & Facts Discovery Platform
-- MySQL Database Schema
-- NOTE: Media bytes are NEVER stored in MySQL.
--       Only Cloudinary secure URLs and metadata are stored.
-- ========================================================

CREATE DATABASE IF NOT EXISTS facts_vision_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE facts_vision_db;

-- 1. DISTRICTS TABLE
CREATE TABLE IF NOT EXISTS districts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(20) NOT NULL UNIQUE, -- e.g., 'MDU', 'CHN', 'TNJ'
    state VARCHAR(100) DEFAULT 'Tamil Nadu',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. DISTRICT FACTS TABLE (Strictly District-level details)
CREATE TABLE IF NOT EXISTS district_facts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    district_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    fact_type VARCHAR(50) NOT NULL DEFAULT 'history', -- 'history', 'culture', 'economy', 'demographics'
    content TEXT NOT NULL,
    cloudinary_media_url TEXT,                        -- Only Cloudinary URL (No raw bytes)
    cloudinary_public_id VARCHAR(255),
    media_type VARCHAR(20) DEFAULT 'image',           -- 'image', 'video', 'gif'
    source_attribution VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_district_facts_dist_id (district_id),
    CONSTRAINT fk_dist_facts_district FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. LOCALITIES TABLE (Towns, Neighborhoods, Villages inside a District)
CREATE TABLE IF NOT EXISTS localities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    district_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    pincode VARCHAR(10),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_localities_dist_id (district_id),
    CONSTRAINT fk_localities_district FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. LOCALITY FACTS TABLE (Strictly Local neighborhood/street/village details)
CREATE TABLE IF NOT EXISTS locality_facts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    locality_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    fact_type VARCHAR(50) NOT NULL DEFAULT 'specialty', -- 'specialty', 'folklore', 'food', 'temple', 'art'
    content TEXT NOT NULL,
    cloudinary_media_url TEXT,                          -- Only Cloudinary URL
    cloudinary_public_id VARCHAR(255),
    media_type VARCHAR(20) DEFAULT 'image',             -- 'image', 'video', 'gif'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_locality_facts_loc_id (locality_id),
    CONSTRAINT fk_loc_facts_locality FOREIGN KEY (locality_id) REFERENCES localities(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. LANDMARKS & REFERENCE IMAGES (For Computer Vision matching)
CREATE TABLE IF NOT EXISTS landmarks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    locality_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    landmark_code VARCHAR(100) NOT NULL UNIQUE,         -- e.g., 'LMK_MADURAI_MEENAKSHI_01'
    description TEXT,
    cloudinary_image_url TEXT NOT NULL,                 -- Main reference photo in Cloudinary
    cloudinary_public_id VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_landmarks_code (landmark_code),
    INDEX idx_landmarks_loc_id (locality_id),
    CONSTRAINT fk_landmarks_locality FOREIGN KEY (locality_id) REFERENCES localities(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. RECOGNITION AUDIT LOGS
CREATE TABLE IF NOT EXISTS recognition_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    matched_landmark_code VARCHAR(100),
    confidence_score DECIMAL(5, 4),                     -- e.g., 0.8752
    user_query_cloudinary_url TEXT,                     -- Uploaded query photo in Cloudinary (URL only)
    device_info VARCHAR(150),
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. HINDU GODS & COLORING BOOK DEITIES TABLE (Separate Cloudinary & DB Storage)
CREATE TABLE IF NOT EXISTS gods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    god_code VARCHAR(100) NOT NULL UNIQUE,             -- e.g. 'GOD_GANESHA_01', 'GOD_SHIVA_01'
    title VARCHAR(200),                                -- e.g. 'Vighnaharta - Remover of Obstacles'
    description TEXT,
    mantra_sloka TEXT,                                 -- e.g. 'Om Gam Ganapataye Namaha'
    glow_color VARCHAR(30) DEFAULT '#FFD700',          -- Divine light glow hex color
    cloudinary_image_url TEXT NOT NULL,                -- Cloudinary image URL (facts_vision/gods/images)
    cloudinary_image_public_id VARCHAR(255),
    cloudinary_audio_url TEXT,                         -- Cloudinary MP3 audio URL (facts_vision/gods/audio)
    cloudinary_audio_public_id VARCHAR(255),
    audio_title VARCHAR(150),                          -- e.g. 'Ganesha Gayatri & Divine Chants'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_gods_code (god_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- SEED INITIAL DATA (Demo Tamil Nadu District & Locality Facts)
-- ========================================================

-- Insert District: Madurai
INSERT IGNORE INTO districts (id, name, code, description) 
VALUES (1, 'Madurai', 'MDU', 'Known as Thoonga Nagaram (The City that Never Sleeps) and the cultural capital of Tamil Nadu.');

-- Insert District Facts for Madurai
INSERT INTO district_facts (district_id, title, fact_type, content, cloudinary_media_url, media_type)
SELECT 1, 
       'Pandyan Dynasty Heritage', 
       'history', 
       'Madurai was the seat of all three Tamil Sangams (gatherings of poets). It served as the capital of the ancient Pandyan Kingdom for centuries.',
       'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg',
       'image'
WHERE NOT EXISTS (SELECT 1 FROM district_facts WHERE district_id = 1 AND title = 'Pandyan Dynasty Heritage');

INSERT INTO district_facts (district_id, title, fact_type, content, cloudinary_media_url, media_type)
SELECT 1, 
       'Jallikattu Cultural Tradition', 
       'culture', 
       'The worldwide famous bull-taming festival Alanganallur Jallikattu takes place in Madurai district every Pongal season.',
       'https://res.cloudinary.com/yxlabsit/video/upload/dog.mp4',
       'video'
WHERE NOT EXISTS (SELECT 1 FROM district_facts WHERE district_id = 1 AND title = 'Jallikattu Cultural Tradition');

-- Insert Locality: Meenakshi Amman Temple Zone
INSERT IGNORE INTO localities (id, district_id, name, pincode, latitude, longitude, description)
VALUES (1, 1, 'Meenakshi Temple Precinct', '625001', 9.9195, 78.1193, 'The concentric square street layout surrounding the historic Meenakshi Sundareswarar temple.');

-- Insert Locality Facts
INSERT INTO locality_facts (locality_id, title, fact_type, content, cloudinary_media_url, media_type)
SELECT 1, 
       'Famous Jigarthanda Origin', 
       'food', 
       'East Masi Street in this locality is the original birthplace of Madurais authentic Jigarthanda dessert made with almond gum and reduced milk.',
       'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg',
       'image'
WHERE NOT EXISTS (SELECT 1 FROM locality_facts WHERE locality_id = 1 AND title = 'Famous Jigarthanda Origin');

INSERT INTO locality_facts (locality_id, title, fact_type, content, cloudinary_media_url, media_type)
SELECT 1, 
       'Pillars of Musical Mystery', 
       'specialty', 
       'Inside this localitys temple corridor, there are 5 musical pillars carved out of a single monolithic granite stone that resonate with swaras when tapped.',
       'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg',
       'image'
WHERE NOT EXISTS (SELECT 1 FROM locality_facts WHERE locality_id = 1 AND title = 'Pillars of Musical Mystery');

-- Insert Landmark
INSERT IGNORE INTO landmarks (id, locality_id, name, landmark_code, description, cloudinary_image_url)
VALUES (1, 1, 'Meenakshi Amman Temple South Tower', 'LMK_MADURAI_MEENAKSHI_01', 'The tallest gopuram of Madurai Meenakshi temple measuring over 160 feet with intricate sculptures.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg');

