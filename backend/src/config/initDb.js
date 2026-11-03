const db = require('./db');

async function initTables() {
  try {
    console.log('[Database] Checking & verifying database tables...');

    if (db.dbType === 'mysql') {
      await db.query(`
        CREATE TABLE IF NOT EXISTS gods (
          id INT AUTO_INCREMENT PRIMARY KEY,
          name VARCHAR(150) NOT NULL,
          god_code VARCHAR(100) NOT NULL UNIQUE,
          title VARCHAR(200),
          description TEXT,
          mantra_sloka TEXT,
          glow_color VARCHAR(30) DEFAULT '#FFD700',
          cloudinary_image_url TEXT NOT NULL,
          cloudinary_image_public_id VARCHAR(255),
          cloudinary_audio_url TEXT,
          cloudinary_audio_public_id VARCHAR(255),
          audio_title VARCHAR(150),
          is_active BOOLEAN DEFAULT TRUE,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          INDEX idx_gods_code (god_code)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
      `);
    } else {
      await db.query(`
        CREATE TABLE IF NOT EXISTS gods (
          id SERIAL PRIMARY KEY,
          name VARCHAR(150) NOT NULL,
          god_code VARCHAR(100) NOT NULL UNIQUE,
          title VARCHAR(200),
          description TEXT,
          mantra_sloka TEXT,
          glow_color VARCHAR(30) DEFAULT '#FFD700',
          cloudinary_image_url TEXT NOT NULL,
          cloudinary_image_public_id VARCHAR(255),
          cloudinary_audio_url TEXT,
          cloudinary_audio_public_id VARCHAR(255),
          audio_title VARCHAR(150),
          is_active BOOLEAN DEFAULT TRUE,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        CREATE INDEX IF NOT EXISTS idx_gods_code ON gods(god_code);
      `);
    }

    console.log('[Database] "gods" table verified successfully.');

    // Seed default sample deities if table is empty
    const checkGods = await db.query('SELECT COUNT(*) as count FROM gods');
    const count = parseInt(checkGods.rows[0].count || checkGods.rows[0]['COUNT(*)'] || 0, 10);

    if (count === 0) {
      console.log('[Database] Seeding initial Hindu Gods into "gods" table...');
      const sampleGods = [
        {
          name: 'Lord Ganesha (விநாயகர்)',
          god_code: 'GOD_GANESHA_01',
          title: 'Vighnaharta - The Remover of Obstacles & Bestower of Wisdom',
          description: 'Ganesha is revered as the first deity honored in every sacred beginning. Worshipped for intellect, good fortune, and overcoming obstacles.',
          mantra_sloka: 'ॐ गं गणपतये नमः | Om Gam Ganapataye Namaha\nவக்கிர துண்ட மகா காய சூரிய கோடி சமப் பிரப\nநிர்விக்னம் குரு மே தேவ சர்வ கார்யேஷு சர்வதா',
          glow_color: '#FFD700', // Divine Golden Glow
          cloudinary_image_url: 'https://res.cloudinary.com/yxlabsit/image/upload/v1730000000/facts_vision/gods/ganesha_coloring.png',
          cloudinary_audio_url: 'https://res.cloudinary.com/yxlabsit/video/upload/v1730000000/facts_vision/gods/ganesha_mantra.mp3',
          audio_title: 'Ganesha Gayatri & Divine Chants'
        },
        {
          name: 'Lord Shiva (சிவபெருமான்)',
          god_code: 'GOD_SHIVA_01',
          title: 'Mahadeva - The Auspicious Cosmic Transformer & Nataraja',
          description: 'Shiva represents supreme cosmic consciousness, meditation, and inner stillness. Lord of Mount Kailash and the cosmic dance of Nataraja.',
          mantra_sloka: 'ॐ नमः शिवाय | Om Namah Shivaya\nத்ரியம்பகம் யஜாமஹே சுகந்திம் புஷ்டிவர்த்தனம்\nஉர்வாருகமிவ பந்தனான் மிருத்யோர் முக்ஷீய மாமிர்தாத்',
          glow_color: '#00D2FF', // Celestial Cosmic Blue Glow
          cloudinary_image_url: 'https://res.cloudinary.com/yxlabsit/image/upload/v1730000000/facts_vision/gods/shiva_coloring.png',
          cloudinary_audio_url: 'https://res.cloudinary.com/yxlabsit/video/upload/v1730000000/facts_vision/gods/shiva_mantra.mp3',
          audio_title: 'Maha Mrityunjaya & Shiva Dhun'
        },
        {
          name: 'Lord Murugan (முருகப்பெருமான்)',
          god_code: 'GOD_MURUGAN_01',
          title: 'Kartikeya - Commander of Divine Forces & Lord of Palani',
          description: 'Murugan is the presiding deity of the Tamil language and spiritual valor. Holding the sacred Vel (spear) symbolizing keen spiritual intellect.',
          mantra_sloka: 'ஓம் சரவணபவ | Om Saravanabhavaya Namaha\nயாமிருக்க பயமேன்! வெற்றிவேல் முருகனுக்கு அரோகரா!',
          glow_color: '#FF7A00', // Sacred Radiant Saffron Glow
          cloudinary_image_url: 'https://res.cloudinary.com/yxlabsit/image/upload/v1730000000/facts_vision/gods/murugan_coloring.png',
          cloudinary_audio_url: 'https://res.cloudinary.com/yxlabsit/video/upload/v1730000000/facts_vision/gods/murugan_chant.mp3',
          audio_title: 'Kanda Sashti Kavasam & Vel Maral'
        },
        {
          name: 'Lord Krishna (ஸ்ரீ கிருஷ்ணர்)',
          god_code: 'GOD_KRISHNA_01',
          title: 'Parabrahman - Divine Avatar of Compassion, Joy & Gita',
          description: 'Krishna is the beloved deity of Vrindavan, whose divine flute enchants all creation. Teacher of the sacred Bhagavad Gita on duty and devotion.',
          mantra_sloka: 'हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे\nहरे राम हरे राम राम राम हरे हरे\nகிருஷ்ணாய வாசுதேவாய ஹரயே பரமாத்மனே',
          glow_color: '#38EF7D', // Divine Peacock Emerald Glow
          cloudinary_image_url: 'https://res.cloudinary.com/yxlabsit/image/upload/v1730000000/facts_vision/gods/krishna_coloring.png',
          cloudinary_audio_url: 'https://res.cloudinary.com/yxlabsit/video/upload/v1730000000/facts_vision/gods/krishna_flute.mp3',
          audio_title: 'Hare Krishna Mahamantra & Divine Flute'
        },
        {
          name: 'Lord Hanuman (ஆஞ்சநேயர்)',
          god_code: 'GOD_HANUMAN_01',
          title: 'Maruti - Supreme Embodiment of Devotion, Strength & Courage',
          description: 'Hanuman symbolises selfless service, unconditional love, and fearless courage. Worshipped to remove negative planetary energies and fear.',
          mantra_sloka: 'ॐ हं हनुमते नमः | Om Hanumate Namaha\nமனோஜவம் மாருத துல்யவேகம் ஜிதேந்திரியம் புத்திமதாம் வரிஷ்டம்\nவாதாத்மஜம் வானரயூத முக்யம் ஸ்ரீராமதூதம் சரணம் ப்ரபத்யே',
          glow_color: '#FF416C', // Radiant Ruby Saffron Glow
          cloudinary_image_url: 'https://res.cloudinary.com/yxlabsit/image/upload/v1730000000/facts_vision/gods/hanuman_coloring.png',
          cloudinary_audio_url: 'https://res.cloudinary.com/yxlabsit/video/upload/v1730000000/facts_vision/gods/hanuman_chalisa.mp3',
          audio_title: 'Hanuman Chalisa & Sankat Mochan'
        }
      ];

      for (const g of sampleGods) {
        await db.query(
          `INSERT INTO gods (name, god_code, title, description, mantra_sloka, glow_color, cloudinary_image_url, cloudinary_audio_url, audio_title)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
          [g.name, g.god_code, g.title, g.description, g.mantra_sloka, g.glow_color, g.cloudinary_image_url, g.cloudinary_audio_url, g.audio_title]
        );
      }
      console.log(`[Database] Seeded ${sampleGods.length} Hindu deities successfully.`);
    }
  } catch (err) {
    console.warn('[Database Notice during initTables]:', err.message);
  }
}

module.exports = { initTables };

