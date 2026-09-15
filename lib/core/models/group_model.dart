
class GroupModel{
  final String? groupId;
  final String groupName;
  final String? userId;// foreign key
  final String? subjectId; //foreign key
  final String? academicYear; //-> need to use it from the user model
  final int membersCount;

  GroupModel({
    this.groupId,
    required this.groupName,
    this.userId,
    this.subjectId,
    this.academicYear,
    required this.membersCount,
  });

  // Add copyWith to duplicate existing instances with updated fields
  GroupModel copyWith({
    String? groupId,
    String? groupName,
    String? userId,
    String? subjectId,
    String? academicYear,
    int? membersCount,
  }) {
    return GroupModel(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      academicYear: academicYear ?? this.academicYear,
      membersCount: membersCount ?? this.membersCount,
    );
  }

  factory GroupModel.fromJson(Map<String, dynamic> json){
    return GroupModel(
        groupName: json['groupName'] ?? '',
        groupId: json['groupId'] ?? '',
        userId: json['userId'] ?? '',
        subjectId: json['subjectId'] ?? '',
        academicYear: json['academicYear'] ?? '',
        membersCount: json['membersCount'] ?? 0,
    );
  }

  factory GroupModel.fromFirestore(Map<String, dynamic> data, String id){
    return GroupModel(
      groupId: id,
      groupName: data['groupName'] ?? '',
      subjectId: data['subjectId'] ?? '',
      membersCount: data['membersCount'] ?? 0,
      academicYear: data['academicYear'] ?? '',
      userId: data['userId'] ,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if(groupId != null) 'groupId': groupId,
      'groupName': groupName,
      if(userId != null) 'userId': userId,
      'subjectId': subjectId,
      'academicYear': academicYear,
      'membersCount': membersCount,
    };
  }

}