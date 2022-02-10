import 'package:flutter/material.dart';
import 'package:mymikano_app/views/screens/NotificationsScreen.dart';

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
            ),
          );
        },
        icon: Icon(Icons.notifications));
  }
}
