
class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String role; // 'student' or 'admin'
  final String? faculty;
  final String? academicYear;
  final String? major;
  final int postCount;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
    this.faculty,
    this.academicYear,
    this.major,
    this.postCount=0,
  });

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? role,
    String? faculty,
    String? academicYear,
    String? major,
    int? postCount,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      faculty: faculty ?? this.faculty,
      academicYear: academicYear ?? this.academicYear,
      major: major ?? this.major,
      postCount: postCount ?? this.postCount,
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
        major: json['major'],
        postCount:json['postCount'] ?? 0,
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
        major: data['major'],
        postCount: data['postCount'] ?? 0,
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
      if(major !=null) 'major':major,
      'postCount': postCount,
    };
  }

}