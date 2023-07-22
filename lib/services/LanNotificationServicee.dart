//added by youssefk for background service//
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:intl/intl.dart';
import 'package:mymikano_app/models/ConfigurationModel.dart';
import 'package:mymikano_app/models/WlanNotificationModel.dart';
import 'package:mymikano_app/views/screens/Dashboard/NotificationPage.dart';
import 'package:mymikano_app/views/screens/NotificationsScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../models/LanAlarm.dart';
import '../utils/appsettings.dart';
import '../utils/strings.dart';

String token = "";
String userID = "";
final dio = Dio();
bool loaded = false;
List<WlanNotificationModel> viewList = [];
List<WlanNotificationModel> newVariables = [];
List<WlanNotificationModel> alarmManager = [];
Future<FlutterBackgroundService> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
        initialNotificationContent: '',
        initialNotificationTitle: '',
        foregroundServiceNotificationId: 1),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,
      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  //tap listiner on notification added by youssef k for lan notification //
  AwesomeNotifications()
      .actionStream
      .listen((ReceivedNotification receivedNotification) {
    print("bliblo" + receivedNotification.payload!['name'].toString());
    //redirect to notification page//
    // navigatorKey.currentContext?.push(
    //   MaterialPageRoute(builder: (context) => NotificationPage(),),);
    Navigator.push(
      navigator.currentContext!,
      MaterialPageRoute(builder: (context) => NotificationsPage()),
    );
  });
  //starting service
  service.startService();
  return service;
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  GetAndPushNotifications(service);
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await GetAndPushNotifications(service);
}
////////////////////////////////////////////

