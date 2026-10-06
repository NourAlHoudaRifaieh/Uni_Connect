"""UniConnect - AI post categorization backend (Python + Google Gemini)."""
import os
from typing import Optional

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

CATEGORIES = ["Exam", "Assignment", "Question", "Summary", "Announcement", "General"]

# Models are tried in this order until one answers. GEMINI_MODEL (env) goes first.
MODEL_CANDIDATES = [
    m for m in [
        os.environ.get("GEMINI_MODEL", "").strip(),
        "gemini-3.1-flash-lite",
        "gemini-2.5-flash",
        "gemini-flash-latest",
    ] if m
]

app = FastAPI(title="UniConnect AI Categorizer")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

_client = None
_active_model = None
_api_key = os.environ.get("GEMINI_API_KEY", "").strip()
if _api_key:
    try:
        from google import genai

        _client = genai.Client(api_key=_api_key)
        print(f"[ai] Gemini client ready, candidates={MODEL_CANDIDATES}")
    except Exception as exc:
        print(f"[ai] Could not initialise Gemini: {exc}")
else:
    print("[ai] GEMINI_API_KEY not set - using the keyword fallback only")


class PostRequest(BaseModel):
    description: str


class CategoryResponse(BaseModel):
    category: str
    source: str                    # "gemini" | "fallback"
    model: Optional[str] = None    # which LLM answered (None for fallback)


PROMPT = """You are a classifier for a university students' forum.
Classify the post below into exactly ONE of these categories:
{categories}

Rules:
- Answer with the category name only, nothing else.
- The post may be written in English, Arabic or a mix of both.
- If none of them fits well, answer "General".

Post:
\"\"\"{description}\"\"\"
"""


def _normalize(raw: str) -> str:
    text = (raw or "").strip().strip(".").lower()
    for category in CATEGORIES:
        if category.lower() == text:
            return category
    for category in CATEGORIES:
        if category.lower() in text:
            return category
    return "General"


def _fallback(text: str) -> str:
    t = text.lower()

    def has(*keys: str) -> bool:
        return any(k in t for k in keys)

    if has("exam", "midterm", "final", "quiz"):
        return "Exam"
    if has("assignment", "homework", "due", "submit", "deadline"):
        return "Assignment"
    if has("summary", "summarize", "notes"):
        return "Summary"
    if has("announce", "announcement", "reminder"):
        return "Announcement"
    if "?" in t or "؟" in t:
        return "Question"
    return "General"


@app.get("/health")
def health():
    return {
        "status": "ok",
        "ai_enabled": _client is not None,
        "active_model": _active_model,
        "model_candidates": MODEL_CANDIDATES,
    }


@app.post("/categorize", response_model=CategoryResponse)
def categorize(req: PostRequest):
    global _active_model
    text = (req.description or "").strip()
    if not text:
        return CategoryResponse(category="General", source="fallback", model=None)

    if _client is not None:
        prompt = PROMPT.format(categories=", ".join(CATEGORIES), description=text)
        order = ([_active_model] if _active_model else []) + [
            m for m in MODEL_CANDIDATES if m != _active_model
        ]
        for model in order:
            try:
                response = _client.models.generate_content(model=model, contents=prompt)
                _active_model = model
                return CategoryResponse(
                    category=_normalize(getattr(response, "text", "") or ""),
                    source="gemini",
                    model=model,
                )
            except Exception as exc:
                print(f"[ai] model {model} failed: {exc}")

    return CategoryResponse(category=_fallback(text), source="fallback", model=None)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)