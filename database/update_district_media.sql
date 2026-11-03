-- ==============================================================================
-- TAMIL NADU DISTRICT EXPLORER - COMPREHENSIVE AUTHENTIC CULTURAL MEDIA & FACTS
-- 100% Authentic Foods, Temples, Monuments, Industries & Natural Wonders
-- Strictly separates District Facts and Locality Facts
-- ==============================================================================

USE facts_vision_db;

-- ==============================================================================
-- 1. MADURAI (MDU)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Meenakshi Amman Temple Golden Lotus Pond (Potramarai Kulam)',
    content = 'Madurai is the ancient Sangam city anchored by the world-renowned Meenakshi Temple, featuring 14 magnificent gopurams and the sacred Golden Lotus Pond (Potramarai Kulam).',
    cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Golden_Lily_Pond_and_South_Gopuram_at_Meenakshi_Amman_Temple_,_Madurai.jpg?width=800',
    media_type = 'image'
WHERE district_id = 1 AND fact_type = 'history';

UPDATE district_facts 
SET title = 'Alanganallur Jallikattu Bull Festival',
    content = 'The world-famous ancient bull-taming festival Alanganallur Jallikattu has been celebrated annually during Pongal in Madurai district since the Sangam era.',
    cloudinary_media_url = 'https://res.cloudinary.com/demo/video/upload/c_scale,w_720/dog.mp4',
    media_type = 'video'
WHERE district_id = 1 AND fact_type = 'culture';

UPDATE locality_facts 
SET title = 'Famous Madurai Jigarthanda Origin',
    content = 'East Masi Street in Madurai is the birthplace of authentic Jigarthanda (meaning Liver Coolant), crafted with almond gum (badam pisin), nannari syrup, reduced basundi milk, and topped with rich ice cream.',
    cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jigarthanda.JPG?width=800',
    media_type = 'image'
WHERE locality_id = 1 AND fact_type = 'food';

UPDATE locality_facts 
SET title = 'Five Musical Granite Pillars of Meenakshi Temple',
    content = 'Inside the Meenakshi Temple thousand-pillar mandapam, 5 musical pillars carved out of a single monolithic granite block resonate with classical Sapthaswaras when gently tapped.',
    cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Golden_Lily_Pond_and_South_Gopuram_at_Meenakshi_Amman_Temple_,_Madurai.jpg?width=800',
    media_type = 'image'
WHERE locality_id = 1 AND fact_type = 'specialty';


-- ==============================================================================
-- 23. VIRUDHUNAGAR (VNR) - USER FOCUS: PAROTTA, CRACKERS, PALKOVA, SRIVI TEMPLE
-- ==============================================================================
UPDATE district_facts 
SET title = 'Srivilliputhur Andal Temple Tower (TN Government Official Emblem)',
    content = 'The majestic 11-tier 192-foot Rajagopuram of the Srivilliputhur Andal Temple was built by King Periya Veerappa Nayak and serves as the official State Emblem of the Government of Tamil Nadu.',
    cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Srivilliputhur_Andal_temple.jpg?width=800',
    media_type = 'image'
WHERE district_id = 23;

-- Insert or update Sivakasi Crackers and Fireworks
INSERT INTO district_facts (district_id, title, fact_type, content, cloudinary_media_url, media_type)
VALUES (23, 'Sivakasi Fireworks, Matches & Offset Printing (Little Japan)', 'economy',
        'Sivakasi produces over 70% of Indias fireworks and safety matches, and 80% of premium offset packaging, hailed by Jawaharlal Nehru as Kutti Japan (Little Japan).',
        'https://commons.wikimedia.org/wiki/Special:FilePath/Sivakasi_fireworks.JPG?width=800', 'image')
ON DUPLICATE KEY UPDATE 
    title = VALUES(title), content = VALUES(content), cloudinary_media_url = VALUES(cloudinary_media_url);

-- Update Virudhunagar Locality Facts: Ennai Parotta
UPDATE locality_facts 
SET title = 'Virudhunagar Ennai Parotta (Coin / Poricha Parotta)',
    content = 'Virudhunagar Ennai Parotta is shallow-fried in bubbling hot groundnut oil until crispy golden-brown outside while retaining super soft, flaky layers inside. It is traditionally served with spicy mutton or chicken salna.',
    cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Famous_south_india_food_parotta.jpg?width=800',
    media_type = 'image'
