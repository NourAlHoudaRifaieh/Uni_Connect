import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_connect/core/models/subject_model.dart';

class SubjectRepository {
  final _firestore = FirebaseFirestore.instance;

  // students: watch subjects for their specific academic year
  // Stream means the UI updates automatically if admin adds/edits/deletes a subject
  Stream<List<SubjectModel>> watchSubjects({required String academicYear}) {
    return _firestore
        .collection('subjects')
        .where('academicYear', isEqualTo: academicYear)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => SubjectModel.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // admin: watch every subject across all years, for the admin dashboard
  Stream<List<SubjectModel>> watchAllSubjects() {
    return _firestore
        .collection('subjects')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => SubjectModel.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<List<SubjectModel>> getSubjects() async {
    final snapshot = await _firestore.collection('subjects').get();
    return snapshot.docs
        .map((doc) => SubjectModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // admin: create a new subject
  Future<void> createSubject(SubjectModel subject) async {
    await _firestore.collection('subjects').add(subject.toJson());
  }

  // admin: update an existing subject
  Future<void> updateSubject(SubjectModel subject) async {
    if (subject.subjectId == null) return;
    await _firestore
        .collection('subjects')
        .doc(subject.subjectId)
        .update(subject.toJson());
  }

  // admin: delete a subject
  Future<void> deleteSubject(String subjectId) async {
    await _firestore.collection('subjects').doc(subjectId).delete();
  }

  // called whenever a new post is created under this subject
  // keeps postCount accurate without needing to recalculate it by counting posts every time
  Future<void> incrementPostCount(String subjectId) async {
    await _firestore.collection('subjects').doc(subjectId).update({
      'postCount': FieldValue.increment(1),
    });
  }

  //called whenever  a post is deleted under this subject
  Future<void> decrementPostCount(String subjectId) async{
    await _firestore.collection('subjects').doc(subjectId).update({
      'postCount': FieldValue.increment(-1),
    });
  }
}