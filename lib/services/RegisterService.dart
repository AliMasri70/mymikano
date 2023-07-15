import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mymikano_app/services/LanNotificationServicee.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Register(String username, String firstname, String lastname, String email,
    String password, BuildContext context) async {
  try {
    FirebaseMessaging _fcm = FirebaseMessaging.instance;

    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("DeviceToken").toString();
    if (token.isEmpty || token == "") {
      _fcm.requestPermission();
      token = (await _fcm.getToken())!;
    }

    final body = {
      "FirstName": firstname,
      "LastName": lastname,
      "Email": email,
      "Password": password,
      "Devicetoken": token
    };
    print(RegisterUrl);
    var response = await dio.post(RegisterUrl, queryParameters: body);
    print("regggggg: " + response.toString());
    if (response.statusCode == 200) {
      if (prefs.getBool(prefs_DashboardFirstTimeAccess) == null) {
        await prefs.setBool(prefs_DashboardFirstTimeAccess, true);
      }

      if (prefs.getString(prefs_ApiConfigurationOption) == null) {
        await prefs.setString(prefs_ApiConfigurationOption, 'lan');
      }

      if (prefs.getInt(prefs_RefreshRate) == null) {
        await prefs.setInt(prefs_RefreshRate, 60);
      }

      Fluttertoast.showToast(
          msg: "User created successfully ! ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black87,
          fontSize: 16.0);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => T13SignInScreen()),
      );
      // debugPrint("created successfully");
    } else {
      Fluttertoast.showToast(
          msg: "Failed to create user ! " + response.data.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black87,
          fontSize: 16.0);
      //debugPrint("failed to create user");
    }
  } catch (e) {
    if (e is DioError) {
      if (e.response != null) {
        // The server responded with an error status code
        print('Server error: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      } else {
        // DioError without a response
        print('Error connecting to the server.');
      }
    } else {
      // Generic error handling
      print('Unexpected error: $e');
    }
  }
}
