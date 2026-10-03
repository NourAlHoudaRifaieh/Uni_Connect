
class GroupModel{
  final String? groupId;
  final String groupName;
  final String? academicYear;
  final int? membersCount;
  final int? postCount;
  final String? faculty;
  final String? department;
  final String? major;

  GroupModel({
    this.groupId,
    required this.groupName,
    this.academicYear,
    this.membersCount,
    this.faculty,
    this.department,
    this.major,
    this.postCount=0,
  });

  String get displayName {
    var base = groupName.trim();
    final trailingYear = RegExp(r'\s*[-\u2013(]*\s*year\s*\d+\s*\)?\s*$', caseSensitive: false);
    while (base.isNotEmpty && trailingYear.hasMatch(base)) {
      final next = base.replaceFirst(trailingYear, '').trim();
      if (next.isEmpty) break;
      base = next;
    }
    final y = (academicYear ?? '').trim();
    if (y.isEmpty) return base;
    final alreadyOnlyYear = base.toLowerCase() == y.toLowerCase();
    return alreadyOnlyYear ? base : '$base - $y';
  }

  // Add copyWith to duplicate existing instances with updated fields
  GroupModel copyWith({
    String? groupId,
    String? groupName,
    String? academicYear,
    int? membersCount,
    int? postCount,
    String? faculty,
    String? department,
    String? major,

  }) {
    return GroupModel(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      academicYear: academicYear ?? this.academicYear,
      membersCount: membersCount ?? this.membersCount,
      faculty: faculty ?? this.faculty,
      department: department ?? this.department,
      major: major ?? this.major,
      postCount: postCount ?? this.postCount,
    );
  }

  factory GroupModel.fromJson(Map<String, dynamic> json){
    return GroupModel(
        groupName: json['groupName'] ?? '',
        groupId: json['groupId'] ?? '',
        academicYear: json['academicYear'] ?? '',
        membersCount: json['membersCount'] ?? 0,
        postCount: json['postCount'] ?? 0,
        faculty: json['faculty'],
        department: json['department'],
        major: json['major'],
    );
  }

  factory GroupModel.fromFirestore(Map<String, dynamic> data, String id){
    return GroupModel(
      groupId: id,
      groupName: data['groupName'] ?? '',
      membersCount: data['membersCount'] ?? 0,
      postCount: data['postCount'] ?? 0,
      academicYear: data['academicYear'] ?? '',
      faculty: data['faculty'],
      department: data['department'],
      major: data['major'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if(groupId != null) 'groupId': groupId,
      if(faculty != null) 'faculty': faculty,
      if(major != null) 'major': major,
      if(department != null) 'department': department,
      'groupName': groupName,
      'academicYear': academicYear,
      if(membersCount != null) 'membersCount': membersCount,
    };
  }

}