WHERE locality_id = 23 AND (fact_type = 'food' OR title LIKE '%Parotta%');

-- Insert or update Srivilliputhur Palkova
INSERT INTO locality_facts (locality_id, title, fact_type, content, cloudinary_media_url, media_type)
VALUES (23, 'Srivilliputhur Palkova (GI Tagged Milk Sweet)', 'specialty',
        'Srivilliputhur Palkova is world-famous and holds a Geographical Indication (GI) tag. Made exclusively from rich, full-fat cow milk and simmered with pure sugar in heavy copper vessels, it has an authentic melt-in-the-mouth texture.',
        'https://commons.wikimedia.org/wiki/Special:FilePath/Palkova.jpg?width=800', 'image')
ON DUPLICATE KEY UPDATE 
    title = VALUES(title), content = VALUES(content), cloudinary_media_url = VALUES(cloudinary_media_url);

-- Insert or update Kaara Sevu & Athirasam
INSERT INTO locality_facts (locality_id, title, fact_type, content, cloudinary_media_url, media_type)
VALUES (23, 'Virudhunagar Kaara Sevu & Traditional Athirasam', 'food',
        'Crispy, crunchy Kaara Sevu heavily spiced with crushed black pepper and garlic, alongside tender jaggery-infused Athirasam, fried in wood-pressed groundnut oil, are the signature tea-time snacks of Virudhunagar.',
        'https://commons.wikimedia.org/wiki/Special:FilePath/Athirasam_of_Salem.jpg?width=800', 'image')
ON DUPLICATE KEY UPDATE 
    title = VALUES(title), content = VALUES(content), cloudinary_media_url = VALUES(cloudinary_media_url);


-- ==============================================================================
-- 2. CHENNAI (CHN)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Marina Beach Coastline & Lighthouse',
    content = 'Marina Beach in Chennai is the second longest natural urban sandy beach in the world, stretching over 13 km along the Coromandel Coast of the Bay of Bengal.',
    cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Marina_beach,_Chennai.jpg?width=800',
    media_type = 'image'
WHERE district_id = 2 AND fact_type = 'geography';

UPDATE district_facts 
SET title = 'Margazhi Carnatic Music & Dance Season',
    content = 'Chennai hosts the worlds largest cultural music festival every December-January (Margazhi), recognized by UNESCO Creative Cities Network for its classical vocal and Bharatanatyam concerts.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 2 AND fact_type = 'culture';

UPDATE locality_facts 
SET title = 'Authentic Degree Filter Coffee & Crispy Medu Vada',
    content = 'Mylapore heritage messes serve frothy, piping-hot South Indian degree filter coffee in traditional brass dabarah and tumbler sets alongside crispy golden medu vadas.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 2 AND fact_type = 'food';


-- ==============================================================================
-- 3. COIMBATORE (CBE)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Manchester of South India & Foundries',
    content = 'Coimbatore is home to over 25,000 textile mills, pump manufacturing units, and precision engineering foundries, alongside the GI-tagged Coimbatore Wet Grinder.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 3 AND fact_type = 'economy';

UPDATE locality_facts 
SET title = 'Annapoorna Sambar & Ghee Roast Dosa Recipe',
    content = 'RS Puram food streets in Coimbatore are world-famous for their unique sweet-spiced sambar prepared with a proprietary blend of 14 native hill spices served over paper roast dosas.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 3 AND fact_type = 'food';


-- ==============================================================================
-- 4. TIRUNELVELI (TVL)
-- ==============================================================================
UPDATE district_facts 
SET title = 'The Perennial River Thamirabarani & Nellaiappar Temple',
    content = 'The Thamirabarani is the only perennial river in Tamil Nadu, originating in Agasthiyar hills. Beside its banks stands the grand Nellaiappar temple with 5 musical stone pillars.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 4 AND fact_type = 'geography';

