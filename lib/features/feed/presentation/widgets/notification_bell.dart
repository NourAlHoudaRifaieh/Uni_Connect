import 'package:flutter/material.dart';
import 'package:uni_connect/core/models/notification_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/notification_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/feed/presentation/student/notification_screen.dart';

class NotificationBell extends StatefulWidget {
  final Color iconColor;
  const NotificationBell({super.key, this.iconColor = const Color(0xFF374151)});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final NotificationRepository _notifRepo = NotificationRepository();
  final Stream<UserModel?> _userStream = UserRepository().watchCurrentUser();
  Stream<List<NotificationModel>>? _notifStream;
  String _loadedUserId = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: _userStream,
      builder: (context, userSnap) {
        final userId = userSnap.data?.userId ?? '';
        // create the notifications stream ONCE per user, never on every rebuild
        if (userId.isNotEmpty && userId != _loadedUserId) {
          _loadedUserId = userId;
          _notifStream = _notifRepo.watchForUser(userId);
        }
        return StreamBuilder<List<NotificationModel>>(
          stream: _notifStream,
          initialData: const [],
          builder: (context, notifSnap) {
            if (notifSnap.hasError) {
              debugPrint('Bell notifications error: ${notifSnap.error}');
            }
            final unread = (notifSnap.data ?? <NotificationModel>[])
                .where((n) => !n.isRead)
                .length;
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationsScreen()),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding:EdgeInsets.all(6),
                    child: Icon(Icons.notifications_outlined, size: 26, color: widget.iconColor),
                  ),
                  if (unread > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          unread > 9 ? '9+' : '$unread',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}