import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mymikano_app/models/NotificationModel.dart';
import 'package:mymikano_app/services/DioClass.dart';
import 'package:mymikano_app/services/LocalStorageService.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../views/screens/NotificationsScreen.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  LocalStorageService localStorageService = LocalStorageService();

  Future initialise(BuildContext context) async {
    _fcm.requestPermission();

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await FirebaseMessaging.instance.getToken();
    // print("Device Token: " + token.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoged = await prefs.getBool('IsLoggedIn') ?? false;
    if (isLoged) {
      print("isloggggg");
      await prefs.setString("DeviceToken", token.toString());
      debugPrint("Device Token: $token");
    } else {
      print("Notloggggg");

      await prefs.setString("DeviceToken", token.toString());
      // await prefs.setString("DeviceToken", "");
      debugPrint("Device Tokenn: $token");
    }

    Future<void> messageHandler(RemoteMessage message,
        {bool navigate = false}) async {
      int count = 0;
      var value = await localStorageService.getItem("Count");
      try {
        count = int.parse(value);
      } catch (e) {
        count = -1;
      }
      await localStorageService.setItem("Count", (count + 1).toString());
      await localStorageService.setItem(
          "notification ${count + 1}", message.notification!.body);
      Fluttertoast.showToast(
          msg: message.notification!.body.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      if (navigate) {
        await navigator.currentState?.push(
          MaterialPageRoute(builder: (context) => NotificationsPage()),
        );
      }
    }

    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      Future.delayed(Duration(seconds: 4), () async {
        messageHandler(message, navigate: true);
      });
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      messageHandler(event);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      messageHandler(message, navigate: true);
    });
  }
}
