from fastapi import FastAPI, File, UploadFile, Form, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from matcher import ImageMatcher
import uvicorn
import os

app = FastAPI(
    title="Landmark OpenCV Recognition Service",
    description="Extracts visual features using OpenCV ORB and matches against reference landmarks",
    version="1.0.0"
)

# Enable CORS for internal backend service communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Matcher engine with Pure Cloudinary In-Memory loading
REFERENCE_DIR = os.getenv("REFERENCE_DIR", "reference_images")
matcher = ImageMatcher(reference_dir=REFERENCE_DIR, min_matches=8)

@app.get("/")
def root():
    return {
        "service": "OpenCV Recognition Service",
        "status": "online",
        "endpoints": {
            "recognize": "POST /recognize",
            "register": "POST /register-reference",
            "references": "GET /references",
            "health": "GET /health"
        }
    }

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "loaded_landmarks_count": len(matcher.reference_db)
    }

@app.get("/references")
def get_references():
    return {
        "count": len(matcher.reference_db),
        "landmarks": list(matcher.reference_db.keys())
    }

@app.post("/recognize")
async def recognize_image(file: UploadFile = File(...)):
    """
    Accepts an image file from Express backend, performs feature matching,
    and returns matched landmark code & confidence score.
    """
    try:
        image_bytes = await file.read()
        if not image_bytes or len(image_bytes) == 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Empty image received"
            )
        result = matcher.match_image(image_bytes)
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Recognition error: {str(e)}"
        )

@app.post("/register-reference")
async def register_reference(
    landmark_code: str = Form(...),
    file: UploadFile = File(...)
):
    """
    Register a reference photo for a landmark code into the OpenCV feature database.
    Called when an admin uploads a new landmark photo.
    """
    if not landmark_code or len(landmark_code.strip()) == 0:
        raise HTTPException(status_code=400, detail="Landmark code is required")

    try:
        image_bytes = await file.read()
        success = matcher.register_reference(landmark_code.strip(), image_bytes)
        if not success:
            raise HTTPException(status_code=400, detail="Unable to extract valid visual features from reference image")

        return {
            "status": "registered",
            "landmark_code": landmark_code.strip(),
            "message": f"Successfully indexed features for {landmark_code}"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/reload")
def reload_references():
    """Reload all reference landmarks from disk."""
    matcher.load_all_references()
    return {
        "status": "reloaded",
        "loaded_landmarks_count": len(matcher.reference_db)
    }

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=True)

