import 'package:flutter/material.dart';
import 'package:mymikano_app/main.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/views/screens/SignInScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

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
    prefs.clear();
    print(response.statusCode);
    await prefs.setBool('IsLoggedIn', false);
    navigator.currentState!.pushReplacement(
      MaterialPageRoute(builder: (context) => T13SignInScreen()),
    );
  } catch (e) {
    print(e);
  }
}
