
class SubjectModel{
  final String? subjectId;
  final String subjectCode;
  final String subjectName;
  final String? academicYear;
  final String groupId;
  final int postCount;
  final List<String> sharedGroupIds;

  SubjectModel({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    this.academicYear,
    required this.groupId,
    required this.postCount,
    this.sharedGroupIds = const [],
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json){
    return SubjectModel(
        subjectId: json['subjectId'] ?? '',
        subjectCode: json['subjectCode'] ?? '',
        subjectName: json['subjectName'] ?? '',
        academicYear: json['academicYear'] ?? '',
        groupId: json['groupId'] ?? '',
        postCount: json['postCount'] ?? 0,
        sharedGroupIds: List<String>.from(json['sharedGroupIds'] ?? const []),
    );
  }

  //For firestore
  factory SubjectModel.fromFirestore(Map<String, dynamic> data, String id){
    return SubjectModel(
      subjectId:  id,
      subjectCode: data['subjectCode'] ?? '',
      subjectName: data['subjectName'] ?? '',
      academicYear: data['academicYear'] ?? '',
      groupId: data['groupId'] ?? '',
      postCount: data['postCount'] ?? 0,
      sharedGroupIds: List<String>.from(data['sharedGroupIds'] ?? const []),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if (subjectId != null ) 'subjectId': subjectId,
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      'groupId': groupId,
      if(academicYear != null) 'academicYear': academicYear,
      'postCount': postCount,
      'sharedGroupIds': sharedGroupIds,
    };
  }

  SubjectModel copyWith({
    String? subjectId,
    String? subjectCode,
    String? subjectName,
    String? academicYear,
    String? groupId,
    int? postCount,
    List<String>? sharedGroupIds,
  }) {
    return SubjectModel(
      subjectId: subjectId ?? this.subjectId,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectName: subjectName ?? this.subjectName,
      academicYear: academicYear ?? this.academicYear,
      groupId: groupId ?? this.groupId,
      postCount: postCount ?? this.postCount,
      sharedGroupIds: sharedGroupIds ?? this.sharedGroupIds,
    );
  }

  //true when this subject is shown to the given group  like my own group or shared one
  bool belongsToGroup(String? gid) {
    return gid != null && gid.isNotEmpty &&(groupId == gid || sharedGroupIds.contains(gid));
  }

}