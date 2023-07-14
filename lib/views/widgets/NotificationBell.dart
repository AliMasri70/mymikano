import 'package:flutter/material.dart';
import 'package:mymikano_app/views/screens/AlarmNotifcationScreen.dart';
import 'package:mymikano_app/views/screens/Dashboard/LanDashboard_Index.dart';
import 'package:mymikano_app/views/screens/NotificationsScreen.dart';
import 'package:mymikano_app/views/screens/WlanNotificationScreen.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotificationsPage(),
              // builder: (context) => WlanNotificationScreen(),
              // builder: (context) => LanDashboard_Index(
              //       RefreshRate: 1,
              //     )
            ),
          );
        },
        icon: Icon(Icons.notifications));
  }
}
