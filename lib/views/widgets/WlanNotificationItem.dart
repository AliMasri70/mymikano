import 'package:flutter/material.dart';
import 'package:mymikano_app/models/WlanNotificationModel.dart';
import 'package:mymikano_app/utils/AppColors.dart';

class WlanNotificationItem extends StatelessWidget {
  final WlanNotificationModel wlanNotification;

  const WlanNotificationItem({Key? key, required this.wlanNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 20.0, top: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: lightBorderColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(children: [
          Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Image.asset(
                'assets/maintenance-notifications-icon.png',
                color: Colors.grey,
                width: 35,
              )),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wlanNotification.text.toString(),
                  style: TextStyle(fontSize: 14, color: mainBlackColorTheme),
                  maxLines: 4,
                ),
                SizedBox(height: 11.0),
                Text(
                  wlanNotification.dateTime.toString(),
                  style: TextStyle(fontSize: 14, color: mainGreyColorTheme),
                ),
              ],
            ),
          ),
          Spacer(),
        ]));
  }
}
