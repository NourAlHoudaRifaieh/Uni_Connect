"""Step 10: hybrid model = TF-IDF + sentence embeddings + question cues.

Reuses data/embeddings_cache.npz created by train_embeddings.py.
Same evaluations as before, so the results are comparable:
  A) 5-fold cross-validation split BY TEMPLATE
  B) The hand-written hard test set
"""
import re
import numpy as np
import pandas as pd
from scipy.sparse import csr_matrix, hstack
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.model_selection import StratifiedGroupKFold

LABELS = ["Exam", "Assignment", "Question", "Announcement", "General"]
EMB_WEIGHT = 1.0   # how much the embeddings count compared to TF-IDF
CUE_WEIGHT = 1.0   # how much the question cues count

pool = pd.read_csv("data/posts.csv")
hard = pd.read_csv("data/hard_test.csv")
cache = np.load("data/embeddings_cache.npz")
E_pool, E_hard = cache["pool"], cache["hard"]
y_pool, y_hard = pool["label"].to_numpy(), hard["label"].to_numpy()

START_WORDS = re.compile(
    r"^\s*(who|what|when|where|why|how|which|can|could|does|do|did|is|are|"
    r"should|will|would|anyone|anybody)\b", re.I)
SOMEONE = re.compile(r"\b(anyone|anybody|someone|somebody)\b", re.I)


def question_cues(texts):
    rows = [[1.0 if "?" in t else 0.0,
             1.0 if START_WORDS.search(t) else 0.0,
             1.0 if SOMEONE.search(t) else 0.0] for t in texts]
    return csr_matrix(np.array(rows))


def features(vectorizer, texts, embeddings, fit=False):
    tfidf = vectorizer.fit_transform(texts) if fit else vectorizer.transform(texts)
    return hstack([tfidf,
                   csr_matrix(embeddings * EMB_WEIGHT),
                   question_cues(texts) * CUE_WEIGHT]).tocsr()


def train_and_predict(train_texts, train_emb, train_y, test_texts, test_emb):
    vec = TfidfVectorizer(ngram_range=(1, 2), sublinear_tf=True, lowercase=True)
    X_train = features(vec, train_texts, train_emb, fit=True)
    X_test = features(vec, test_texts, test_emb)
    clf = LogisticRegression(max_iter=3000, C=5, class_weight="balanced")
    clf.fit(X_train, train_y)
    return clf.predict(X_test)


# A) cross-validation (each template fully in train OR test)
cv = StratifiedGroupKFold(n_splits=5, shuffle=True, random_state=0)
y_true, y_pred = [], []
texts = pool["text"].to_numpy()
for tr, te in cv.split(texts, y_pool, pool["group"]):
    y_pred += list(train_and_predict(texts[tr], E_pool[tr], y_pool[tr], texts[te], E_pool[te]))
    y_true += list(y_pool[te])
print("=== A) Cross-validation (unseen templates) ===")
print(classification_report(y_true, y_pred, digits=3))

# B) hard test set
pred = train_and_predict(texts, E_pool, y_pool, hard["text"].to_numpy(), E_hard)
print("=== B) Hard test set ===")
print(classification_report(y_hard, pred, digits=3))
print(pd.DataFrame(confusion_matrix(y_hard, pred, labels=LABELS),
                   index=LABELS, columns=LABELS))
print("\nMistakes on the hard set:")
for text, true, guess in zip(hard["text"], y_hard, pred):
    if true != guess:
        print(f"  [{true} -> {guess}] {text}")