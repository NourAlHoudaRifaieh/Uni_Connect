
class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String role; // 'student' or 'admin'
  final String? faculty;
  final String? department;
  final String? academicYear;
  final String? major;
  final int postCount;
  final String? groupId;
  final List<String> extraSubjectIds;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
    this.faculty,
    this.academicYear,
    this.department,
    this.major,
    this.postCount=0,
    this.groupId,
    this.extraSubjectIds = const [],
  });

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? role,
    String? faculty,
    String? academicYear,
    String? department,
    String? major,
    int? postCount,
    List<String>? extraSubjectIds,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      // faculty: faculty ?? this.faculty,
      academicYear: academicYear ?? this.academicYear,
      department: department ?? this.department,
      major: major ?? this.major,
      postCount: postCount ?? this.postCount,
      groupId: groupId,
      extraSubjectIds: extraSubjectIds ?? this.extraSubjectIds,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isStudent => role == 'student';

  String get authorInitials{
    final parts = fullName.trim().split(' ');
    if(parts.length >=2){
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }else if(parts.isNotEmpty && parts[0].isNotEmpty){
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  factory UserModel.fromJson(Map<String, dynamic>json){
    return UserModel(
        userId: json['userId'] ?? '',
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'student',
        faculty:json['faculty'],
        academicYear:json['academicYear'],
        department:json['department'],
        major: json['major'],
        groupId: json['groupId'],
        postCount:json['postCount'] ?? 0,
        extraSubjectIds: List<String>.from(json['extraSubjectIds'] ?? const []),
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id){
    return UserModel(
        userId: id,
        fullName: data['fullName'] ?? '',
        email: data['email'] ?? '',
        role: data['role'] ?? 'student',
        faculty: data['faculty'],
        academicYear: data['academicYear'],
        department: data['department'],
        major: data['major'],
        groupId: data['groupId'],
        postCount: data['postCount'] ?? 0,
       extraSubjectIds: List<String>.from(data['extraSubjectIds'] ?? const []),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'userId':userId,
      'fullName': fullName,
      'email': email,
      'role': role,
      if(faculty !=null) 'faculty': faculty,
      if(academicYear !=null) 'academicYear': academicYear,
      if(department !=null) 'department': department,
      if(groupId !=null) 'groupId': groupId,
      if(major !=null) 'major':major,
      'postCount': postCount,
    };
  }

}