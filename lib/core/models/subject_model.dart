
class SubjectModel{
  final String? subjectId;
  final String subjectCode;
  final String subjectName;
  final String? academicYear;
  final int postCount;

  SubjectModel({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    this.academicYear,
    required this.postCount,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json){
    return SubjectModel(
        subjectId: json['subjectId'] ?? '',
        subjectCode: json['subjectCode'] ?? '',
        subjectName: json['subjectName'] ?? '',
        academicYear: json['academicYear'] ?? '',
        postCount: json['postCount'] ?? 0,
    );
  }

  //For firestore
  factory SubjectModel.fromFirestore(Map<String, dynamic> data, String id){
    return SubjectModel(
      subjectCode: data['subjectCode'] ?? '',
      subjectName: data['subjectName'] ?? '',
      academicYear: data['academicYear'] ?? '',
      postCount: data['postCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if (subjectId != null ) 'subjectId': subjectId,
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      if(academicYear != null) 'academicYear': academicYear,
      'postCount': postCount,
    };
  }



}