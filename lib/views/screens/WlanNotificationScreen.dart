import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymikano_app/State/ApiConfigurationStatee.dart';
import 'package:mymikano_app/State/CloudGeneratorState.dart';
import 'package:mymikano_app/State/NotificationState.dart';
import 'package:mymikano_app/models/NotificationModel.dart';
import 'package:mymikano_app/models/WlanNotificationModel.dart';
import 'package:mymikano_app/services/LanAlarmManager.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/NotificationItem.dart';
import 'package:mymikano_app/views/widgets/WlanNotificationItem.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';

import '../../State/ApiConfigurationState.dart';
import '../../utils/AppColors.dart';
import '../widgets/TitleText.dart';
import 'MainDashboard.dart';

class WlanNotificationScreen extends StatefulWidget {
  WlanNotificationScreen({Key? key}) : super(key: key);

  @override
  State<WlanNotificationScreen> createState() => _WlanNotificationScreenState();
}

class _WlanNotificationScreenState extends State<WlanNotificationScreen> {
  final dio = Dio();
  bool loaded = false;
  List<WlanNotificationModel> viewList = [];
  List<WlanNotificationModel> newVariables = [];
  List<WlanNotificationModel> alarmManager = [];
  bool isLoading = false;

  Future<void> deleteNotifications() async {
    print("deleting notifications");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("previousVariables", "");
    setState(() {});
    loadPrefs();
  }

  @override
  void didChangeDependencies() {
    loadPrefs();
    setState(() {});
    super.didChangeDependencies();
  }

  Future<void> loadPrefs() async {
    setState(() {
      isLoading = true;
    });
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonData = await prefs.getString("previousVariables") ?? "";
      print("in llllll 11 " + jsonData.toString());

      if (jsonData != null) {
        List<dynamic> decodedData = jsonDecode(jsonData);

        final newlist = decodedData
            .map((notificationJson) => WlanNotificationModel(
                  level: notificationJson['level'],
                  active: notificationJson['active'],
                  confirmed: notificationJson['confirmed'],
                  text: notificationJson['text'],
                  dateTime: notificationJson['dateTime'],
                ))
            .toList();
        setState(() {
          alarmManager.clear();
          alarmManager.addAll(newlist);
        });
        print("in llllll 12 ${alarmManager.length}");
      } else {
        print("in length else");
      }
    } catch (e) {
      // Handle errors, if any
      print('in prefs:error $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  static Future<void> scheduleNewNotification(
      int id, String title, String body) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id, // -1 is replaced by a random number
        channelKey: 'LanNotification',
        title: title,
        body: body,

        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<String?> getIpGateway() async {
    final info = NetworkInfo();

    return await info.getWifiGatewayIP();
  }

  void setupTimer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // int refreshDuration = prefs.getInt('refreshDuration')!.toInt();
    var duration =
        Duration(seconds: 1); // Adjust the interval as per your requirements
    Timer.periodic(duration, (timer) {
      // scheduleNewNotification(1, 'WLan Notification', "variable.text");
      // fetchDataAndNotify();
      loadPrefs();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    loadPrefs();
    // setupTimer();

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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: TitleText(
                      title: lbl_WlanNotifications,
                      textSize: 23,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: backArrowColor,
                          ),
                          onPressed: () {
                            loadPrefs();
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: backArrowColor,
                        ),
                        onPressed: () {
                          deleteNotifications();
                        },
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : alarmManager.length == 0
                        ? Center(
                            child: Text("Wlan Notification Empty"),
                            // child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: alarmManager.length,
                            itemBuilder: (context, index) {
                              // NotificationModel notification =
                              //     Provider.of<NotificationState>(context)
                              //         .notifications[index];

                              return WlanNotificationItem(
                                wlanNotification: alarmManager[
                                    alarmManager.length - 1 - index],
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
