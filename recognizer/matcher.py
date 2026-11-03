import cv2
import numpy as np
import os
import json
import urllib.request
import urllib.error
from typing import Dict, Tuple, Optional, List

# Cloudinary Reference Image Registry (Pure In-Memory Fallback Map)
CLOUDINARY_GOD_REFERENCES = {
    "GOD_01_BRAHMA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707278/facts_vision/gods/reference_images/GOD_01_BRAHMA_reference.jpg",
    "GOD_02_VISHNU": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707280/facts_vision/gods/reference_images/GOD_02_VISHNU_reference.jpg",
    "GOD_03_SHIVA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707280/facts_vision/gods/reference_images/GOD_03_SHIVA_reference.jpg",
    "GOD_04_DURGA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707282/facts_vision/gods/reference_images/GOD_04_DURGA_reference.jpg",
    "GOD_05_LAKSHMI": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707283/facts_vision/gods/reference_images/GOD_05_LAKSHMI_reference.jpg",
    "GOD_06_SARASWATI": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707284/facts_vision/gods/reference_images/GOD_06_SARASWATI_reference.jpg",
    "GOD_07_KRISHNA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707285/facts_vision/gods/reference_images/GOD_07_KRISHNA_reference.jpg",
    "GOD_08_RAMA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707286/facts_vision/gods/reference_images/GOD_08_RAMA_reference.jpg",
    "GOD_09_SITA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707287/facts_vision/gods/reference_images/GOD_09_SITA_reference.jpg",
    "GOD_10_HANUMAN_GADA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707289/facts_vision/gods/reference_images/GOD_10_HANUMAN_GADA_reference.jpg",
    "GOD_11_GANESHA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707290/facts_vision/gods/reference_images/GOD_11_GANESHA_reference.jpg",
    "GOD_12_MURUGAN": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707291/facts_vision/gods/reference_images/GOD_12_MURUGAN_reference.jpg",
    "GOD_13_INDRA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707292/facts_vision/gods/reference_images/GOD_13_INDRA_reference.jpg",
    "GOD_14_NARASIMHA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707293/facts_vision/gods/reference_images/GOD_14_NARASIMHA_reference.jpg",
    "GOD_15_SURYA": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707295/facts_vision/gods/reference_images/GOD_15_SURYA_reference.jpg",
    "GOD_16_HANUMAN_TAIL": "https://res.cloudinary.com/yxlabsit/image/upload/v1793707296/facts_vision/gods/reference_images/GOD_16_HANUMAN_TAIL_reference.jpg"
}

