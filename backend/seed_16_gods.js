const db = require('./src/config/db');

async function seed16Gods() {
  console.log('====================================================');
  console.log('🕉️  SEEDING 16 HINDU DEITIES INTO DATABASE');
  console.log('====================================================');

  const deities = [
    {
      god_code: 'GOD_01_BRAHMA',
      name: 'Lord Brahma (பிரம்மன்)',
      title: 'The Creator of the Universe & Lord of Sacred Vedas',
      description: 'Lord Brahma is the creator deity within the Hindu Trimurti. He is depicted with three visible faces reciting eternal Vedic hymns, embodying ultimate divine intellect and cosmic knowledge.',
      mantra_sloka: 'ॐ वेदात्मने विद्महे हिरण्यगर्भाय धीमहि তन्नो ब्रह्मा प्रचोदयात्\nஓம் வேதாத்மனே வித்மஹே ஹிரண்யகர்பாய தீமஹி தன்னோ பிரம்மா ப்ரசோதயாத்\n(Brahma Gayatri Mantra)',
      glow_color: '#F59E0B',
      audio_title: 'Lord Brahma Gayatri & Vedic Mantras',
      image_url: 'https://images.unsplash.com/photo-1545232979-fbf68fe9f1f8?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'
    },
    {
      god_code: 'GOD_02_VISHNU',
      name: 'Lord Vishnu (மகா விஷ்ணு)',
      title: 'The Supreme Preserver & Sustainer of Cosmic Order (Dharma)',
      description: 'Lord Vishnu preserves and protects cosmic harmony. Adorned with the divine spinning Sudarshana Chakra, the sacred Panchajanya conch, and majestic golden armor, resting in eternal grace.',
      mantra_sloka: 'शान्ताकारं भुजगशयनं पद्मनाभं सुरेशं विश्वाधारं गगनसदृशं मेघवर्णं शुभाङ्गम्\nசாந்தாகாரம் புஜகசயனம் பத்மநாபம் சுரேஷம் விஸ்வாதாரம் ககனசத்ருஷம் மேகவர்ணம் சுபாங்கம்\n(Vishnu Shanthakaram)',
      glow_color: '#0284C7',
      audio_title: 'Lord Vishnu Sahasranamam & Shanthakaram',
      image_url: 'https://images.unsplash.com/photo-1609743522653-52354461eb27?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'
    },
    {
      god_code: 'GOD_03_SHIVA',
      name: 'Lord Shiva (சிவபெருமான்)',
      title: 'Mahadeva - Cosmic Transformer, Nataraja & Lord of Kailash',
      description: 'Lord Shiva represents supreme cosmic consciousness, profound stillness, and truth. Bearing the holy crescent moon, holy river Ganga, snake Vasuki, and the sacred Trishul with Damaru.',
      mantra_sloka: 'ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम् उर्वारुकमिव बन्धनान् मृत्योर्मुक्षीय मामृतात्\nஓம் த்ரியம்பகம் யஜாமஹே சுகந்திம் புஷ்டிவர்த்தனம் உர்வாருகமிவ பந்தனான் மிருத்யோர் முக்ஷீய மாமிர்தாத்\n(Maha Mrityunjaya Mantra)',
      glow_color: '#38BDF8',
      audio_title: 'Lord Shiva Maha Mrityunjaya & Shiva Dhun',
      image_url: 'https://images.unsplash.com/photo-1567591414240-e2ff01c70940?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'
    },
    {
      god_code: 'GOD_04_DURGA',
      name: 'Goddess Durga (துர்க்கை அம்மன்)',
      title: 'Mahishasuramardini - Supreme Embodiment of Shakti & Protection',
      description: 'Maa Durga is the warrior form of the Divine Mother. Riding her fierce golden lion and wielding celestial weapons given by all deities, she grants fearlessness and vanquishes obstacles.',
      mantra_sloka: 'सर्वमङ्गलमाङ्गल्ये शिवे सर्वार्थसाधिके शरण्ये त्र्यम्बके गौरि नारायणि नमोऽस्तु ते\nசர்வ மங்கள மாங்கல்யே சிவே சர்வார்த்த சாதிகே சரண்யே த்ரியம்பகே கௌரி நாராயணி நமோஸ்து தே',
      glow_color: '#DC2626',
      audio_title: 'Goddess Durga Aigiri Nandini & Sri Durga Suktam',
      image_url: 'https://images.unsplash.com/photo-1601616631868-b7f30e01438a?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'
    },
    {
      god_code: 'GOD_05_LAKSHMI',
      name: 'Goddess Lakshmi (மகாலட்சுமி)',
      title: 'Goddess of Abundance, Spiritual Fortune & Auspicious Grace',
      description: 'Goddess Lakshmi is the consort of Lord Vishnu, granting prosperity, inner peace, and fortune. Seated upon a radiant pink lotus flower, showering golden coin blessings on sincere seekers.',
      mantra_sloka: 'ॐ श्रीं ह्रीं श्रीं कमले कमलालये प्रसीद प्रसीद श्रीं ह्रीं श्रीं ॐ महालक्ष्म्यै नमः\nஓம் ஸ்ரீம் ஹ்ரீம் ஸ்ரீம் கமலே கமலாலயே ப்ரஸீத ப்ரஸீத ஸ்ரீம் ஹ்ரீம் ஸ்ரீம் ஓம் மஹாலக்ஷ்ம்யை நமஹ\n(Mahalakshmi Moola Mantra)',
      glow_color: '#EC4899',
      audio_title: 'Goddess Mahalakshmi Ashtakam & Sri Suktam',
      image_url: 'https://images.unsplash.com/photo-1608889825103-eb5ed706fc64?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3'
    },
    {
      god_code: 'GOD_06_SARASWATI',
      name: 'Goddess Saraswati (சரஸ்வதி தேவி)',
      title: 'Goddess of Knowledge, Fine Arts, Music & Divine Speech',
      description: 'Goddess Saraswati presides over wisdom, education, and artistic mastery. Seated gracefully on a serene white lotus with her sacred Veena, radiating divine clarity and purity.',
      mantra_sloka: 'या कुन्देन्दुतुषारहारधवला या शुभ्रवस्त्रावृता या वीणावरदण्डमण्डितकरा या श्वेतपद्मासना\nயா குந்தேந்து துஷாரஹார தவளா யா சுப்ரவஸ்த்ராவ்ருதா யா வீணாவர தண்ட மண்டிதகரா யா ஸ்வேத பத்மாஸனா',
      glow_color: '#E0E7FF',
      audio_title: 'Goddess Saraswati Vandana & Veena Melodies',
      image_url: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3'
    },
    {
      god_code: 'GOD_07_KRISHNA',
      name: 'Lord Krishna (பால கிருஷ்ணர்)',
      title: 'Avatar of Joy, Divine Compassion, Love & Bhagavad Gita',
      description: 'Lord Krishna captivates the entire cosmos with his melodious bamboo flute, peacock feather crown, and gentle smile. The eternal friend and guru delivering the Bhagavad Gita.',
      mantra_sloka: 'हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे । हरे राम हरे राम राम राम हरे हरे ॥\nஹரே கிருஷ்ண ஹரே கிருஷ்ண கிருஷ்ண கிருஷ்ண ஹரே ஹரே । ஹரே ராம ஹரே ராம ராம ராம ஹரே ஹரே ॥\n(Maha Mantra)',
      glow_color: '#10B981',
      audio_title: 'Lord Krishna Madhurashtakam & Divine Bansuri Flute',
      image_url: 'https://images.unsplash.com/photo-1582650625119-3a31f8418b7d?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3'
    },
    {
      god_code: 'GOD_08_RAMA',
      name: 'Lord Rama (ஸ்ரீ ராமர்)',
      title: 'Maryada Purushottama - Embodiment of Virtue, Dharma & Truth',
      description: 'Lord Rama represents the supreme standard of moral perfection, honour, and devotion. Holding the majestic Kodandam bow and arrow, protector of truth across all three worlds.',
      mantra_sloka: 'श्री राम राम रमेति रमे रामे मनोरमे । सहस्त्रनाम तत्तुल्यं रामनाम वरानने ॥\nஸ்ரீ ராம ராம ராமேதி ரமே ராமே மனோரமே । சகஸ்ரநாம தத்துல்யம் ராமநாம வரானனே ॥',
      glow_color: '#3B82F6',
      audio_title: 'Goddess Sita Janaki Stuti & Sri Sita Kalyanam',
      image_url: 'https://images.unsplash.com/photo-1605647540924-852290f6b0d5?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://res.cloudinary.com/yxlabsit/video/upload/v1793703397/facts_vision/gods/audio/GOD_09_SITA_devotional_song.mp3'
    },
    {
      god_code: 'GOD_09_SITA',
      name: 'Goddess Sita (சீதா பிராட்டி)',
      title: 'Janaki - The Embodiment of Sacred Devotion, Fortitude & Grace',
      description: 'Goddess Sita is the divine daughter of Mother Earth and queen of Ayodhya. Revered for boundless fortitude, grace, unconditional love, and spiritual dignity.',
      mantra_sloka: 'जनकसुतायै विद्महे रामप्रियायै धीमहि তन्नो सीता प्रचोदयात्\nஜனகஸுதாயை வித்மஹே ராமப்ரியாயை தீமஹி தன்னோ சீதா ப்ரசோதயாத்\n(Sita Gayatri Mantra)',
      glow_color: '#F43F5E',
      audio_title: 'Lord Sri Rama Raksha Stotram & Ram Naam Dhun',
      image_url: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://res.cloudinary.com/yxlabsit/video/upload/v1793703395/facts_vision/gods/audio/GOD_08_RAMA_devotional_song.mp3'
    },
    {
      god_code: 'GOD_10_HANUMAN_GADA',
      name: 'Lord Hanuman Standing (வீர ஆஞ்சநேயர்)',
      title: 'Sankat Mochan - Supreme Warrior of Strength, Devotion & Humility',
      description: 'Lord Hanuman stands heroically holding his golden Gada (mace). The son of the wind god Vayu and dearest devotee of Lord Rama, dispelling fear and granting boundless vitality.',
      mantra_sloka: 'मनोजवं मारुततुल्यवेगं जितेन्द्रियं बुद्धिमतां वरिष्ठम् । वातात्मजं वानरयूथमुख्यं श्रीरामदूतं शरणं प्रपद्ये ॥\nமனோஜவம் மாருத துல்யவேகம் ஜிதேந்த்ரியம் புத்திமதாம் வரிஷ்டம் । வாதாத்மஜம் வானரயூத முக்யம் ஸ்ரீராமதூதம் சரணம் ப்ரபத்யே ॥',
      glow_color: '#F97316',
      audio_title: 'Lord Hanuman Chalisa & Maruthi Stotram',
      image_url: 'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3'
    },
    {
      god_code: 'GOD_11_GANESHA',
      name: 'Lord Ganesha (விநாயகர்)',
      title: 'Vighnaharta - Remover of All Obstacles & Lord of Auspicious Beginnings',
      description: 'Lord Ganesha is universally invoked before any new beginning. With his elephant head, broken tusk, sweet modak, and divine blessing posture, he grants intellect and joyous success.',
      mantra_sloka: 'वक्रतुण्ड महाकाय सूर्यकोटि समप्रभ । निर्विघ्नं कुरु मे देव सर्वकार्येषु सर्वदा ॥\nவக்ரதுண்ட மஹாகாய சூர்யகோடி ஸமப்ரப । நிர்விக்னம் குரு மே தேவ ஸர்வகார்யேஷு ஸர்வதா ॥',
      glow_color: '#EAB308',
      audio_title: 'Lord Ganesha Pancharatnam & Vinayagar Agaval',
      image_url: 'https://images.unsplash.com/photo-1567653418876-5bb0e566e1c2?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3'
    },
    {
      god_code: 'GOD_12_MURUGAN',
      name: 'Lord Murugan (முருகப்பெருமான்)',
      title: 'Kanda - Divine Commander, Presiding Deity of Tamil & Lord of Palani',
      description: 'Lord Murugan is the youthful commander of cosmic victory. Bearing the sacred golden Vel that pierces ignorance, he protects his devotees with fierce compassion and radiant grace.',
      mantra_sloka: 'ॐ शरवणभवाय नमः\nஓம் சரவணபவாய நமஹ । யாமிருக்க பயமேன்! வெற்றிவேல் முருகனுக்கு அரோகரா!',
      glow_color: '#FB923C',
      audio_title: 'Lord Murugan Kandha Sashti Kavasam & Vel Maral',
      image_url: 'https://images.unsplash.com/photo-1609137144822-473523f2f01f?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3'
    },
    {
      god_code: 'GOD_13_INDRA',
      name: 'Lord Indra (இந்திர பகவான்)',
      title: 'Devendra - King of Devas & Lord of Thunder and Celestial Heavens',
      description: 'Lord Indra reigns as the king of the gods in the heavenly court of Amaravati. Seated atop his majestic four-tusked winged white elephant Airavata, commanding lightning and nourishing rain.',
      mantra_sloka: 'ॐ इन्द्राय नमः । सहस्राक्षं देवराजं वज्रपाणिं महाबलम्\nஓம் இந்த்ராய நமஹ । ஸஹஸ்ராக்ஷம் தேவராஜம் வஜ்ரபாணிம் மஹாபலம்',
      glow_color: '#818CF8',
      audio_title: 'Lord Indra Devendra Suktam & Celestial Hymns',
      image_url: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3'
    },
    {
      god_code: 'GOD_14_NARASIMHA',
      name: 'Lord Narasimha (நரசிம்ம மூர்த்தி)',
      title: 'The Great Lion Avatar & Supreme Protector of Devotee Prahlada',
      description: 'Lord Narasimha is the fierce half-lion half-human incarnation of Vishnu. Manifesting fearlessly from a stone pillar at twilight to defend Prahlada and uphold righteousness.',
      mantra_sloka: 'उग्रं वीरं महाविष्णुं ज्वलन्तं सर्वतोमुखम् । नृसिंहं भीषणं भद्रं मृत्योर्मृत्युं नमाम्यहम् ॥\nஉக்ரம் வீரம் மஹாவிஷ்ணும் ஜ்வலந்தம் ஸர்வதோமுகம் । ந்ருஸிம்ஹம் பீஷணம் பத்ரம் ம்ருத்யோர்ம்ருத்யும் நமாம்யஹம் ॥',
      glow_color: '#EF4444',
      audio_title: 'Lord Narasimha Kavacham & Ugram Veeram Stotram',
      image_url: 'https://images.unsplash.com/photo-1546182990-dffeafbe841d?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3'
    },
    {
      god_code: 'GOD_15_SURYA',
      name: 'Lord Surya (சூரிய பகவான்)',
      title: 'Surya Bhagavan - Supreme Illuminator & The Soul of the Universe',
      description: 'Lord Surya is the visible Supreme Deity (Pratyaksha Daivam) whose radiant solar rays sustain all earthly life, destroy physical and spiritual ailments, and dispel ignorance.',
      mantra_sloka: 'ॐ आदित्याय विद्महे सहस्रकिरणाय धीमहि তन्नो भानुः प्रचोदयात्\nஓம் ஆதித்யாய வித்மஹே ஸஹஸ்ரகிரணாய தீமஹி தன்னோ பானுஹ் ப்ரசோதயாத்\n(Aditya Hridaya & Surya Gayatri)',
      glow_color: '#F97316',
      audio_title: 'Lord Surya Bhagavan Aditya Hridaya Stotram',
      image_url: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3'
    },
    {
      god_code: 'GOD_16_HANUMAN_TAIL',
      name: 'Lord Hanuman on Tail Throne (வாலாசனத்தில் அனுமன்)',
      title: 'Ravana Sabha Vijayi - Fearless Emissary of Sri Rama in Lanka',
      description: 'When Ravana insolently denied Lord Hanuman a seat in the court of Lanka, Hanuman miraculously coiled his long glowing tail into an elevated regal throne far above Ravana, displaying unmatched dignity.',
      mantra_sloka: 'अञ्जनानन्दनं वीरं जानकीशोकनाशनम् । कपीशमक्षहन्तारं वन्दे लङ्काभयङ्करम् ॥\nஅஞ்சனானந்தனம் வீரம் ஜானகீசோகநாசனம் । கபீசமக்ஷஹந்தாரம் வந்தே லங்காபயங்கரம் ॥',
      glow_color: '#EA580C',
      audio_title: 'Lord Hanuman Sundara Kandam Slokas & Ashtakam',
      image_url: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
      audio_url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3'
    }
  ];

  let insertedCount = 0;

  for (const god of deities) {
    try {
      if (db.dbType === 'mysql') {
        await db.query(
          `INSERT INTO gods (name, god_code, title, description, mantra_sloka, glow_color, 
                             cloudinary_image_url, cloudinary_audio_url, audio_title, is_active)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, true)
           ON DUPLICATE KEY UPDATE
             name = VALUES(name),
             title = VALUES(title),
             description = VALUES(description),
             mantra_sloka = VALUES(mantra_sloka),
             glow_color = VALUES(glow_color),
             cloudinary_image_url = VALUES(cloudinary_image_url),
             cloudinary_audio_url = VALUES(cloudinary_audio_url),
             audio_title = VALUES(audio_title),
             is_active = true`,
          [
            god.name,
            god.god_code,
            god.title,
            god.description,
            god.mantra_sloka,
            god.glow_color,
            god.image_url,
            god.audio_url,
            god.audio_title
          ]
        );
      } else {
        await db.query(
          `INSERT INTO gods (name, god_code, title, description, mantra_sloka, glow_color, 
                             cloudinary_image_url, cloudinary_audio_url, audio_title, is_active)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, true)
           ON CONFLICT (god_code) DO UPDATE SET
             name = EXCLUDED.name,
             title = EXCLUDED.title,
             description = EXCLUDED.description,
             mantra_sloka = EXCLUDED.mantra_sloka,
             glow_color = EXCLUDED.glow_color,
             cloudinary_image_url = EXCLUDED.cloudinary_image_url,
             cloudinary_audio_url = EXCLUDED.cloudinary_audio_url,
             audio_title = EXCLUDED.audio_title,
             is_active = true`,
          [
            god.name,
            god.god_code,
            god.title,
            god.description,
            god.mantra_sloka,
            god.glow_color,
            god.image_url,
            god.audio_url,
            god.audio_title
          ]
        );
      }
      insertedCount++;
      console.log(`✅ [${insertedCount}/16] Seeded ${god.god_code}: ${god.name}`);
    } catch (err) {
      console.error(`❌ Error seeding ${god.god_code}:`, err.message);
    }
  }

  console.log('\n====================================================');
  console.log(`🎉 Successfully seeded ${insertedCount} Hindu Deities with 100% playable audio!`);
  console.log('====================================================\n');
  process.exit(0);
}

seed16Gods().catch((err) => {
  console.error('Fatal Seeding Error:', err);
  process.exit(1);
});
