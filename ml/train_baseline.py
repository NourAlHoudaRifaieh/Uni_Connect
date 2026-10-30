"""Step 5: first baseline classifier (TF-IDF + Logistic Regression).

Reads data/my_posts.csv, estimates accuracy with 5-fold cross-validation,
then trains on ALL rows and tries a few new sentences.
"""
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import StratifiedKFold, cross_val_predict
from sklearn.metrics import classification_report
from sklearn.pipeline import make_pipeline

# 1) Load the data
df = pd.read_csv("data/my_posts.csv")
X = df["text"]
y = df["label"]

# 2) Build the model: text -> TF-IDF numbers -> Logistic Regression
model = make_pipeline(
    TfidfVectorizer(ngram_range=(1, 2), lowercase=True),
    LogisticRegression(max_iter=2000),
)

# 3) Estimate accuracy on data the model did not train on (5-fold CV)
cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
predicted = cross_val_predict(model, X, y, cv=cv)
print(classification_report(y, predicted, digits=2))

# 4) Train on everything and try new sentences
model.fit(X, y)
tests = [
    "midterm for marketing is on monday",
    "when is the finance quiz",
    "homework 5 is due friday",
    "the lecture is cancelled today",
    "hello everyone, good luck",
]
for t in tests:
    print(f"{model.predict([t])[0]:<13} <- {t}")