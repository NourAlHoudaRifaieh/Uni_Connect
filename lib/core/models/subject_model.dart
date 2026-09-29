
class SubjectModel{
  final String? subjectId;
  final String subjectCode;
  final String subjectName;
  final String? academicYear;
  final String groupId;
  final int postCount;

  SubjectModel({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    this.academicYear,
    required this.groupId,
    required this.postCount,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json){
    return SubjectModel(
        subjectId: json['subjectId'] ?? '',
        subjectCode: json['subjectCode'] ?? '',
        subjectName: json['subjectName'] ?? '',
        academicYear: json['academicYear'] ?? '',
        groupId: json['groupId'] ?? '',
        postCount: json['postCount'] ?? 0,
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
    };
  }

  SubjectModel copyWith({
    String? subjectId,
    String? subjectCode,
    String? subjectName,
    String? academicYear,
    String? groupId,
    int? postCount,
  }) {
    return SubjectModel(
      subjectId: subjectId ?? this.subjectId,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectName: subjectName ?? this.subjectName,
      academicYear: academicYear ?? this.academicYear,
      groupId: groupId ?? this.groupId,
      postCount: postCount ?? this.postCount,
    );
  }

}