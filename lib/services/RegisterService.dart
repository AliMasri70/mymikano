import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mymikano_app/utils/colors.dart';
import 'package:mymikano_app/views/screens/SignInScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Register(String username, String firstname, String lastname, String email,
    String password, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = await prefs.getString("DeviceToken").toString();

  final body = {
    "firstName": firstname,
    "lastName": lastname,
    "email": email,
    "password": password,
    "deviceToken": token
  };

  var response = await http.post(
      Uri.parse("http://dev.codepickles.com:8083/api/Users"),
      body: json.encode(body),
      headers: {
        'Content-type': 'application/json',
      });

  if (response.statusCode == 201) {
    Fluttertoast.showToast(
        msg: "User created successfully ! ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: t13_edit_text_color,
        textColor: Colors.black87,
        fontSize: 16.0);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => T13SignInScreen()),
    );
    // print("created successfully");

  } else {
    Fluttertoast.showToast(
        msg: "Failed to create user ! " + response.body.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: t13_edit_text_color,
        textColor: Colors.black87,
        fontSize: 16.0);
    //print("failed to create user");
  }
}
