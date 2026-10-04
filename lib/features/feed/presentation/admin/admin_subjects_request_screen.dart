import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/features/auth/data/subject_request_repository.dart';

class AdminSubjectRequestScreen extends StatelessWidget {
  final bool isStandalone;
  const AdminSubjectRequestScreen({
    super.key,
    required this.isStandalone,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: isStandalone
          ? Colors.white
          : Color(0xFF1D61FF).withOpacity(0.02),
      body: SafeArea(
        child: Column(
          children: [
            if (isStandalone) ...[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chevron_left, color: Color(0xFF2563EB), size:20),
                          Text('Cancel', style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(height:10),
                    Text('Subject Requests',
                        style: GoogleFonts.inter(fontSize: 20, fontWeight:  FontWeight.bold)
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFF1F5F9),
                      width:1.5,
                    ),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset:Offset(0,8),
                    ),
                  ],
                ),
              ),
            ],
            StreamBuilder<List<Map<String, dynamic>>>(
                stream: SubjectRequestRepository().watchPending(),
                builder: (context, snap){
                  if(!snap.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final items= snap.data!;
                  if(items.isEmpty){
                    return Center(
                      child: Text(
                        'No pending requests',
                        style: GoogleFonts.inter(
                          color:Colors.grey.shade500,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: items.length,
                      itemBuilder: (context, i){
                        final r  = items[i];
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${r['userName']}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Currently: ${r['userName'] ?? ''} (${r['userYear']}',
                                style: GoogleFonts.inter(
                                  color:Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height:8),
                              Text('Wants to enter the group "${r['subjectGroupName'] ?? ''}" for the subject '
                                  '"${r['subjectName']}" (${r['subjectYear']}) and see its posts.',
                                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade800)),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                      child: CustomElevatedButton(
                                          text: 'Reject',
                                          onPressed: (){
                                            SubjectRequestRepository().reject(r);
                                          },
                                          type: ButtonType.outlined,
                                          backgroundColor: Colors.redAccent,
                                      ),
                                  ),
                                  SizedBox(width:18),
                                  Expanded(
                                    child: CustomElevatedButton(
                                      text: 'Accept',
                                      onPressed: () async{
                                        final error = await SubjectRequestRepository().accept(r);
                                        if(error != null){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(error)),
                                          );
                                        }
                                      },
                                      type: ButtonType.elevated,
                                      backgroundColor: Color(0xFF2563EB),
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
