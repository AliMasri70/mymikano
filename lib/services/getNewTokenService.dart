import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mymikano_app/main.dart';
import 'package:mymikano_app/services/LogoutService.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/colors.dart';
import 'package:mymikano_app/views/screens/MainDashboard.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

RefreshToken(String refreshToken) async {
  try {
    final response =
        await http.post(Uri.parse(authorizationEndpoint), headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "refresh_token": refreshToken,
      "grant_type": "refresh_token",
      "client_id": "MymikanoAppLogin",
    });
    if (response.statusCode == 200) {
      var temp = jsonDecode(response.body);
      final directory = await getApplicationDocumentsDirectory();
      String appDocPath = directory.path;
      File('$appDocPath/credentials.json').writeAsString(temp['access_token']);
      File file = File('${directory.path}/credentials.json'); //
      String fileContent = await file.readAsString();

      Map<String, dynamic> jwtData = {};
      JwtDecoder.decode(fileContent)!.forEach((key, value) {
        jwtData[key] = value;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", temp['access_token']);
      // await prefs.setString("refreshToken", temp['refresh_token']);
      await prefs.setInt("tokenDuration", jwtData['exp'] - jwtData['iat']);
      await prefs.setInt("tokenStartTime", jwtData['iat']);
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Session Expired",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: t13_edit_text_color,
          textColor: Colors.black87,
          fontSize: 16.0);
      await logout();
      return false;
    }
  } on Exception catch (e) {
    Fluttertoast.showToast(
        msg: "Session Expired" + e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: t13_edit_text_color,
        textColor: Colors.black87,
        fontSize: 16.0);
    await logout();
    return false;
  }
}
