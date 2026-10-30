"""Step 7: TF-IDF + Logistic Regression on the full dataset.

Two honest evaluations:
  A) 5-fold cross-validation split BY TEMPLATE (unseen templates)
  B) The hand-written hard test set (never used for training)
"""
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.model_selection import StratifiedGroupKFold
from sklearn.pipeline import make_pipeline

LABELS = ["Exam", "Assignment", "Question", "Announcement", "General"]

pool = pd.read_csv("data/posts.csv")
hard = pd.read_csv("data/hard_test.csv")


def build_model():
    return make_pipeline(
        TfidfVectorizer(ngram_range=(1, 2), sublinear_tf=True, lowercase=True),
        LogisticRegression(max_iter=2000, C=5, class_weight="balanced"),
    )


# A) cross-validation where each template stays entirely in train OR test
cv = StratifiedGroupKFold(n_splits=5, shuffle=True, random_state=0)
y_true, y_pred = [], []
for train_idx, test_idx in cv.split(pool, pool["label"], pool["group"]):
    model = build_model().fit(pool["text"].iloc[train_idx], pool["label"].iloc[train_idx])
    y_true += list(pool["label"].iloc[test_idx])
    y_pred += list(model.predict(pool["text"].iloc[test_idx]))
print("=== A) Cross-validation (unseen templates) ===")
print(classification_report(y_true, y_pred, digits=3))

# B) train on the whole pool, test on the hard set
model = build_model().fit(pool["text"], pool["label"])
pred = model.predict(hard["text"])
print("=== B) Hard test set ===")
print(classification_report(hard["label"], pred, digits=3))
print(pd.DataFrame(confusion_matrix(hard["label"], pred, labels=LABELS),
                   index=LABELS, columns=LABELS))

print("\nMistakes on the hard set:")
for text, true, guess in zip(hard["text"], hard["label"], pred):
    if true != guess:
        print(f"  [{true} -> {guess}] {text}")