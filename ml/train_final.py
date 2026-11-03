"""Step 12: train the final hybrid model on ALL labeled data and save it.

Output: model.joblib  (the backend will load this file)
Run from the ml folder:  python train_final.py
"""
import joblib
import pandas as pd

from classifier import HybridClassifier

frames = [pd.read_csv(p) for p in
          ["data/posts.csv", "data/hard_test.csv", "data/real_test.csv"]]
data = pd.concat([f[["text", "label"]] for f in frames], ignore_index=True)
data = data.drop_duplicates("text")
print("Training on", len(data), "posts")
print(data["label"].value_counts().to_string(), "\n")

clf = HybridClassifier().fit(data["text"], data["label"])
joblib.dump(clf, "model.joblib")
print("Saved model.joblib\n")

# quick demo
loaded = joblib.load("model.joblib")
for text in [
    "when is the finance midterm",
    "the marketing project is due on friday",
    "tomorrow's class is cancelled",
    "the stats exam covers chapters 1 to 4",
    "good morning everyone",
    "anyone has the accounting slides",
]:
    label, conf = loaded.predict_with_confidence(text)
    print(f"{label:<13} {conf:.2f}  <- {text}")
