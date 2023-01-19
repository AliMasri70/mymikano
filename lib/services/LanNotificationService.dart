//added by youssefk for background service//
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mymikano_app/models/ConfigurationModel.dart';
import 'package:mymikano_app/views/screens/Dashboard/NotificationPage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/LanAlarm.dart';
import '../utils/appsettings.dart';
import '../utils/strings.dart';

String  token="";
String userID="";
Future<FlutterBackgroundService> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart:false,
        isForegroundMode: true,
        initialNotificationContent: '',
        initialNotificationTitle:'',
      foregroundServiceNotificationId: 1
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart:false,
      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
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

Future<void> GetAndPushNotifications (ServiceInstance service) async {
  var dio = Dio();
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'Lan_Notification', // id
    'Lan_Notification', // title
    description:
    'This channel is used for Generators Lan  notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
  );


 final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_notification_icon');
  final DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final LinuxInitializationSettings initializationSettingsLinux =
  LinuxInitializationSettings(
      defaultActionName: 'Open notification');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);


  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

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

  // bring to foreground

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    //make the call to the api just here//
    List<LanAlarm> listAllAlarms=[];
    List<LanAlarm> listAlarms;
    //fetching the list of lan configured generators//
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ConfigurationModel> configsList = (json.decode(prefs.getString('Configurations')!) as List)
        .map((data) => ConfigurationModel.fromJson(data)).toList();
    if(configsList!=null){
      for(ConfigurationModel model in configsList){
        if (model.cloudMode==0)
        {
          final response = await dio.get('http://'+model.espapiendpoint+'/alarms');
          if(response!=null) {
            listAlarms =
                response.data.map<LanAlarm>((json) => LanAlarm.fromJson(json))
                    .toList();
            for(LanAlarm alarm in listAlarms){
              alarm.text="WLAN-"+model.generatorName+" "+alarm.text;
              listAllAlarms.add(alarm);
            }
          }
        }
      }
    }

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
            'deviceToken' : '',
          });

      final isAuthenticated = (responseAuth.data)['isAuthenticated'];
      if (isAuthenticated == false) {

      }
      token = (responseAuth.data)['token'];
    } catch (e) {
      debugPrint(e.toString());
    }

    for(LanAlarm alarm in listAllAlarms) {
      //added by youssef k to post notification to mikano api//

      try {
        final response = await dio.post(cloudIotMautoNotifications,
            data: {
              "message":alarm.text+" level: ${alarm.level.toString()} active: ${alarm.active.toString()} confirmed: ${alarm.confirmed.toString()}",
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
      }
      catch (e) {
        debugPrint(e.toString());
      }
    }
    // if (service is AndroidServiceInstance) {
    //   if (await service.isForegroundService()) {
    /// OPTIONAL for use custom notification
    /// the notification id must be equals with AndroidConfiguration when you call configure() method.
    if(listAllAlarms.length!=0) {
      for(LanAlarm alarm in listAllAlarms) {
        final now=DateTime.now();
        String sec=now.second.toString();
        String ms=now.millisecond.toString();
        String sId=sec+ms;
        int notificataionId=int.parse(sId);
        flutterLocalNotificationsPlugin.show(
          notificataionId,
          alarm.text,
          "level: ${alarm.level.toString()} active: ${alarm.active.toString()} confirmed: ${alarm.confirmed.toString()}",
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'Lan_Notification',
              'Lan_Notification',
              icon: 'ic_notification_icon',
              ongoing:true,
            ),
          ),
          payload: "Lan Notification"
        );
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

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
    navigatorKey.currentState?.push( MaterialPageRoute( builder: (context) => NotificationPage(), ), );
  }

}

void onDidReceiveLocalNotification(
    int id, String ? title, String ? body, String ? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  navigatorKey.currentState?.push( MaterialPageRoute( builder: (context) => NotificationPage(), ), );

}
