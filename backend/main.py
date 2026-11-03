"""UniConnect - post categorization backend.

Uses our own trained model (model.joblib: TF-IDF + sentence embeddings + question
cues). No external LLM and no API key are needed.

Run:  uvicorn main:app --host 0.0.0.0 --port 8000
"""
import os
from typing import Optional

import joblib
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

import classifier  # noqa: F401  (joblib needs this module to rebuild the model)

CATEGORIES = ["Exam", "Assignment", "Question", "Announcement", "General"]
MODEL_PATH = os.environ.get(
    "MODEL_PATH", os.path.join(os.path.dirname(os.path.abspath(__file__)), "model.joblib"))
# Below this confidence we answer "General" instead of guessing.
MIN_CONFIDENCE = float(os.environ.get("MIN_CONFIDENCE", "0.40"))
MODEL_NAME = "hybrid-tfidf-minilm"

app = FastAPI(title="UniConnect Post Categorizer")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

_model = None
try:
    _model = joblib.load(MODEL_PATH)
    print(f"[ml] model loaded from {MODEL_PATH}")
except Exception as exc:
    print(f"[ml] could not load the model ({exc}) - using the keyword fallback only")


class PostRequest(BaseModel):
    description: str


class CategoryResponse(BaseModel):
    category: str
    source: str                          # "model" | "fallback"
    model: Optional[str] = None          # model name (None for fallback)
    confidence: Optional[float] = None   # 0..1 (None for fallback)


def _fallback(text: str) -> str:
    t = text.lower()

    def has(*keys: str) -> bool:
        return any(k in t for k in keys)

    if has("exam", "midterm", "final", "quiz"):
        return "Exam"
    if has("assignment", "homework", "due", "submit", "deadline"):
        return "Assignment"
    if has("announce", "announcement", "reminder", "cancelled", "canceled"):
        return "Announcement"
    if "?" in t:
        return "Question"
    return "General"


@app.get("/health")
def health():
    return {
        "status": "ok",
        "model_loaded": _model is not None,
        "model": MODEL_NAME if _model is not None else None,
        "min_confidence": MIN_CONFIDENCE,
        "categories": CATEGORIES,
    }


@app.post("/categorize", response_model=CategoryResponse)
def categorize(req: PostRequest):
    text = (req.description or "").strip()
    if not text:
        return CategoryResponse(category="General", source="fallback")

    if _model is not None:
        try:
            label, confidence = _model.predict_with_confidence(text)
            if confidence < MIN_CONFIDENCE:
                label = "General"
            return CategoryResponse(
                category=str(label), source="model",
                model=MODEL_NAME, confidence=round(confidence, 3))
        except Exception as exc:
            print(f"[ml] prediction failed: {exc}")

    return CategoryResponse(category=_fallback(text), source="fallback")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)