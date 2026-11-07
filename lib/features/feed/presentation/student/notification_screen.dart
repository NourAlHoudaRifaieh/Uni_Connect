import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/notification_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/notification_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifRepo = NotificationRepository();
    final userRepo = UserRepository();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Notifications',
            style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          FutureBuilder<String>(
            future: userRepo.currentDocId(),
            builder: (context, snap) => TextButton(
              onPressed: () {
                final id = snap.data;
                if (id != null && id.isNotEmpty) notifRepo.markAllAsRead(id);
              },
              child: Text('Mark all read',
                  style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: userRepo.watchCurrentUser(),
        builder: (context, userSnap) {
          final userId = userSnap.data?.userId ?? '';
          if (userId.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return StreamBuilder<List<NotificationModel>>(
            stream: notifRepo.watchForUser(userId),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final items = snap.data ?? [];
              if (items.isEmpty) {
                return Center(
                  child: Text('No notifications yet',
                      style: GoogleFonts.inter(color: Colors.grey)),
                );
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, i) {
                  final n = items[i];
                  return ListTile(
                    tileColor: n.isRead ? null : Color(0xFFEFF6FF),
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF1D61FF),
                      child: Text(n.initials,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      n.content,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(n.timeAgo,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                    trailing: n.isRead
                        ? null
                        : CircleAvatar(radius: 4, backgroundColor: Color(0xFF1D61FF)),
                    onTap: () {
                      if (!n.isRead) notifRepo.markAsRead(n.notificationId);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}