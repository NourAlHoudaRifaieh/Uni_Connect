import 'package:uni_connect/core/models/post_model.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/subject_request_repository.dart';

/// Decides what a student can see, based on SUBJECTS (not only on the group id).
/// A student sees a subject when it belongs to his group (own or shared/common)
/// or when the admin accepted his "See Another Subject" request.
class FeedAccess {
  static Set<String> subjectIdsFor(UserModel? user, List<SubjectModel> subjects) {
    if (user == null) return {};
    final locked = isLockedYear(user.academicYear);
    final ids = <String>{};
    for (final s in subjects) {
      if (s.subjectId == null || s.subjectId!.isEmpty) continue;
      if (s.belongsToGroup(user.groupId)) ids.add(s.subjectId!);
      if (!locked && user.extraSubjectIds.contains(s.subjectId)) ids.add(s.subjectId!);
    }
    return ids;
  }

  /// A post is visible when it is in the student's group, belongs to one of the
  /// student's subjects, or was written by the student himself.
  static bool canSee(PostModel p, UserModel user, Set<String> mySubjectIds) {
    if (p.userId != null && p.userId == user.userId) return true;
    if (p.subjectId != null && mySubjectIds.contains(p.subjectId)) return true;
    return user.groupId != null && user.groupId!.isNotEmpty && p.groupId == user.groupId;
  }

  /// Students visible in Search: same group OR sharing at least one subject.
  static bool sharesSpace(UserModel me, UserModel other, Set<String> mySubjectIds, List<SubjectModel> subjects) {
    if (other.role == 'admin') return false;
    if (me.groupId != null && me.groupId!.isNotEmpty && other.groupId == me.groupId) return true;
    final theirs = subjectIdsFor(other, subjects);
    return theirs.any(mySubjectIds.contains);
  }
}
