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

class AlarmNotification extends StatefulWidget {
  AlarmNotification({Key? key}) : super(key: key);

  @override
  State<AlarmNotification> createState() => _AlarmNotificationState();
}

class _AlarmNotificationState extends State<AlarmNotification> {
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
                    title: lbl_AlarmNotifications,
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
                    // print("notiiii source: " + notification.source.toString());
                    // print("notiiii msg: " + notification.message.toString());
                    // print("notiiii len: " +
                    //     Provider.of<NotificationState>(context)
                    //         .notifications
                    //         .length
                    //         .toString());
                    // print("notiiii msg: " +
                    //     Provider.of<NotificationState>(context)
                    //         .notifications[15]
                    //         .source
                    //         .toString());
                    if ((notification.source.toString().trim() !=
                        "My Mikano")) {
                      return NotificationItem(
                        notification: notification,
                      );
                    }

                    // return null;
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
