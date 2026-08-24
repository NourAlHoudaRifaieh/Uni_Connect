import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/notification_model.dart';
import 'package:uni_connect/features/feed/presentation/widgets/notification_title.dart';

import '../../../core/mock/mock_data.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() {
    return _NotificationScreenState();
  }
}

class _NotificationScreenState extends State<NotificationScreen> {

  List<NotificationModel> get _notifications => MockData.notifications;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final unreadCount = _notifications.where((n) => !n.isRead).length;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Notifications',
                              style: GoogleFonts.inter(fontSize: 22, fontWeight:  FontWeight.bold)
                          ),
                          SizedBox(height:4),
                          Text(
                            '$unreadCount unread',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            MockData.markAllNotificationsAsRead();
                          });
                        },
                        child: Text(
                          'Mark all read',
                          style: GoogleFonts.inter(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.bold,
                            fontSize:13,
                          ),
                        ),
                      ),
                    ],
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
            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index){
                  final notification = _notifications[index];
                  return NotificationTile(
                    notification: notification,
                    onTap: (){
                      setState(() {
                        MockData.markNotificationAsRead(notification.notificationId);
                      });
                    }
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}