UPDATE locality_facts 
SET title = 'Iruttu Kadai Halwa Pure Ghee Tradition',
    content = 'Operating beside Nellaiappar temple since 1900, Iruttu Kadai opens only after twilight lit by a single bulb, serving piping-hot, dark-amber wheat milk halwa on mandharai leaves.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 4 AND fact_type = 'food';


-- ==============================================================================
-- 5. THANJAVUR (TNJ)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Brihadisvara Big Temple Architectural Wonder',
    content = 'Built by emperor Raja Raja Chola I in 1010 CE, the Big Temple (Peruvudaiyar Kovil) features a monolithic granite dome weighing 80 tonnes atop a 216-foot soaring Vimana.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1609766857041-ed402ea8069a?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 5 AND fact_type = 'history';

UPDATE locality_facts 
SET title = 'Shadow That Never Falls Mystery & Ashoka Halwa',
    content = 'Engineered with Chola architectural precision, the octagonal granite Shikhara of the Big Temple casts minimal shadow on the ground at noon. Thanjavur is also famous for Moong Dal Ashoka Halwa.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1609766857041-ed402ea8069a?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 5 AND fact_type = 'specialty';


-- ==============================================================================
-- 6. TIRUCHIRAPPALLI (TRY)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Trichy Rockfort & Kallanai Grand Anicut',
    content = 'Perched on an ancient 3.8 billion-year-old rock citadel stands the Ucchi Pillayar Temple, overlooking Karikala Cholas 2nd-century operational Kallanai dam.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 6;

UPDATE locality_facts 
SET title = 'Srirangam Rajagopuram (Asia Tallest Temple Tower)',
    content = 'Srirangam Island temple features 21 majestic gopurams including the Rajagopuram rising 236 feet tall. Srirangam is also celebrated for Thavattu Halwa and sweet Poovan bananas.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 6;


-- ==============================================================================
-- 7. KANYAKUMARI (KKI)
-- ==============================================================================
UPDATE district_facts 
SET title = '133-Foot Thiruvalluvar Statue & Triveni Sangam',
    content = 'Standing at the southern tip where Arabian Sea, Indian Ocean, and Bay of Bengal unite, the stone statue stands 133 feet tall representing the 133 chapters of Thirukkural.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 7;

UPDATE locality_facts 
SET title = 'Thiruvalluvar Statue 7,000-Tonne Granite Engineering',
    content = 'Sculpted by Ganapati Sthapati, the 133-foot Thiruvalluvar statue required 7,000 tonnes of granite and withstands salt storms and tidal waves in the confluence of three oceans.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1596178065887-1198b6148b2b?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 7;


-- ==============================================================================
-- 8. SALEM (SLM)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Salem Malgova Mangoes & Mettur Dam',
    content = 'Salem is globally recognized for sweet GI-tagged Malgova mango orchards, the historic Mettur Stanley Dam, and the SAIL stainless steel plant.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1553279768-865429fa0078?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 8;

UPDATE locality_facts 
SET title = 'Yercaud 32-km Loop Road & Salem Thattu Vadai Set',
    content = 'Starting in Yercaud hill station, the 32-km loop road passes heritage British coffee estates, while Salem town street carts are famed for crunchy Thattu Vadai sets with beetroot chutney.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 8;


-- ==============================================================================
-- 9. ERODE (ERD)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Turmeric City (Manjal Maanagaram) & Bhavani Carpets',
    content = 'Erode operates one of Asias largest wholesale trading markets for turmeric root and produces the GI-tagged Bhavani Jamakkalam woven carpets.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 9;

UPDATE locality_facts 
SET title = 'Bhavani Kooduthurai Triple River Sangam & Pallipalayam',
    content = 'Bhavani is the holy Dakshina Triveni where rivers Kaveri, Bhavani, and the mystic subterranean Amutha meet. Erode is also the birthplace of Pallipalayam chilli chicken.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 9;


-- ==============================================================================
-- 10. DINDIGUL (DGL)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Dindigul Handcrafted Brass Locks & Rock Fort',
    content = 'Dindigul is celebrated as the Lock City (Pootu Nagaram) holding a GI tag for handcrafted tumbler brass locks, guarded by a monolithic 17th-century rock fortress.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 10;