Future<void> GetAndPushNotifications(ServiceInstance service) async {
  var dio = Dio();
  String IPaddr = await getIpGateway() ?? "192.168.0.1";
  // Only available for flutter 3.0.0 and later
  print('in loop');
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // bring to foreground
  int refreshDuration = prefs.getInt('refreshDuration') != null
      ? prefs.getInt('refreshDuration')!.toInt()
      : 1;
  print('in loop ${prefs.getInt('refreshDuration')!.toInt()}');
  Timer.periodic(Duration(seconds: 1), (timer) async {
    //make the call to the api just here//
    List<LanAlarm> listAllAlarms = [];
    // List<LanAlarm> listAlarms;
    //fetching the list of lan configured generators//

    // List<ConfigurationModel> configsList =
    //     (json.decode(prefs.getString('Configurations')!) as List)
    //         .map((data) => ConfigurationModel.fromJson(data))
    //         .toList();
    // if (configsList.isNotEmpty) {
    // for (ConfigurationModel model in configsList) {
    // if (model.cloudMode == 0) {
    //       String apiLanIP =
    // print('in background noti 2 $decodedData');

    String apiLanIP = "http://192.168.0.170/alarms/index.php";
    // await prefs.getString(prefs_ApiLanEndpoint).toString() == null
    //     ? IPaddr
    //     : await prefs.getString(prefs_ApiLanEndpoint).toString();
    // print('http://192.168.1.14:8080/alarms');
    try {
      print('in loop');

      // final response = await dio.get('http://192.168.0.102/alarms');

      final response = await dio.get('$apiLanIP/alarms');
      if (response.statusCode == 200) {
        final List jsonList = response.data;
        // print('in background noti 1 $jsonList');
        try {
          alarmManager.clear();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          String? jsonData = prefs.getString("previousVariables");

          if (jsonData != null) {
            List<dynamic> decodedData = jsonDecode(jsonData);
            // print('in background noti 2 $decodedData');

            final newlist = decodedData
                .map((notificationJson) => WlanNotificationModel(
                      level: notificationJson['level'],
                      active: notificationJson['active'],
                      confirmed: notificationJson['confirmed'],
                      text: notificationJson['text'],
                      dateTime: notificationJson['dateTime'],
                    ))
                .toList();

            alarmManager.addAll(newlist);
            print("in llllll 1  ${alarmManager.length}");
          } else {
            print("in length else");
          }
        } catch (e) {
          // Handle errors, if any
          print('in prefs:error $e');
        }

        final variables = jsonList.map((json) {
          String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
          return WlanNotificationModel.fromJson(json, currentDate);
        }).toList();

        alarmManager.addAll(variables);
        // print('in background noti 3 $alarmManager');

        try {
          List<Map<String, dynamic>> alarmManagerData = alarmManager
              .map((notification) => {
                    'level': notification.level,
                    'active': notification.active,
                    'confirmed': notification.confirmed,
                    'text': notification.text,
                    'dateTime': notification.dateTime,
                  })
              .toList();
          String jsonString = jsonEncode(alarmManagerData);
          // print('in background noti 4 $jsonString');

          await prefs.setString("previousVariables", "");
          await prefs.setString("previousVariables", jsonString);
          String? jsonData = await prefs.getString("previousVariables");
          print("in mainnnn is loaded or not" + jsonData.toString());
        } catch (e) {
          // Handle errors, if any
          print('Error saving data to SharedPreferences: $e');
        }
        if (variables.isNotEmpty) {
          // Create a notification

          for (var variable in variables) {
            scheduleNewNotification(
                variable.hashCode, 'WLan Notification', variable.text);

            // setState(() {});
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
    // }
    // }
    // }

    String cloudUsername = prefs.getString(prefs_CloudUsername).toString();
    String cloudPassword = prefs.getString(prefs_CloudPassword).toString();
    String userID = prefs.getString("IotUserID").toString();
    //get a token for the user logged in //
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };
    try {
      final responseAuth = await dio.post(cloudIotMautoAuthUrl,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
          data: {
            'email': cloudUsername,
            'password': cloudPassword,
            'deviceToken': '',
          });

      final isAuthenticated = (responseAuth.data)['isAuthenticated'];
      if (isAuthenticated == false) {}
      token = (responseAuth.data)['token'];
    } catch (e) {
      debugPrint(e.toString());
    }

    for (LanAlarm alarm in listAllAlarms) {
      //added by youssef k to post notification to mikano api//

      try {
        final response = await dio.post(cloudIotMautoNotifications,
            data: {
              "message": alarm.text +
                  " level: ${alarm.level.toString()} active: ${alarm.active.toString()} confirmed: ${alarm.confirmed.toString()}",
              "source": "IOT",
              "datetime": DateTime.now().toString(),
              "userID": userID
            },
            options: Options(headers: {
              "Authorization": "Bearer ${token}",
              "Content-Type": "application/json"
            }));
        if (response.statusCode == 201) {
          debugPrint("Notification posted !");
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    // if (service is AndroidServiceInstance) {
    //   if (await service.isForegroundService()) {
    /// OPTIONAL for use custom notification
    /// the notification id must be equals with AndroidConfiguration when you call configure() method.
    if (listAllAlarms.length != 0) {
      for (LanAlarm alarm in listAllAlarms) {
        final now = DateTime.now();
        String sec = now.second.toString();
        String ms = now.millisecond.toString();
        String sId = sec + ms;
        int notificataionId = int.parse(sId);
        bool isallowed = await AwesomeNotifications().isNotificationAllowed();
        if (!isallowed) {
          //no permission of local notification
          AwesomeNotifications().requestPermissionToSendNotifications();
        } else {
          //show notification
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  //simgple notification
                  id: notificataionId,
                  channelKey:
                      'LanNotification', //set configuration wuth key "basic"
                  title: alarm.text,
                  body:
                      "level: ${alarm.level.toString()} active: ${alarm.active.toString()} confirmed: ${alarm.confirmed.toString()}",
                  payload: {"name": "Lan_Notification"}));
        }
      }
    }

    // if you don't using custom notification, uncomment this
    // service.setForegroundNotificationInfo(
    //   title: "My App Service",
    //   content: "Updated at ${DateTime.now()}",
    // );
    //}
    //}

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": "balalala",
      },
    );
  });
}

Future<void> scheduleNewNotification(int id, String title, String body) async {
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

Future<String?> getIpGateway() async {
  final info = NetworkInfo();

  return await info.getWifiGatewayIP();
}
