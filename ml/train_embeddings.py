"""Step 9: sentence embeddings (all-MiniLM-L6-v2) + Logistic Regression.

Same two honest evaluations as train_tfidf.py, so the results are comparable:
  A) 5-fold cross-validation split BY TEMPLATE (unseen templates)
  B) The hand-written hard test set (never used for training)

Embeddings are computed once and cached in data/embeddings_cache.npz.
"""
import os
import numpy as np
import pandas as pd
from sentence_transformers import SentenceTransformer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.model_selection import StratifiedGroupKFold

LABELS = ["Exam", "Assignment", "Question", "Announcement", "General"]
MODEL_NAME = "sentence-transformers/all-MiniLM-L6-v2"
CACHE = "data/embeddings_cache.npz"

pool = pd.read_csv("data/posts.csv")
hard = pd.read_csv("data/hard_test.csv")

# 1) Turn every text into a 384-number vector (cached after the first run)
if os.path.exists(CACHE):
    cache = np.load(CACHE)
    X_pool, X_hard = cache["pool"], cache["hard"]
else:
    encoder = SentenceTransformer(MODEL_NAME)
    X_pool = encoder.encode(pool["text"].tolist(), batch_size=64, show_progress_bar=True)
    X_hard = encoder.encode(hard["text"].tolist(), batch_size=64)
    np.savez(CACHE, pool=X_pool, hard=X_hard)

y_pool = pool["label"].to_numpy()
y_hard = hard["label"].to_numpy()


def build_model():
    return LogisticRegression(max_iter=3000, C=10, class_weight="balanced")


# A) cross-validation where each template stays entirely in train OR test
cv = StratifiedGroupKFold(n_splits=5, shuffle=True, random_state=0)
y_true, y_pred = [], []
for train_idx, test_idx in cv.split(X_pool, y_pool, pool["group"]):
    model = build_model().fit(X_pool[train_idx], y_pool[train_idx])
    y_true += list(y_pool[test_idx])
    y_pred += list(model.predict(X_pool[test_idx]))
print("=== A) Cross-validation (unseen templates) ===")
print(classification_report(y_true, y_pred, digits=3))

# B) train on the whole pool, test on the hard set
model = build_model().fit(X_pool, y_pool)
pred = model.predict(X_hard)
print("=== B) Hard test set ===")
print(classification_report(y_hard, pred, digits=3))
print(pd.DataFrame(confusion_matrix(y_hard, pred, labels=LABELS),
                   index=LABELS, columns=LABELS))

print("\nMistakes on the hard set:")
for text, true, guess in zip(hard["text"], y_hard, pred):
    if true != guess:
        print(f"  [{true} -> {guess}] {text}")