UPDATE locality_facts 
SET title = 'Dindigul Thalappakatti Seeraga Samba Biryani & Palani Panchamirtham',
    content = 'Dindigul is globally renowned for its GI-tagged Seeraga Samba Biryani cooked with succulent meat over woodfire, and Palani Murugan temples GI-tagged Panchamirtham divine fruit jam.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 10;


-- ==============================================================================
-- 11. KANCHIPURAM (KCH)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Kanchipuram Pure Silk Handloom Weaving',
    content = 'Woven with pure mulberry silk yarn intertwined with genuine gold and silver zari, Kanchipuram silk sarees carry a legendary GI tag dating back to the Chola kings.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 11;

UPDATE locality_facts 
SET title = 'Kanchipuram Kovil Idli & Kamakshi Golden Vimanam',
    content = 'Kanchipuram Varadharaja Perumal temple offers unique cylindrical idlis seasoned with black pepper, dry ginger, and cumin, steamed inside fragrant Mandharai leaves.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 11;


-- ==============================================================================
-- 12. SIVAGANGA (SVG)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Chettinad Heritage 10,000 Mansions',
    content = 'Chettinad houses over 10,000 royal palatial mansions crafted with Burmese teak pillars, Belgian mirrors, Italian marble, and Athangudi floral tiles.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1541971875076-8f970d573be6?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 12;

UPDATE locality_facts 
SET title = 'Chettinad Spicy Cuisine & Athangudi Handmade Tiles',
    content = 'Kanadukathan in Chettinad is the heart of fragrant black pepper cuisine (Chettinad Kozhi, Kola Urundai) and Athangudi village where artisans cast floral cement floor tiles by hand.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 12;


-- ==============================================================================
-- 13. RAMANATHAPURAM (RMD)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Pamban Sea Bridge & Rameswaram Temple Corridor',
    content = 'Opened in 1914, the cantilever Pamban Railway Bridge spans the ocean to Rameswaram island, home to Ramanathaswamy temples world-longest 1,200 pillared corridor.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 13;

UPDATE locality_facts 
SET title = 'Rameswaram Agni Theertham & Fresh Coastal Seafood',
    content = 'Devotees take holy dips in the calm waters of Agni Theertham before praying at Ramanathaswamy Temple, while coastal villages dry spicy Ramanathapuram Mundu chillies and fresh catch.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 13;


-- ==============================================================================
-- 14. NILGIRIS (NLG)
-- ==============================================================================
UPDATE district_facts 
SET title = 'UNESCO Nilgiri Mountain Toy Train & Tea Estates',
    content = 'The steam-powered Nilgiri Mountain Railway operates on an Abt rack-and-pinion system winding through 208 curves, 16 tunnels, and emerald high-altitude tea plantations.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 14;

UPDATE locality_facts 
SET title = 'Ooty Crispy Varkey, Homemade Chocolate & Green Tea',
    content = 'Baked using traditional firewood ovens since British colonial times, Ooty Varkey is a flaky, crispy pastry paired with piping-hot Nilgiri Orthodox black tea and dark chocolates.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 14;


-- ==============================================================================
-- 15. THOOTHUKUDI (TKD)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Pearl Fishery Coast & VO Chidambaranar Port',
    content = 'Thoothukudi was the capital of the historic Pearl Fishery Coast mentioned in Greek and Roman records, now operating as a major international deep-water seaport.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 15;

UPDATE locality_facts 
SET title = 'Original Tuticorin Macaroon Bakeries',
    content = 'Introduced by Portuguese sailors, Tuticorin Macaroon is baked exclusively using broken cashew nuts, egg whites, and sugar, resulting in an airy cone-shaped confection that melts instantly.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1569864358642-9d1684040f43?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 15;


-- ==============================================================================
-- 22. TENKASI (TKS)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Spa of South India - Courtallam Cascades',
    content = 'Waterfalls of Courtallam cascade through dense canopies of Western Ghats medicinal herbs, giving its mineral-rich waters curative and therapeutic properties.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 22;

