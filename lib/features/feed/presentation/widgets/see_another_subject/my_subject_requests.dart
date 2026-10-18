import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/features/auth/data/subject_request_repository.dart';
import 'package:uni_connect/features/feed/presentation/widgets/see_another_subject/request_status_chip.dart';

class MySubjectRequests extends StatelessWidget {
  final UserModel user;
  MySubjectRequests({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: SubjectRequestRepository().watchForUser(user.userId),
        builder: (context, snapshot){
          final requests = snapshot.data ?? [];
          if(requests.isEmpty) return SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'My requests',
                      style: GoogleFonts.inter(
                        fontSize:14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if(requests.any((r) => r['status'] != 'pending'))
                    TextButton(
                        child: Text('Clear finished'),
                        onPressed: () => SubjectRequestRepository().clearDecided(user.userId),
                    ),
                  SizedBox(height:8),
                  ...requests.map((req) => Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color:Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${req['subjectName']}\n${'subjectYear'}',
                            style: GoogleFonts.inter(fontSize:13),
                          ),
                        ),
                        RequestStatusChip(status: (req['status'] ?? 'pending') as String),
                        IconButton(
                            onPressed: (){
                              SubjectRequestRepository().clear(req['id'] as String);
                            },
                            tooltip: 'Clear',
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.close, size: 18, color: Colors.grey,)
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height:8),
                ],
              ),
            ],
          );
        }
    );
  }
}
