import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/utils/sequential_id_service.dart';

class SubjectRepository {
  final _firestore = FirebaseFirestore.instance;
  final SequentialIdService _ids = SequentialIdService();

  String _generateSubjectId(String subjectName) {
    String cleanName = subjectName.trim().replaceAll(' ', '').toUpperCase();
    String prefix = cleanName.length >= 3 ? cleanName.substring(0, 3) : cleanName.padRight(3, 'X');
    int randomNum = Random().nextInt(900) + 100;
    return '$prefix$randomNum';
  }

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

  Future<String?> duplicateError(SubjectModel subject) async {
    final snap = await _firestore
        .collection('subjects')
        .where('academicYear', isEqualTo: subject.academicYear)
        .get();
    final name = subject.subjectName.trim().toLowerCase();
    final mine = <String>{subject.groupId, ...subject.sharedGroupIds};
    for (final d in snap.docs) {
      final other = SubjectModel.fromFirestore(d.data(), d.id);
      if (other.subjectName.trim().toLowerCase() != name) continue;
      final theirs = <String>{other.groupId, ...other.sharedGroupIds};
      if (theirs.intersection(mine).isNotEmpty) {
        return '"${subject.subjectName.trim()}" already exists in ${subject.academicYear} for one of the selected specializations.';
      }
    }
    return null;
  }

  // admin: create a new subject
  Future<void> createSubject(SubjectModel subject) async {
    final dup = await duplicateError(subject);
    if(dup != null) throw Exception(dup);
    final generatedCode = _generateSubjectId(subject.subjectName ?? 'SUB');

    // subject_1, subject_2
    final sequentialSubjectId = await _ids.nextId('subjects', 'subject_');
    final docRef = _firestore.collection('subjects').doc(sequentialSubjectId);

    final subjectData = subject.toJson();
    subjectData['subjectId'] = sequentialSubjectId; // subj_1
    subjectData['subjectCode'] = generatedCode; // INF387

    await docRef.set(subjectData);
  }

  // admin: update an existing subject
  Future<void> updateSubject(SubjectModel subject) async {
    if (subject.subjectId == null) return;
    await _firestore
        .collection('subjects')
        .doc(subject.subjectId)
        .update(subject.toJson());
  }

  Future<String?> subjectDeletionBlocker(SubjectModel subject) async {
    final id = subject.subjectId;
    if (id == null || id.isEmpty) return 'This subject cannot be deleted.';

    Query query = _firestore
        .collection('users')
        .where('groupId', isEqualTo: subject.groupId);
    if (subject.academicYear != null && subject.academicYear!.isNotEmpty) {
      query = query.where('academicYear', isEqualTo: subject.academicYear);
    }

    final students = await query.limit(1).get();
    if (students.docs.isNotEmpty) {
      return 'Cannot delete "${subject.subjectName}": students in the same specialty and year still exist.';
    }
    final posts = await _firestore
        .collection('posts')
        .where('subjectId', isEqualTo: id)
        .limit(1)
        .get();
    if (posts.docs.isNotEmpty) {
      return 'Cannot delete "${subject.subjectName}": it still has posts.';
    }
    return null;
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