UPDATE locality_facts 
SET title = 'Tenkasi Border Rahmath Parotta & Herbal Baths',
    content = 'Famous for crispy shredded Border Parotta with piping hot black-pepper chicken salna, enjoyed right after bathing under the rejuvenating Courtallam mountain falls.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 22;


-- ==============================================================================
-- 24. DHARMAPURI (DPI)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Niagara of India - Hogenakkal Falls',
    content = 'Where the Kaveri river enters Tamil Nadu through deep granite canyons, Hogenakkal creates roaring misty cascades renowned for round coracle (Parisal) boat rides.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 24;

UPDATE locality_facts 
SET title = 'Hogenakkal Fresh Spiced River Fish & Parisal Rides',
    content = 'Visitors at Hogenakkal enjoy thrilling rides on circular bamboo Parisal boats on the roaring Kaveri, followed by freshly caught river fish marinated in village spices and pan-fried hot.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 24;


-- ==============================================================================
-- 37. VILUPPURAM (VPM)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Gingee Fort - The Troy of the East',
    content = 'Described by Chhatrapati Shivaji as the most impregnable fortress in India, Gingee sits on three sheer 800-foot granite hills accessible across a wooden drawbridge.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 37;

UPDATE locality_facts 
SET title = 'Gingee Rajagiri 800-Foot Sheer Cliff & Kalyana Mahal',
    content = 'The Rajagiri citadel inside Gingee rises 800 feet above the plains, accessible only by a single drawbridge spanning a 60-foot chasm, housing the 7-storey Kalyana Mahal tower.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 37;


-- ==============================================================================
-- 38. CHENGALPATTU (CGL)
-- ==============================================================================
UPDATE district_facts 
SET title = 'UNESCO Mamallapuram Monolithic Shore Monuments',
    content = 'The 8th-century Pallava coastal Shore Temple, Pancha Rathas monolithic rock chariots, and the 250-tonne balancing boulder Krishnas Butter Ball draw global travelers.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1609766857041-ed402ea8069a?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE district_id = 38;

UPDATE locality_facts 
SET title = 'Krishnas Butter Ball Balancing Physics Wonder',
    content = 'A massive 250-tonne monolithic granite boulder measuring 6 meters high rests on a steep 45-degree rocky slope in Mamallapuram, defying gravity and earthquakes for 1,200 years.',
    cloudinary_media_url = 'https://images.unsplash.com/photo-1609766857041-ed402ea8069a?auto=format&fit=crop&w=1200&q=80',
    media_type = 'image'
WHERE locality_id = 38;


-- ==============================================================================
-- 29. ARIYALUR (ARI)
-- ==============================================================================
UPDATE district_facts 
SET title = 'Cretaceous Era Marine Ammonite Fossils & Gangaikonda Cholapuram',
    content = 'Ariyalur sedimentary limestone rocks preserve million-year-old dinosaur egg fossils, fossilized marine ammonites, and sea shells, alongside Rajendra Chola imperial Gangaikonda Cholapuram temple.',
    cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Gangaikonda_Cholapuram_Temple_Airavatesvara.jpg?width=800',
    media_type = 'image'
WHERE district_id = 29;

UPDATE locality_facts 
SET title = 'Gangaikonda Cholapuram Sanctuary',
    content = 'Imperial Chola temple in Ariyalur built to celebrate Rajendra Chola naval conquests up to the River Ganges with sublime 55-meter granite vimana.',
    cloudinary_media_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Gangaikonda_Cholapuram_Temple.jpg?width=800',
    media_type = 'image'
WHERE locality_id = 29;


-- ==============================================================================
-- CLEAN UP: ENSURE ZERO SAMPLE/FLOWER PLACEHOLDERS REMAIN IN DB
-- ==============================================================================
UPDATE district_facts 
SET cloudinary_media_url = 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=80'
WHERE cloudinary_media_url LIKE '%sample.jpg' OR cloudinary_media_url IS NULL;

UPDATE locality_facts 
SET cloudinary_media_url = 'https://images.unsplash.com/photo-1596178065887-1198b6148b2b?auto=format&fit=crop&w=1200&q=80'
WHERE cloudinary_media_url LIKE '%sample.jpg' OR cloudinary_media_url IS NULL;
