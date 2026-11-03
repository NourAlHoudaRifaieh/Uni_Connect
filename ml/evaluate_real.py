"""Step 11: compare the three models on posts that were NEVER used for training
or tuning (data/real_test.csv).

Run from the ml folder:  python evaluate_real.py
"""
import re
import numpy as np
import pandas as pd
from scipy.sparse import csr_matrix, hstack
from sentence_transformers import SentenceTransformer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report

pool = pd.read_csv("data/posts.csv")
real = pd.read_csv("data/real_test.csv")
E_pool = np.load("data/embeddings_cache.npz")["pool"]
encoder = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
E_real = encoder.encode(real["text"].tolist())

START = re.compile(r"^\s*(who|what|when|where|why|how|which|can|could|does|do|did|is|are|"
                   r"should|will|would|anyone|anybody)\b", re.I)
SOMEONE = re.compile(r"\b(anyone|anybody|someone|somebody)\b", re.I)


def cues(texts):
    return csr_matrix(np.array([[1.0 if "?" in t else 0.0,
                                 1.0 if START.search(t) else 0.0,
                                 1.0 if SOMEONE.search(t) else 0.0] for t in texts]))


def clf(C):
    return LogisticRegression(max_iter=3000, C=C, class_weight="balanced")


def fit_predict(kind):
    tr_t, te_t = pool["text"], real["text"]
    y = pool["label"]
    if kind == "embeddings":
        return clf(10).fit(E_pool, y).predict(E_real)
    vec = TfidfVectorizer(ngram_range=(1, 2), sublinear_tf=True, lowercase=True)
    A, B = vec.fit_transform(tr_t), vec.transform(te_t)
    if kind == "tfidf":
        return clf(5).fit(A, y).predict(B)
    A = hstack([A, csr_matrix(E_pool), cues(tr_t)]).tocsr()
    B = hstack([B, csr_matrix(E_real), cues(te_t)]).tocsr()
    return clf(5).fit(A, y).predict(B)


results = {k: fit_predict(k) for k in ["tfidf", "embeddings", "hybrid"]}
print("Accuracy on data/real_test.csv (%d posts):" % len(real))
for name, pred in results.items():
    print(f"  {name:<11} {accuracy_score(real['label'], pred):.1%}")

best = max(results, key=lambda k: accuracy_score(real["label"], results[k]))
print(f"\nBest on this set: {best}\n")
print(classification_report(real["label"], results[best], digits=2))
print("Mistakes (all three models):")
for i, (t, y) in enumerate(zip(real["text"], real["label"])):
    guesses = {k: results[k][i] for k in results}
    if any(g != y for g in guesses.values()):
        print(f"  [{y}] {t}")
        print("      " + "  ".join(f"{k}={g}" for k, g in guesses.items()))