"""Step 8b: download the embedding model and check that it works."""
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")

sentences = [
    "when is the midterm",
    "the exam is on monday",
    "good morning everyone",
]
embeddings = model.encode(sentences)

# each sentence becomes a vector of 384 numbers
print("shape:", embeddings.shape)

# similarity: the first two sentences (both about exams) should be closer
from sklearn.metrics.pairwise import cosine_similarity
sim = cosine_similarity(embeddings)
print("exam vs exam   :", round(float(sim[0][1]), 3))
print("exam vs greeting:", round(float(sim[0][2]), 3))