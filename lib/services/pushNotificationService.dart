import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mymikano_app/services/LocalStorageService.dart';
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
    String? token = await _fcm.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("DeviceToken", token.toString());
    debugPrint("Device Token: $token");

    messageHandler(RemoteMessage message) async {
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
    }

    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      Future.delayed(Duration(seconds: 4), () async {
        toast("1");
        messageHandler(message);
        await navigator.currentState?.push(
          MaterialPageRoute(builder: (context) => NotificationsPage()),
        );
      });
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      toast("2");
      messageHandler(event);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      toast("3");
      messageHandler(message);
      await navigator.currentState?.push(
        MaterialPageRoute(builder: (context) => NotificationsPage()),
      );
    });
  }
}
