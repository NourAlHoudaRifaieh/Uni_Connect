import os
import sys

import firebase_admin
from firebase_admin import auth, credentials, firestore
from google.cloud import firestore as gcf

ADMIN_EMAIL = os.environ.get("ADMIN_EMAIL", "").strip().lower()
ADMIN_PASSWORD = os.environ.get("ADMIN_PASSWORD", "")
ADMIN_NAME = os.environ.get("ADMIN_NAME", "Nour Rifaieh")

if not ADMIN_EMAIL or len(ADMIN_PASSWORD) < 10:
    sys.exit("Set ADMIN_EMAIL and ADMIN_PASSWORD (min 10 chars) first.")

firebase_admin.initialize_app(credentials.ApplicationDefault())
db = firestore.client()


@gcf.transactional
def next_user_id(transaction, counter_ref):
    """Same counter the app uses (counters/users), so IDs never clash."""
    snap = counter_ref.get(transaction=transaction)
    current = 0
    if snap.exists and isinstance(snap.get("value"), (int, float)):
        current = int(snap.get("value"))
    nxt = current + 1
    transaction.set(counter_ref, {"value": nxt, "prefix": "user_"}, merge=True)
    return f"user_{nxt}"


# 1. Auth account: reuse it if it exists, otherwise create it.
try:
    user = auth.get_user_by_email(ADMIN_EMAIL)
    print(f"Auth user already exists: {user.uid}")
except auth.UserNotFoundError:
    user = auth.create_user(
        email=ADMIN_EMAIL,
        password=ADMIN_PASSWORD,
        display_name=ADMIN_NAME,
        email_verified=True,
    )
    print(f"Created Auth user: {user.uid}")

# 2. Admin claim (checked by Firestore rules in step 3).
auth.set_custom_user_claims(user.uid, {"admin": True})

# 3. Firestore profile using the app's user_N ID format.
from google.cloud.firestore_v1.base_query import FieldFilter

existing = list(
    db.collection("users")
    .where(filter=FieldFilter("email", "==", ADMIN_EMAIL))
    .limit(1)
    .stream()
)
if existing and existing[0].id.startswith("user_"):
    doc_id = existing[0].id
    print(f"Reusing existing user_ profile: {doc_id}")
else:
    doc_id = next_user_id(db.transaction(), db.collection("counters").document("users"))
    print(f"New profile ID: {doc_id}")

db.collection("users").document(doc_id).set(
    {
        "userId": doc_id,
        "fullName": ADMIN_NAME,
        "email": ADMIN_EMAIL,
        "role": "admin",
        "faculty": "Faculty of Economics and Business Administration",
        "createdAt": firestore.SERVER_TIMESTAMP,
    },
    merge=True,
)

# 4. Delete the leftover UID-based profile, if it exists.
uid_doc = db.collection("users").document(user.uid)
if user.uid != doc_id and uid_doc.get().exists:
    uid_doc.delete()
    print(f"Deleted old UID-based profile: {user.uid}")

print(f"Admin is ready. Profile: users/{doc_id}, claim admin=True")