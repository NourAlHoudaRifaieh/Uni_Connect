import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/subject_request_repository.dart';
import 'package:uni_connect/features/feed/presentation/widgets/see_another_subject/request_status_chip.dart';

class MySubjectRequests extends StatelessWidget {
  final UserModel user;
  const MySubjectRequests({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: SubjectRequestRepository().watchForUser(user.userId),
      builder: (context, snapshot) {
        final requests = snapshot.data ?? [];
        if (requests.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row: only the title and the "Clear finished" button live here.
            Row(
              children: [
                Expanded(
                  child: Text(
                    'My requests',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (requests.any((r) => r['status'] != 'pending'))
                  TextButton(
                    onPressed: () => SubjectRequestRepository().clearDecided(user.userId),
                    child: const Text('Clear finished'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // The request rows are children of the Column, NOT of the title Row.
            ...requests.map((req) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${req['subjectName']}\n${req['subjectYear']}',
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                  ),
                  RequestStatusChip(status: (req['status'] ?? 'pending') as String),
                  IconButton(
                    onPressed: () {
                      SubjectRequestRepository().clear(req['id'] as String);
                    },
                    tooltip: 'Clear',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}