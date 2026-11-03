-- ==============================================================================
-- TAMIL NADU DISTRICT EXPLORER - ALL 38 DISTRICTS COMPREHENSIVE SEED DATA
-- Fully compatible with MySQL 8.0 & PostgreSQL
-- Strict Rule 13: Zero Media Bytes in DB (Cloudinary secure URLs only)
-- Strict Rule 19: District Facts and Locality Facts are STRICTLY Separated
-- ==============================================================================

USE facts_vision_db;

-- ==========================================
-- 1. INSERT ALL 38 DISTRICTS OF TAMIL NADU
-- ==========================================
INSERT IGNORE INTO districts (id, name, code, state, description) VALUES
(1, 'Madurai', 'MDU', 'Tamil Nadu', 'Known as Thoonga Nagaram (The City that Never Sleeps) and the ancient cultural capital of Tamil Nadu.'),
(2, 'Chennai', 'CHN', 'Tamil Nadu', 'The capital of Tamil Nadu, known as the Detroit of Asia and the cultural gateway of South India.'),
(3, 'Coimbatore', 'CBE', 'Tamil Nadu', 'Known as the Manchester of South India, famous for textiles, manufacturing, and pristine Siruvani water.'),
(4, 'Tirunelveli', 'TVL', 'Tamil Nadu', 'Ancient city situated on the banks of perennial river Thamirabarani, world-famous for its wheat halwa.'),
(5, 'Thanjavur', 'TNJ', 'Tamil Nadu', 'The Rice Bowl of Tamil Nadu, imperial capital of the Cholas, home to the Great Living Chola Temples.'),
(6, 'Tiruchirappalli', 'TRY', 'Tamil Nadu', 'Geographic heart of Tamil Nadu, famous for the ancient Rockfort Temple, Kallanai dam, and Srirangam.'),
(7, 'Kanyakumari', 'KKI', 'Tamil Nadu', 'The southern tip of the Indian subcontinent, where the Bay of Bengal, Arabian Sea, and Indian Ocean meet.'),
(8, 'Salem', 'SLM', 'Tamil Nadu', 'Known as the Mango City and Steel City, surrounded by hills and home to the historic Mettur Dam.'),
(9, 'Erode', 'ERD', 'Tamil Nadu', 'Known as the Turmeric City (Manjal Maanagaram) and textile hub of South India, set by river Kaveri.'),
(10, 'Dindigul', 'DGL', 'Tamil Nadu', 'Known as the Lock City (Pootu Nagaram) and the birthplace of authentic aromatic Seeraga Samba Biryani.'),
(11, 'Kanchipuram', 'KCH', 'Tamil Nadu', 'The City of Thousand Temples, globally renowned for its traditional hand-woven Mulberry Silk Sarees.'),
(12, 'Sivaganga', 'SVG', 'Tamil Nadu', 'The Land of Brave Freedom Fighters and home to the majestic heritage mansions of Chettinad.'),
(13, 'Ramanathapuram', 'RMD', 'Tamil Nadu', 'Sacred coastal district featuring Rameswaram, the engineering marvel Pamban Bridge, and Dhanushkodi.'),
(14, 'Nilgiris', 'NLG', 'Tamil Nadu', 'The Blue Mountains, high-altitude biodiversity hotspot famous for tea gardens and Mountain Railway.'),
(15, 'Thoothukudi', 'TKD', 'Tamil Nadu', 'The Pearl City (Muthu Nagar), major historic seaport and salt manufacturing powerhouse of India.'),
(16, 'Vellore', 'VLR', 'Tamil Nadu', 'Historic garrison city famed for the 16th-century Vellore Fort, Golden Temple, and medical heritage.'),
(17, 'Tiruppur', 'TPU', 'Tamil Nadu', 'The Knitwear Capital of India, accounting for nearly 90% of cotton knitwear garment exports from India.'),
(18, 'Cuddalore', 'CUD', 'Tamil Nadu', 'Coastal district famous for Pichavaram, the second largest mangrove forest in the world, and silver beach.'),
(19, 'Tiruvannamalai', 'TVM', 'Tamil Nadu', 'One of the Pancha Bhoota Sthalams (representing Fire - Agni), world-famous for Karthigai Deepam and Giri Valam.'),
(20, 'Nagapattinam', 'NGP', 'Tamil Nadu', 'Coastal delta district featuring the historic seaside town of Velankanni and ancient Buddhist relics.'),
(21, 'Theni', 'THN', 'Tamil Nadu', 'Picturesque valley nestled in Western Ghats, famed for spice plantations, cardamom hills, and waterfalls.'),
(22, 'Tenkasi', 'TKS', 'Tamil Nadu', 'Known as the Spa of South India, famous for medicinal mineral waterfalls of Courtallam and Kasi Viswanathar temple.'),
(23, 'Virudhunagar', 'VNR', 'Tamil Nadu', 'Birthplace of Kamarajar, trade center of oil and pulses, and fireworks/printing capital (Sivakasi).'),
(24, 'Dharmapuri', 'DPI', 'Tamil Nadu', 'Land of ancient Adhiyaman chieftains, famous for Hogenakkal Falls known as the Niagara of India.'),
(25, 'Krishnagiri', 'KGI', 'Tamil Nadu', 'The Mango Capital of Tamil Nadu, producing premium mango varieties and historical hill forts.'),
(26, 'Namakkal', 'NKL', 'Tamil Nadu', 'Known as the Transport City and Poultry Capital of India, overlooked by a monolithic rock fortress.'),
(27, 'Karur', 'KRR', 'Tamil Nadu', 'Ancient Chera capital on the banks of Amaravathi, world-renowned as a home-textile export hub.'),
(28, 'Pudukkottai', 'PDK', 'Tamil Nadu', 'Historic princely state featuring 7th-century Jain rock-cut cave paintings at Sittanavasal.'),
(29, 'Ariyalur', 'ARI', 'Tamil Nadu', 'Geological treasure trove with prehistoric fossil beds, cement hub, and Rajendra Chola’s Gangaikonda Cholapuram.'),
(30, 'Perambalur', 'PBR', 'Tamil Nadu', 'Major agricultural region noted for sweet corn, shallots, cotton cultivation, and Ranjankudi Fort.'),
(31, 'Tirupathur', 'TPR', 'Tamil Nadu', 'Known as the Sandalwood City, nestled near the scenic Yelagiri Hills and Jolarpet railway junction.'),
(32, 'Ranipet', 'RPT', 'Tamil Nadu', 'Industrial hub famous for finished leather, BHEL heavy engineering, and Nawabs of Arcot history.'),
(33, 'Kallakurichi', 'KLK', 'Tamil Nadu', 'Picturesque agrarian district situated at the foothills of the Kalvarayan Hills and Gomukhi Dam.'),
(34, 'Mayiladuthurai', 'MYD', 'Tamil Nadu', 'Where peacocks danced to worship Shiva; home to Tranquebar (Danish Fort) and Cauvery pushkaram.'),
(35, 'Tiruvarur', 'TVU', 'Tamil Nadu', 'Cradle of Carnatic music (Trinity birthplace) and home to Asias largest temple chariot (Aazhi Ther).'),
(36, 'Tiruvallur', 'TVR', 'Tamil Nadu', 'Industrial-heritage gateway adjacent to Chennai, home to historic Veeraraghava Perumal temple and reservoirs.'),
(37, 'Viluppuram', 'VPM', 'Tamil Nadu', 'Historic crossroads dominated by the impregnable Gingee Fort, termed by Shivaji as the Troy of the East.'),
(38, 'Chengalpattu', 'CGL', 'Tamil Nadu', 'Coastal gateway renowned for UNESCO World Heritage rock-cut monuments of Mamallapuram and IT corridors.');