class ImageMatcher:
    def __init__(self, reference_dir: str = "reference_images", min_matches: int = 8):
        self.reference_dir = reference_dir
        self.min_matches = min_matches
        
        # Initialize ORB detector tuned for coloring art, landmarks, and illustrations
        self.orb = cv2.ORB_create(
            nfeatures=3000,
            scaleFactor=1.2,
            nlevels=8,
            edgeThreshold=15,
            firstLevel=0,
            WTA_K=2,
            scoreType=cv2.ORB_HARRIS_SCORE,
            patchSize=31,
            fastThreshold=10
        )
        
        # Brute Force Matcher using Hamming distance for binary ORB descriptors
        self.bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=False)
        
        # Pure In-Memory storage for reference keypoints and descriptors
        # Format: { landmark_code: { "keypoints": list, "descriptors": ndarray, "keypoints_count": int, "source": str } }
        self.reference_db: Dict[str, dict] = {}
        
        # Load all references from Cloudinary into RAM
        self.load_all_references()

    def _extract_features(self, image_np: np.ndarray) -> Tuple[Optional[List], Optional[np.ndarray]]:
        """Convert to grayscale, normalize contrast, and extract ORB keypoints and descriptors."""
        if len(image_np.shape) == 3:
            gray = cv2.cvtColor(image_np, cv2.COLOR_BGR2GRAY)
        else:
            gray = image_np
            
        # Histogram equalization for consistent lighting and high line contrast
        gray = cv2.equalizeHist(gray)
        keypoints, descriptors = self.orb.detectAndCompute(gray, None)
        return keypoints, descriptors

    def register_reference_from_bytes(self, landmark_code: str, image_bytes: bytes, source: str = "memory") -> bool:
        """Register a reference image into volatile RAM memory (NO disk writes)."""
        nparr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        if img is None:
            return False

        kps, descs = self._extract_features(img)
        if descs is not None and len(descs) > 0:
            self.reference_db[landmark_code] = {
                "keypoints": kps,
                "descriptors": descs,
                "keypoints_count": len(kps),
                "source": source
            }
            return True
        return False

    def register_reference(self, landmark_code: str, image_bytes: bytes) -> bool:
        """Registers reference directly into RAM (NO local disk file created)."""
        return self.register_reference_from_bytes(landmark_code, image_bytes, source="live_registration")

    def load_from_cloudinary_urls(self, url_dict: Dict[str, str]) -> int:
        """Downloads images from Cloudinary directly into RAM and extracts ORB features."""
        loaded_count = 0
        print(f"[Cloudinary Recognizer] Loading {len(url_dict)} deity references from Cloudinary into RAM...")
        
        for code, url in url_dict.items():
            if not url or not url.startswith("http"):
                continue
            try:
                req = urllib.request.Request(
                    url, 
                    headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
                )
                with urllib.request.urlopen(req, timeout=12) as response:
                    raw_bytes = response.read()
                    if self.register_reference_from_bytes(code, raw_bytes, source=f"cloudinary:{url}"):
                        loaded_count += 1
                        print(f"   [Cloud] Loaded {code} from Cloudinary into RAM ({len(raw_bytes)//1024} KB)")
            except Exception as e:
                print(f"   [Notice] Could not load {code} from Cloudinary: {e}")

        return loaded_count

    def load_all_references(self):
        """
        Loads all reference images strictly from Cloudinary into RAM.
        Zero files are read or written to disk.
        """
        self.reference_db.clear()
        
        # 1. Fetch dynamic deity URLs from Express Backend if running
        backend_url = "http://127.0.0.1:5000/api/gods"
        loaded = 0
        try:
            req = urllib.request.Request(backend_url, headers={'User-Agent': 'OpenCV-Recognizer/1.0'})
            with urllib.request.urlopen(req, timeout=4) as resp:
                data = json.loads(resp.read().decode('utf-8'))
                if data.get('success') and 'data' in data:
                    dynamic_urls = {}
                    for item in data['data']:
                        code = item.get('god_code')
                        img_url = item.get('cloudinary_image_url')
                        if code and img_url and img_url.startswith('http'):
                            dynamic_urls[code] = img_url
                    
                    if dynamic_urls:
                        print(f"[Recognizer] Fetched {len(dynamic_urls)} Cloudinary deity URLs from database API.")
                        loaded = self.load_from_cloudinary_urls(dynamic_urls)
        except Exception as e:
            print(f"[Recognizer] Backend API not immediately available ({e}), using direct Cloudinary registry...")

        # 2. If backend was offline, load using direct Cloudinary registry
        if loaded < len(CLOUDINARY_GOD_REFERENCES):
            missing_dict = {
                k: v for k, v in CLOUDINARY_GOD_REFERENCES.items() 
                if k not in self.reference_db
            }
            if missing_dict:
                loaded += self.load_from_cloudinary_urls(missing_dict)

        print(f"[Recognizer] Successfully initialized {len(self.reference_db)} deities directly from Cloudinary in RAM!")

    def match_image(self, query_bytes: bytes) -> dict:
        """
        Compare query image bytes with all indexed reference deities.
        Applies:
        1. Lowe's Ratio Test (0.75 strict threshold)
        2. RANSAC Homography Geometric Consistency (prevents false cross-matching)
        3. Runner-up safety margin check (strictly prevents playing other gods' songs)
        """
        nparr = np.frombuffer(query_bytes, np.uint8)
        query_img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        if query_img is None:
            return {
                "status": "error",
                "message": "Invalid or unreadable image bytes",
                "matched_code": None,
                "confidence": 0.0,
                "is_matched": False
            }

        # Normalize high-resolution phone captures to max 1280px for swift processing
        h, w = query_img.shape[:2]
        max_dim = max(h, w)
        if max_dim > 1280:
            scale = 1280.0 / max_dim
            query_img = cv2.resize(query_img, (int(w * scale), int(h * scale)), interpolation=cv2.INTER_AREA)

        q_kps, q_descs = self._extract_features(query_img)
        if q_descs is None or len(q_descs) == 0:
            return {
                "status": "no_features",
                "message": "Could not detect distinct visual features in the photo. Please align closer with good lighting.",
                "matched_code": None,
                "confidence": 0.0,
                "is_matched": False
            }

        candidates = []

        for landmark_code, ref_data in self.reference_db.items():
            ref_descs = ref_data["descriptors"]
            ref_kps = ref_data.get("keypoints")

            # k-NN Match with k=2
            raw_matches = self.bf.knnMatch(q_descs, ref_descs, k=2)

            # Lowe's ratio test (strict 0.75 ratio)
            good_matches = []
            for m_pair in raw_matches:
                if len(m_pair) == 2:
                    m, n = m_pair
                    if m.distance < 0.75 * n.distance:
                        good_matches.append(m)

            if len(good_matches) < self.min_matches:
                continue

            # Geometric verification using RANSAC Homography
            inliers_count = 0
            if len(good_matches) >= 8 and ref_kps is not None:
                src_pts = np.float32([q_kps[m.queryIdx].pt for m in good_matches]).reshape(-1, 1, 2)
                dst_pts = np.float32([ref_kps[m.trainIdx].pt for m in good_matches]).reshape(-1, 1, 2)

                try:
                    H, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC, 5.0)
                    if mask is not None:
                        inliers_count = int(np.sum(mask))
                except Exception:
                    inliers_count = len(good_matches)
            else:
                inliers_count = len(good_matches)

            # Strict Inlier filtering
            if inliers_count >= self.min_matches and (inliers_count / max(1, len(good_matches))) >= 0.35:
                norm_inliers = min(inliers_count / 35.0, 1.0)
                norm_good = min(len(good_matches) / 50.0, 1.0)
                score = round(float(0.70 * norm_inliers + 0.30 * norm_good), 4)

                candidates.append({
                    "code": landmark_code,
                    "confidence": score,
                    "inliers": inliers_count,
                    "good_matches": len(good_matches),
                    "raw_matches": len(raw_matches)
                })

        if not candidates:
            return {
                "status": "no_match",
                "message": "No deity recognized with sufficient feature alignment.",
                "matched_code": None,
                "confidence": 0.0,
                "is_matched": False
            }

        # Sort by inliers and confidence score
        candidates.sort(key=lambda c: (c["inliers"], c["confidence"]), reverse=True)
        top_match = candidates[0]

        # Margin check: Avoid false ambiguous matches between deities
        if len(candidates) > 1:
            runner_up = candidates[1]
            if top_match["inliers"] < (runner_up["inliers"] * 1.25) and (top_match["inliers"] - runner_up["inliers"]) < 5:
                return {
                    "status": "ambiguous_match",
                    "message": f"Ambiguous match between {top_match['code']} and {runner_up['code']}. Please scan again closer.",
                    "matched_code": None,
                    "confidence": 0.0,
                    "is_matched": False
                }

        final_conf = min(round(float(top_match["confidence"]), 2), 1.0)
        return {
            "status": "success",
            "matched_code": top_match["code"],
            "confidence": final_conf,
            "good_matches_count": top_match["good_matches"],
            "raw_matches_count": top_match["raw_matches"],
            "inliers_count": top_match["inliers"],
            "is_matched": True
        }
