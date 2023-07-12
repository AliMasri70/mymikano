import 'package:flutter/material.dart';
import 'package:mymikano_app/State/CloudGeneratorState.dart';
import 'package:mymikano_app/State/NotificationState.dart';
import 'package:mymikano_app/models/NotificationModel.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/NotificationItem.dart';
import 'package:provider/provider.dart';

import '../../utils/AppColors.dart';
import '../widgets/TitleText.dart';
import 'MainDashboard.dart';

class WlanNotificationScreen extends StatefulWidget {
  WlanNotificationScreen({Key? key}) : super(key: key);

  @override
  State<WlanNotificationScreen> createState() => _WlanNotificationScreenState();
}

class _WlanNotificationScreenState extends State<WlanNotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<NotificationState>(context, listen: false).update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(alignment: Alignment.center, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: backArrowColor,
                    ),
                    onPressed: () async {
                      Navigator.pop(context, (route) => route.isFirst);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TitleText(
                    title: lbl_WlanNotifications,
                    textSize: 24,
                  ),
                ),
              ]),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: Provider.of<NotificationState>(context)
                      .notifications
                      .length,
                  itemBuilder: (context, index) {
                    NotificationModel notification =
                        Provider.of<NotificationState>(context)
                            .notifications[index];
                    if ((notification.source.toString().trim() == "IOT")) {
                      return NotificationItem(
                        notification: notification,
                      );
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
