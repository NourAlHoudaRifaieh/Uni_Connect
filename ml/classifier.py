"""Reusable hybrid post classifier (TF-IDF + sentence embeddings + question cues).

Used by train_final.py (to train and save) and later by the backend (to predict).
"""
import re

import numpy as np
from scipy.sparse import csr_matrix, hstack
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

ENCODER_NAME = "sentence-transformers/all-MiniLM-L6-v2"

_START = re.compile(
    r"^\s*(who|what|when|where|why|how|which|can|could|does|do|did|is|are|"
    r"should|will|would|anyone|anybody)\b", re.I)
_SOMEONE = re.compile(r"\b(anyone|anybody|someone|somebody)\b", re.I)


def _cues(texts):
    """Three simple signals that help recognise questions."""
    return csr_matrix(np.array([[1.0 if "?" in t else 0.0,
                                 1.0 if _START.search(t) else 0.0,
                                 1.0 if _SOMEONE.search(t) else 0.0] for t in texts]))


class HybridClassifier:
    def __init__(self, C=5):
        self.C = C
        self.vectorizer = TfidfVectorizer(ngram_range=(1, 2), sublinear_tf=True, lowercase=True)
        self.model = LogisticRegression(max_iter=3000, C=C, class_weight="balanced")
        self._encoder = None  # loaded lazily, never saved inside the model file

    # -- embeddings -------------------------------------------------------
    def _embed(self, texts):
        if self._encoder is None:
            from sentence_transformers import SentenceTransformer
            self._encoder = SentenceTransformer(ENCODER_NAME)
        return self._encoder.encode(list(texts), batch_size=64)

    def _features(self, texts, fit=False):
        tfidf = self.vectorizer.fit_transform(texts) if fit else self.vectorizer.transform(texts)
        return hstack([tfidf, csr_matrix(self._embed(texts)), _cues(texts)]).tocsr()

    # -- public API -------------------------------------------------------
    def fit(self, texts, labels):
        texts = list(texts)
        self.model.fit(self._features(texts, fit=True), labels)
        return self

    def predict_with_confidence(self, text):
        """Returns (label, confidence between 0 and 1)."""
        proba = self.model.predict_proba(self._features([text]))[0]
        best = int(np.argmax(proba))
        return self.model.classes_[best], float(proba[best])

    def __getstate__(self):
        state = self.__dict__.copy()
        state["_encoder"] = None
        return state