import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/notification_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/notification_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationRepository _notifRepo = NotificationRepository();
  final UserRepository _userRepo = UserRepository();
  Stream<List<NotificationModel>>? _stream;

  @override
  void initState() {
    super.initState();
    _userRepo.currentDocId().then((id) {
      if (mounted && id.isNotEmpty) {
        setState(() => _stream = _notifRepo.watchForUser(id));
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Notifications',
            style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () async{
              final id = await _userRepo.currentDocId();
              if (id.isNotEmpty) await _notifRepo.markAllAsRead(id);
            }, 
            child: Text('Mark all read', style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w600,)),
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (_stream == null || snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text('No notifications yet', style: GoogleFonts.inter(color: Colors.grey)));
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
                  if (!n.isRead) _notifRepo.markAsRead(n.notificationId);
                },
              );
            },
          );
        },
      ),
    );
  }
}