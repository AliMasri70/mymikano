import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymikano_app/main.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/views/screens/SignInScreen.dart';
import 'package:nb_utils/nb_utils.dart';

import 'LocalUserPositionService.dart';

logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("DeviceToken").toString();
  try {
    if (token != "null")
      var response = await http.delete(
          Uri.parse(deleteDeviceUrl +
              '/${prefs.get("UserID")}?deviceToken=${token}"'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${prefs.getString("accessToken")}"
          });

    if (!await prefs.getBool('GuestLogin')!) gps.canceled = true;
    prefs.clear();
    await prefs.setString("DeviceToken", token.toString());
    await prefs.setBool('IsLoggedIn', false);
    await prefs.setBool('GuestLogin', false);
    navigator.currentState!.popUntil((route) => route.isFirst);
    navigator.currentState!.pushReplacement(
      MaterialPageRoute(builder: (context) => T13SignInScreen()),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
