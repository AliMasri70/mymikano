import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mymikano_app/models/LocationSettingsModel.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class gps {
  static late Timer timer;
  static bool canceled = false;

  static void StartTimer() async {
    LocationSettingsModel settings = await gps().GetLocationSettings();
    timer =
        Timer.periodic(Duration(seconds: settings.refreshRate!), (timer) async {
      if (canceled ||
          !(DateTime.now().isBefore(DateTime.parse(settings.endTime!)) &&
              DateTime.now().isAfter(DateTime.parse(settings.startTime!)))) {
        stopTimer(timer);
        return;
      }
      Position position = await determinePosition();
      updateLocation(position.longitude, position.latitude);
    });
  }

  static void stopTimer(Timer? timer) {
    timer!.cancel();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<void> updateLocation(double longitude, double latitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    try {
      final response = await dio.post(LocationByDeviceUrl,
          data: {
            "userId": prefs.getString("UserID").toString(),
            "deviceToken": prefs.getString("DeviceToken").toString(),
            "longitude": longitude,
            "latitude": latitude
          },
          options: Options(headers: {
            "Authorization": "Bearer ${prefs.getString("accessToken")}",
            "Content-Type": "application/json"
          }));
      if (response.statusCode == 200) {
        debugPrint("Location updated");
        return;
      } else {
        debugPrint("Location not updated");
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<LocationSettingsModel> GetLocationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    try {
      final response = await dio.get(LocationSettingsUrl,
          options: Options(headers: {
            "Authorization": "Bearer ${prefs.getString("accessToken")}",
            "Content-Type": "application/json"
          }));
      if (response.statusCode == 200) {
        return LocationSettingsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load location settings');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load location settings');
    }
  }
}