-- ==============================================================================
-- 2. INSERT STRICT DISTRICT FACTS (District-level Culture, History, Geography)
-- ==============================================================================
INSERT IGNORE INTO district_facts (district_id, title, fact_type, content, cloudinary_media_url, media_type) VALUES
-- Madurai
(1, 'Pandyan Dynasty Heritage', 'history', 'Madurai served as the seat of all three Tamil Sangams (poet assemblies) and was the capital of the Pandyan kingdom for over a millennium.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),
(1, 'Alanganallur Jallikattu', 'culture', 'The world-famous bull-taming festival Alanganallur Jallikattu has been celebrated annually during Pongal in Madurai district since the Sangam era.', 'https://res.cloudinary.com/yxlabsit/video/upload/dog.mp4', 'video'),

-- Chennai
(2, 'Marina Beach Coastline', 'geography', 'Marina Beach in Chennai is the second longest natural urban beach in the world, stretching over 13 kilometers along the Coromandel Coast.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),
(2, 'Classical Carnatic December Season', 'culture', 'Chennai hosts the worlds largest cultural music festival every December (Margazhi), recognized by UNESCO under its Creative Cities Network.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Coimbatore
(3, 'Manchester of South India', 'economy', 'Coimbatore is home to over 25,000 small, medium, and large textile mills, pumps, and engineering foundries, earning it the title Manchester of South India.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),
(3, 'World Sweetest Siruvani Water', 'geography', 'Siruvani water sourced from the Western Ghats is globally celebrated as one of the sweetest tasting natural drinking waters due to rich mineral balancing.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tirunelveli
(4, 'The Perennial Thamirabarani', 'geography', 'The Thamirabarani is the only perennial river in Tamil Nadu, originating in the Agasthiyar hills of the Western Ghats and flowing entirely within the state.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),
(4, 'Tirunelveli Halwa Culinary Craft', 'culture', 'Made exclusively with wheat milk, pure ghee, and enriched by Thamirabarani river minerals, Tirunelveli Halwa holds an irreplaceable place in Indian culinary history.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Thanjavur
(5, 'Granary of Tamil Nadu', 'economy', 'Fed by the fertile Cauvery delta canal irrigation network, Thanjavur produces the highest volume of paddy, rightfully earning the title Rice Bowl of Tamil Nadu.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),
(5, 'Chola Architectural Marvel', 'history', 'The Brihadisvara Temple (Peruvudaiyar Kovil) built by Raja Raja Chola I in 1010 CE has a monolithic granite dome (Kumbam) weighing an estimated 80 tons atop its 216 ft tower.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruchirappalli
(6, 'Ancient Hydraulic Engineering - Kallanai', 'history', 'Built by Karikala Chola across the Kaveri river in the 2nd century CE, the Grand Anicut (Kallanai) is the oldest water-diversion dam in continuous use in the world.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Kanyakumari
(7, 'Tri-Sea Confluence (Triveni Sangam)', 'geography', 'Kanyakumari is the unique geographical point on Earth where the Arabian Sea, Bay of Bengal, and Indian Ocean meet, allowing views of both sunrise and sunset over the ocean from the same beach.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Salem
(8, 'Salem Steel and Malgova Mangoes', 'economy', 'Salem is internationally recognized for its special grade surgical stainless steel plant (SAIL) and sweet GI-tagged Salem Malgova mango orchards.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Erode
(9, 'Asia Largest Turmeric Market', 'economy', 'Erode is fondly called the Yellow City (Manjal Maanagaram) as it operates one of Asia largest wholesale trading auction markets for turmeric roots and powders.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Dindigul
(10, 'Iron Locks & Seeraga Samba Biryani', 'culture', 'Dindigul holds geographical indication (GI) tags for both its handcrafted brass and iron tumbler locks and its unique wood-fire cooked Seeraga Samba mutton biryani.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Kanchipuram
(11, 'Silk Weaving Heritage', 'culture', 'Kanchipuram silk sarees are woven with pure mulberry silk yarn intertwined with authentic silver and gold zari threads, dating back to royal Chola court patronages.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Sivaganga
(12, 'Chettinad Heritage Architecture', 'culture', 'Chettinad in Sivaganga district houses over 10,000 royal palatial mansions built with Burmese teak, Italian marble, and Japanese tiles by the merchant seafaring community.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Ramanathapuram
(13, 'Pamban Sea Bridge Engineering', 'history', 'Opened in 1914, the Pamban cantilever railway bridge connecting mainland India to Rameswaram island was India first sea bridge, weathering over a century of marine salt winds.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Nilgiris
(14, 'UNESCO Nilgiri Mountain Railway', 'history', 'The Nilgiri Mountain Railway built by the British in 1908 uses the unique Abt rack-and-pinion gear system to climb steep gradients from Mettupalayam to Udhagamandalam (Ooty).', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Thoothukudi
(15, 'Pearl Fishery Coast of Antiquity', 'history', 'Mentioned in Greek and Roman trade records by Ptolemy and Pliny, Thoothukudi natural pearl oysters made it the epicenter of international ocean trading for centuries.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Vellore
(16, 'Vellore Mutiny of 1806', 'history', 'The Vellore Fort was the site of the 1806 Sepoy Mutiny, the very first major armed revolt against the British East India Company, preceding the 1857 rebellion by over 50 years.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruppur
(17, 'Dollar City of India', 'economy', 'Tiruppur accounts for over 50% of all Indian knitwear garments sold in Europe and the Americas, earning the moniker Dollar City due to immense foreign exchange earnings.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Cuddalore
(18, 'Pichavaram Mangrove Eco-System', 'geography', 'Covering over 1,100 hectares with over 4,000 natural water channels, Pichavaram is the second largest mangrove wetland forest on Earth, serving as a vital natural tsunami barrier.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruvannamalai
(19, 'Karthigai Deepam Flame on Holy Mountain', 'culture', 'During the Tamil month of Karthigai, a mammoth cauldron holding 3,000 kg of ghee is lit atop the 2,668-foot Annamalai hill, visible for up to 35 kilometers away.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Nagapattinam
(20, 'Our Lady of Good Health Velankanni', 'culture', 'Velankanni, located on the Coromandel coast, is regarded as the Lourdes of the East, drawing millions of pilgrims from diverse religious backgrounds every year.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Theni
(21, 'Western Ghats Spice Valley', 'economy', 'Enclosed by Cardamom Hills and the Cumbum valley, Theni is Tamil Nadu largest producer of organic cardamom, black pepper, and premium green grapes.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tenkasi
(22, 'Courtallam Natural Herb Infused Cascades', 'geography', 'Waterfalls of Courtallam pass through thick forest canopies of medicinal herbs in the Western Ghats, giving its waters therapeutic and curative properties.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Virudhunagar
(23, 'Srivilliputhur Andal Temple Tower (TN Government Official Emblem)', 'history', 'The majestic 11-tier 192-foot Rajagopuram of the Srivilliputhur Andal Temple was built by King Periya Veerappa Nayak and serves as the official State Emblem of the Government of Tamil Nadu.', 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=80', 'image'),
(23, 'Sivakasi Fireworks, Matches & Offset Printing (Little Japan)', 'economy', 'Sivakasi produces over 70% of Indias fireworks and safety matches, and 80% of premium offset packaging, hailed by Jawaharlal Nehru as Kutti Japan (Little Japan).', 'https://images.unsplash.com/photo-1498931299472-f7a63a5a1cfa?auto=format&fit=crop&w=1200&q=80', 'image'),

-- Dharmapuri
(24, 'Niagara of India - Hogenakkal', 'geography', 'Hogenakkal, where the Kaveri river enters Tamil Nadu through deep granite gorges, creates stunning roaring cascades renowned for coracle boat rides and river baths.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Krishnagiri
(25, 'Mango Processing Superpower', 'economy', 'Krishnagiri produces over 300,000 tonnes of mangoes each season, housing modern pulp export units that supply fruit nectar to global beverage industries.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Namakkal
(26, 'Egg City of India', 'economy', 'Producing over 35 million table eggs daily, Namakkal is India largest poultry farming zone, feeding consumers across India and Middle Eastern export markets.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Karur
(27, 'Home Textile Capital', 'economy', 'Karur is India leading exporter of bed linen, kitchen textiles, table mats, and curtains, generating over 4,000 crore rupees annually in foreign exports.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Pudukkottai
(28, 'Sittanavasal Fresco Rock Art', 'history', 'Sittanavasal cave in Pudukkottai houses exquisite 7th-century vegetable-dye fresco paintings of lotus ponds and dancing maidens rivaling Ajanta in artistic finesse.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Ariyalur
(29, 'Cretaceous Era Fossil Reserve', 'geography', 'Ariyalur sedimentary limestone rocks contain million-year-old dinosaur egg fossils, fossilized marine ammonites, and sea shells, attracting paleontologists worldwide.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Perambalur
(30, 'Historic Ranjankudi Fort', 'history', 'The 17th-century Ranjankudi Fort was built by the Nawab of the Carnatic and witnessed key battles between English and French forces in the Carnatic Wars.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tirupathur
(31, 'Yelagiri Hill Station Orchards', 'geography', 'Perched at 1,110 meters above sea level, Yelagiri hills in Tirupathur district is a tranquil plateau dotted with fruit orchards, rose gardens, and tribal villages.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Ranipet
(32, 'Finished Leather Industrial Base', 'economy', 'Ranipet SIPCOT complex is one of the world largest clusters for processing top-grain bovine leather used by luxury shoe and handbag designers globally.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Kallakurichi
(33, 'Kalvarayan Hills Herbal Flora', 'geography', 'The pristine Kalvarayan hills in Kallakurichi are famous for untouched tribal settlements, crystal clear waterfalls, and diverse endemic medicinal flora.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Mayiladuthurai
(34, 'Danish Fort of Tranquebar (Tharangambadi)', 'history', 'Constructed in 1620, Fort Dansborg in Tharangambadi is the second largest Danish fortress built outside Europe, featuring colonial maritime architecture.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruvarur
(35, 'Trinity of Carnatic Music', 'culture', 'Tiruvarur is the blessed birthplace of all three greatest Carnatic music composers: Tyagaraja, Muthuswami Dikshitar, and Syama Sastri, born in the same 18th century street.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruvallur
(36, 'Water Guardian of Chennai City', 'geography', 'Tiruvallur district holds the historic Poondi Reservoir, Cholavaram, and Chembarambakkam lakes that provide life-giving drinking water to millions of Chennai residents.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Viluppuram
(37, 'Impregnable Troy of the East - Gingee Fort', 'history', 'Stretching across three rocky hills over 11 square kilometers, Gingee Fort was called the most impregnable fortress in India by Chhatrapati Shivaji due to its 60-foot deep moats.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Chengalpattu
(38, 'UNESCO Shore Temple & Pancha Rathas', 'history', 'Mamallapuram in Chengalpattu displays 7th-century Pallava monolithic rock-cut monuments, bas-relief of Arjunas Penance, and the legendary Shore Temple defying ocean waves.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image');


-- ==============================================================================
-- 3. INSERT LOCALITIES (Prominent Towns, Villages & Neighborhoods)
-- ==============================================================================
INSERT IGNORE INTO localities (id, district_id, name, pincode, latitude, longitude, description) VALUES
(1, 1, 'Meenakshi Temple Precinct', '625001', 9.9195, 78.1193, 'Concentric street layout surrounding the historic Meenakshi Sundareswarar temple in Madurai.'),
(2, 2, 'Mylapore', '600004', 13.0336, 80.2687, 'Ancient cultural neighborhood older than Chennai city, home to Kapaleeshwarar temple and San Thome.'),
(3, 3, 'RS Puram & Siruvani Foot', '641002', 11.0084, 76.9482, 'Vibrant commercial and culinary neighborhood in western Coimbatore with Siruvani water reservoir access.'),
(4, 4, 'Tirunelveli Town & Nellai Bazaar', '627001', 8.7289, 77.7081, 'Historic settlement surrounding the Nellaiappar temple and original century-old halwa bazaar street.'),
(5, 5, 'Brihadisvara Temple Complex', '613007', 10.7828, 79.1318, 'Sacred complex surrounding the 1000-year-old Big Temple built by the Great Cholas in Thanjavur.'),
(6, 6, 'Srirangam Island', '620006', 10.8622, 78.6908, 'River island formed by Cauvery and Kollidam, holding the worlds largest functioning Hindu temple complex.'),
(7, 7, 'Vivekananda Rock Beach Zone', '629702', 8.0780, 77.5550, 'The coastal edge at Kanyakumari facing the Vivekananda Memorial and Saint Thiruvalluvar granite statue.'),
(8, 8, 'Yercaud Shevaroy Foothills', '636601', 11.7753, 78.2093, 'Scenic hill resort settlement famous for coffee plantations, spice gardens, and cool mountain climate in Salem.'),
(9, 9, 'Bhavani Kooduthurai', '638301', 11.4485, 77.6834, 'Holy confluence town in Erode where rivers Kaveri, Bhavani, and the mystical Amuthanathi meet.'),
(10, 10, 'Palani Foothills Zone', '624601', 10.4504, 77.5195, 'Holy temple town in Dindigul at the base of Sivagiri hill, famous for Murugan Dhandayuthapani temple.'),
(11, 11, 'Kanchi Silk Weaver Quarter', '631502', 12.8342, 79.7036, 'Historic weaving colony streets in Kanchipuram housing generation-old Jacquard handlooms.'),
(12, 12, 'Kanadukathan', '630103', 10.1706, 78.7844, 'The crown jewel of Chettinad heritage village in Sivaganga, filled with colossal palatial mansions.'),
(13, 13, 'Rameswaram Agni Theertham', '623526', 9.2876, 79.3129, 'Sacred seashore in Ramanathapuram holding Ramanathaswamy temple with the longest pillared corridor in the world.'),
(14, 14, 'Coonoor Tea Estate Ridge', '643101', 11.3530, 76.7959, 'Emerald tea garden hill settlement in the Nilgiris, famous for aromatic green tea, eucalyptus, and valleys.'),
(15, 15, 'Tuticorin Old Port Harbour', '628001', 8.7642, 78.1348, 'Historic harbour street famous for century-old macaroon bakeries, salt pans, and marine ships in Thoothukudi.'),
(16, 16, 'Vellore Fort Ramparts', '632004', 12.9234, 79.1325, 'Granite fort surrounded by deep crocodile moats, housing Jalakanteswarar temple, church, and mosque.'),
(17, 17, 'Kumaran Road Garment Cluster', '641601', 11.1085, 77.3411, 'Epicenter of Tiruppur textile exports, design studios, and high-efficiency knitting manufacturing units.'),
(18, 18, 'Pichavaram Waterway Canal Base', '608102', 11.4285, 79.7788, 'Eco-tourism boat jetty in Cuddalore navigating serene waterways shaded by lush mangrove root canopies.'),
(19, 19, 'Arunachaleswarar Giri Veedhi', '606601', 12.2253, 79.0747, 'The sacred 14 km circular road around the holy hill in Tiruvannamalai walked bare-foot by millions on full moon nights.'),
(20, 20, 'Velankanni Coastal Basilica', '611111', 10.6805, 79.8496, 'Neo-Gothic Catholic pilgrimage shrine perched along the Bay of Bengal coastline in Nagapattinam.'),
(21, 21, 'Megamalai Cloud Mountain', '625579', 9.6917, 77.3828, 'Cool mist-covered mountain retreat in Theni with cardamom, cinnamon, and wildlife corridors.'),
(22, 22, 'Courtallam Main Falls Precinct', '627802', 8.9298, 77.2693, 'Natural waterfall basin in Tenkasi cascading from 160 feet over medicinal herbs, open for therapeutic baths.'),
(23, 23, 'Sivakasi Jubilee Print Town', '626123', 9.4533, 77.7942, 'Dynamic industrial town in Virudhunagar buzzing with printing machineries, matchworks, and export hubs.'),
(24, 24, 'Hogenakkal Boat Jetty', '636810', 12.1182, 77.7766, 'Riverbank in Dharmapuri famous for traditional circular coracle boats and freshly fried spiced river fish.'),
(25, 25, 'Rayakottai Hill Fort Precinct', '635116', 12.5186, 78.0347, 'Historic hill fortress in Krishnagiri built by Vijayanagara kings and later held by Tipu Sultan against British forces.'),
(26, 26, 'Namakkal Rock Fort Summit', '637001', 13.2215, 78.1674, 'Single monolithic granite rock towering in Namakkal center with an open-air 18-foot Hanuman statue.'),
(27, 27, 'Thirukkampuliyur Handloom Belt', '639115', 10.9574, 78.0818, 'Traditional weavers settlement in Karur crafting world-class organic jacquard table and kitchen textiles.'),
(28, 28, 'Sittanavasal Heritage Valley', '622101', 10.4578, 78.7291, 'Rock-cut Jain monastery in Pudukkottai holding millennium-old lotus pond murals and natural musical echo caves.'),
(29, 29, 'Gangaikonda Cholapuram Sanctuary', '612901', 11.2059, 79.4520, 'Imperial Chola temple in Ariyalur built to celebrate Rajendra Chola naval conquests up to the River Ganges.'),
(30, 30, 'Ranjankudi Fortress', '621115', 11.3855, 78.9644, 'Imposing limestone citadel in Perambalur with defensive bastions and deep moats from the Carnatic wars.'),
(31, 31, 'Yelagiri Athanavur Lake Valley', '635853', 12.5786, 78.6394, 'Scenic valley center in Tirupathur with boating lake, fruit research station, and trekking trailheads.'),
(32, 32, 'Arcot Nawab Heritage Precinct', '632503', 12.9056, 79.3333, 'Historic capital of the Nawabs of the Carnatic in Ranipet, famous for the Delhi Gate and iconic Makkan Peda sweet.'),
(33, 33, 'Kalvarayan Periyar Falls Edge', '606207', 11.8312, 78.7533, 'Lush hidden forest waterfalls in Kallakurichi surrounded by dense herbal thickets and misty hill ridges.'),
(34, 34, 'Tranquebar Fort Dansborg', '609313', 11.0333, 79.8519, 'Seaside heritage colonial Danish fortress in Mayiladuthurai overlooking gentle rolling Bay of Bengal waves.'),
(35, 35, 'Tiruvarur Kamalalayam Tank', '610001', 10.7733, 79.6339, 'One of the largest temple tanks in India covering 33 acres, located next to the majestic Thyagarajaswamy Temple.'),
(36, 36, 'Veeraraghava Swamy Temple Precinct', '602001', 13.1432, 79.9079, 'Ancient Vaidya Veeraraghava Perumal temple street in Tiruvallur, where devotees pray for healing from ailments.'),
(37, 37, 'Gingee Rajagiri Hill Fort', '604202', 12.2536, 79.4183, 'The tallest of three Gingee hills in Viluppuram with a sheer 800-foot cliff accessible only via a wooden drawbridge.'),
(38, 38, 'Mamallapuram Shoreline Monuments', '603104', 12.6269, 80.1927, 'UNESCO World Heritage coastal monument complex in Chengalpattu with the 8th-century monolithic Shore Temple.');


-- ==============================================================================
-- 4. INSERT STRICT LOCALITY FACTS (Local Food, Folklore, Secrets, Street Lore)
-- ==============================================================================
INSERT IGNORE INTO locality_facts (locality_id, title, fact_type, content, cloudinary_media_url, media_type) VALUES
-- Madurai Locality Facts
(1, 'Famous Jigarthanda Origin', 'food', 'East Masi Street in this locality is the original birthplace of authentic Madurai Jigarthanda dessert made with almond gum and reduced milk.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),
(1, 'Pillars of Musical Mystery', 'specialty', 'Inside this locality temple corridor, 5 musical pillars carved out of a single granite stone resonate with classical swaras when tapped.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Chennai Locality Facts
(2, 'Authentic Filter Coffee & Mami Mess', 'food', 'Mylapore is home to century-old traditional vegetarian messes serving authentic frothy South Indian Kumbakonam-style degree filter coffee in brass dabarah-sets.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),
(2, 'Kapaleeshwarar 63 Nayanmar Festival', 'culture', 'The Arupathimoovar festival in Mylapore draws over half a million devotees as 63 bronze Shaivite saints are taken around the temple streets in a grand procession.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Coimbatore Locality Facts
(3, 'Annapoorna Sambar Recipe Secret', 'food', 'RS Puram food streets are famed for Coimbatore unique sweet-spiced sambar crafted with a proprietary blend of 14 ground native hill spices.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tirunelveli Locality Facts
(4, 'Iruttu Kadai Halwa Tradition', 'food', 'This single street shop operates only after dusk lit by a single bulb, serving steaming hot wheat halwa on lotus leaves since the year 1900.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Thanjavur Locality Facts
(5, 'Shadow That Never Falls Mystery', 'specialty', 'Local legend holds that the octagonal granite Shikhara atop the Big Temple was engineered so that its main shadow never falls on the ground at noon.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruchirappalli Locality Facts
(6, 'Twenty-One Temple Gopurams', 'specialty', 'Srirangam island temple features 21 magnificent gopurams, including the towering Rajagopuram rising 236 feet, the second tallest temple tower in Asia.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Kanyakumari Locality Facts
(7, 'Thiruvalluvar 133-Foot Statue Weight', 'specialty', 'The stone statue of saint poet Thiruvalluvar stands exactly 133 feet tall to represent the 133 chapters of Thirukkural, weighing over 7,000 tonnes of carved granite.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Salem Locality Facts
(8, 'Yercaud 32-km Loop Road Coffee Lore', 'specialty', 'The scenic 32-km loop road starting in Yercaud winds through heritage British coffee plantations cultivating rare Arabica beans shaded by silver oak trees.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Erode Locality Facts
(9, 'Bhavani Jamakkalam Handloom Craft', 'art', 'Locality weavers around Bhavani produce the famous GI-tagged Jamakkalam (heavy jacquard cotton carpets) celebrated for brilliant geometric cross-bands.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Dindigul Locality Facts
(10, 'Palani Panchamirtham GI Heritage', 'food', 'The holy offering Panchamirtham prepared with Virupachi hill bananas, pure jaggery, cow ghee, honey, and cardamom holds a global GI protection tag for its natural preservation.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Kanchipuram Locality Facts
(11, 'Kanchi Idli Steamed in Mandharai Leaves', 'food', 'Local traditional kitchens steam special Kanchi Idlis seasoned with ginger, pepper, and cumin inside fragrant Mandharai leaves, preserving freshness for days.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Sivaganga Locality Facts
(12, 'Chettinad Spicy Pepper Chicken & Athangudi Tiles', 'food', 'Kanadukathan cooks use stone-ground Kalpasi (black stone flower) and native shallots, while neighborhood artisans hand-pour exquisite patterned Athangudi cement tiles.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Ramanathapuram Locality Facts
(13, 'Twenty-Two Holy Wells of Rameswaram', 'specialty', 'Within the temple corridor, pilgrims bathe in 22 distinct freshwater wells (Theerthams), each tasting completely different despite being surrounded by salty ocean water.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Nilgiris Locality Facts
(14, 'Coonoor Homemade Dark Chocolate Craft', 'food', 'Coonoor cottage chocolatiers craft pure dark chocolates infused with organic plantation spices, roasted almonds, and high-grown Nilgiri tea leaves.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Thoothukudi Locality Facts
(15, 'Authentic Tuticorin Macaroon Secret', 'food', 'Introduced by Portuguese sailors and perfected by local bakers, Tuticorin macaroons are made with egg whites, sugar, and cashew nuts instead of European almonds.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Vellore Locality Facts
(16, 'Jalakanteswarar Temple Stone Chariot', 'art', 'Inside Vellore Fort, the Kalyana Mandapam is acclaimed as a pinnacle of Vijayanagara sculpture, featuring intricate monolithic stone chains and mythical Yali pillars.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruppur Locality Facts
(17, 'Zero Liquid Discharge Dyeing Pioneer', 'specialty', 'Tiruppur processing plants pioneered India first 100% Zero Liquid Discharge (ZLD) technology, recovering 95% of industrial water to protect the Noyyal river ecology.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Cuddalore Locality Facts
(18, 'Root Bridges of Pichavaram Mangroves', 'specialty', 'The stilt roots (pneumatophores) of Rhizophora trees interlock underwater in this locality, functioning like natural oxygen snorkels rising above the tidal waters.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruvannamalai Locality Facts
(19, 'Eight Ashta Lingams on Path', 'specialty', 'The 14 km Giri Valam path is guarded by eight sacred lingams (Indra, Agni, Yama, Niruthi, Varuna, Vayu, Kubera, Esanya), each aligned to cosmic cardinal directions.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Nagapattinam Locality Facts
(20, 'Miraculous Sea Protection Chapel', 'folklore', 'During the catastrophic 2004 Indian Ocean Tsunami, ocean waves flooded nearby coastal land but receded before entering the Basilica grounds, saving hundreds inside.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Theni Locality Facts
(21, 'Cumbum Valley Year-Round Green Grapes', 'food', 'Due to warm valley micro-climates, farmers in this locality harvest Muscat Hamburg (Paneer Thratchai) grapes thrice a year, a phenomenon unique in India.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tenkasi Locality Facts
(22, 'Five Falls (Aintharuvi) Five Water Streams', 'geography', 'At Aintharuvi near Courtallam, the mountain stream splits naturally into five distinct cascade branches, representing the five heads of the sacred serpent Adisesha.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Virudhunagar Locality Facts
(23, 'Virudhunagar Ennai Parotta (Coin / Poricha Parotta)', 'food', 'Virudhunagar Ennai Parotta is shallow-fried in bubbling hot groundnut oil until crispy golden-brown outside while retaining super soft, flaky layers inside. It is traditionally served with spicy mutton or chicken salna.', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=1200&q=80', 'image'),
(23, 'Srivilliputhur Palkova (GI Tagged Milk Sweet)', 'specialty', 'Srivilliputhur Palkova is world-famous and holds a Geographical Indication (GI) tag. Made exclusively from rich, full-fat cow milk and simmered with pure sugar in heavy copper vessels, it has an authentic melt-in-the-mouth texture.', 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?auto=format&fit=crop&w=1200&q=80', 'image'),
(23, 'Virudhunagar Kaara Sevu & Traditional Athirasam', 'food', 'Crispy, crunchy Kaara Sevu heavily spiced with crushed black pepper and garlic, alongside tender jaggery-infused Athirasam, fried in wood-pressed groundnut oil, are the signature tea-time snacks of Virudhunagar.', 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=1200&q=80', 'image'),

-- Dharmapuri Locality Facts
(24, 'Coracle Boats (Parisal) Bamboo Craft', 'specialty', 'Artisans on the banks of Hogenakkal weave giant bowl-shaped Parisal boats using native river bamboo lined with waterproof tar, steered skillfully with a single wooden oar.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Krishnagiri Locality Facts
(25, 'Rayakottai Hidden Escape Tunnels', 'folklore', 'Local folklore tells of subterranean escape tunnels carved inside Rayakottai fortress hill connecting all the way to Mysore kingdom over 100 kilometers away.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Namakkal Locality Facts
(26, 'Roofless Sanctum of Anjaneyar', 'folklore', 'The monolithic 18-foot Anjaneyar statue stands in the open air without a temple roof above, believing that Lord Hanuman gazes directly into the eyes of Narasimha on the rock fort.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Karur Locality Facts
(27, 'Pasupatheeswarar Lingam Sun Ray Event', 'folklore', 'For five consecutive days every year in the Tamil month of Panguni, morning sun rays penetrate deep into the sanctum and illuminate the sacred Shiva Lingam.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Pudukkottai Locality Facts
(28, 'Arivar Koil Echo Chamber Phenomenon', 'specialty', 'Speaking the sacred word Om inside the Sittanavasal natural cave chamber creates a deep vibrating harmonic acoustic resonance that sustains for up to 10 seconds.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Ariyalur Locality Facts
(29, 'Chola Royal Lion Well (Simhakinaru)', 'specialty', 'Gangaikonda Cholapuram features a colossal lion statue carved above a spiral stepwell, used by Chola royalty to store holy water brought from the Ganges.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Perambalur Locality Facts
(30, 'Deep Moats & Secret Gunpowder Cellars', 'history', 'Ranjankudi fort lower citadel contains hidden subterranean powder magazines and defensive bastions that repelled British sieges during the Carnatic wars.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tirupathur Locality Facts
(31, 'Jalagamparai Herb Waterfalls Stream', 'geography', 'Cascading from the Yelagiri hills, the Attaru river stream at Jalagamparai forms a natural waterfall surrounded by dense aromatic herbal groves.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Ranipet Locality Facts
(32, 'Original Arcot Makkan Peda Recipe', 'food', 'Created in the royal sweet kitchens of the Nawab of Arcot, Makkan Peda is crafted from concentrated khoya stuffed with dry fruits and soaked in saffron sugar syrup.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Kallakurichi Locality Facts
(33, 'Megam Falls Misty Shroud', 'geography', 'Periyar and Megam waterfalls in the Kalvarayan hills remain enveloped in dense mountain fog during early mornings, creating a magical rainforest atmosphere.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Mayiladuthurai Locality Facts
(34, 'Ziegenbalg First Printing Press in India', 'history', 'In 1712, Danish missionary Bartholomaeus Ziegenbalg established one of India earliest printing presses here in Tranquebar, printing the New Testament in Tamil.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruvarur Locality Facts
(35, 'Asia Largest Temple Car (Aazhi Ther)', 'specialty', 'The colossal Aazhi Ther temple car of Tiruvarur weighs over 300 tonnes, stands 96 feet tall, and requires thousands of devotees and hydraulic bulldozers to pull through town streets.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Tiruvallur Locality Facts
(36, 'Hrit-Tapa-Nasini Tank Holy Immersion', 'folklore', 'The large sacred tank of the Veeraraghava temple is known as Hrit-Tapa-Nasini, where pilgrims take holy dips believing in its power to cure persistent ailments.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Viluppuram Locality Facts
(37, 'Kalyana Mahal Seven-Storeyed Square Tower', 'art', 'Inside Gingee Fort, the magnificent 7-storey Indo-Islamic architectural tower built with an internal water cooling pipeline still stands intact.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image'),

-- Chengalpattu Locality Facts
(38, 'Arjunas Penance Giant Monolithic Relief', 'art', 'Carved onto two massive 90-foot boulders in Mamallapuram, this bas-relief features over 100 figures of gods, humans, and life-sized elephants marvelously sculpted.', 'https://res.cloudinary.com/yxlabsit/image/upload/sample.jpg', 'image');

