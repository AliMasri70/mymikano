import 'package:flutter/material.dart';
import 'package:mymikano_app/main.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/views/screens/SignInScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

import 'LocalUserPositionService.dart';

logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var response = await http.delete(
        Uri.parse(deleteDeviceUrl +
            '/${prefs.get("UserID")}?deviceToken=${prefs.getString("DeviceToken")}"'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.getString("accessToken")}"
        });

    if (!await prefs.getBool('GuestLogin')!) gps.stopTimer();
    prefs.clear();
    await prefs.setBool('IsLoggedIn', false);
    await prefs.setBool('GuestLogin', false);
    navigator.currentState!.popUntil((route) => route.isFirst);
    navigator.currentState!.pushReplacement(
      MaterialPageRoute(builder: (context) => T13SignInScreen()),
    );
  } catch (e) {
    print(e);
  }
}
