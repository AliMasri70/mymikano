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
  final alarmManager = AlarmManager();
  Future<void> fetchDataAndNotify() async {
    String? IPaddr = await getIpGateway();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String apiLanIP = await prefs.getString(prefs_ApiLanEndpoint).toString();
    // print('http://192.168.1.14:8080/alarms');

    // final response = await dio.get('$apiLanIP/alarms');
    final response = await dio.get('http://192.168.0.102/alarms');
    if (response.statusCode == 200) {
      print('response: ${response.data[0]}');
      //
      newVariables.clear();
      final List jsonList = response.data;

      try {
        alarmManager.previousVariables.clear();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString("previousVariables");
        if (jsonString != null) {
          final jsonArray = jsonDecode(jsonString);
          alarmManager.previousVariables.addAll(jsonArray);
        }
      } catch (e) {
        // Handle errors, if any
        print('Error loading data from SharedPreferences: $e');
      }
      int len1 = jsonList.length;
      int len2 = alarmManager.previousVariables.length;
      print(len1.toString() + "==" + len2.toString());
      final variables = jsonList.map((json) {
        String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
        return WlanNotificationModel.fromJson(json, currentDate);
      }).toList();

      variables.forEach((element) {
        if (!alarmManager.previousVariables.contains(element)) {
          setState(() {
            newVariables.add(element);
          });
        }
      });

      setState(() {
        // alarmManager.previousVariables.clear();
        viewList.clear();
        viewList.addAll(variables);
        alarmManager.previousVariables.addAll(newVariables);
      });
      final jsonString = jsonEncode(alarmManager.previousVariables);
      await prefs.setString("previousVariables", jsonString);

      if (newVariables.isNotEmpty) {
        // Create a notification

        if (len1 > len2) {
          for (var variable in newVariables) {
            scheduleNewNotification(
                variable.hashCode, 'WLan Notification', variable.text);

            setState(() {});
          }
        }
      }
    }
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

    var duration =
        Duration(seconds: 3); // Adjust the interval as per your requirements
    Timer.periodic(duration, (timer) {
      // scheduleNewNotification(1, 'WLan Notification', "variable.text");
      fetchDataAndNotify();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    setupTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final alarmManager = AlarmManager();
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
              viewList.length <= 0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: alarmManager.previousVariables.length,
                        itemBuilder: (context, index) {
                          // NotificationModel notification =
                          //     Provider.of<NotificationState>(context)
                          //         .notifications[index];

                          return WlanNotificationItem(
                            wlanNotification:
                                alarmManager.previousVariables[index],
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: viewList.length,
                        itemBuilder: (context, index) {
                          // NotificationModel notification =
                          //     Provider.of<NotificationState>(context)
                          //         .notifications[index];

                          return WlanNotificationItem(
                            wlanNotification: viewList[index],
                          );
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
