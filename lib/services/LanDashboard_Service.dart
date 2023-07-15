import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymikano_app/models/LanSensor_Model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/ConfigurationModel.dart';

class LanDashBoard_Service {
  //final String ApiEndPoint;
  // String apiLanEndpoint = "http://" + lanESPUrl;
  // LanDashBoard_Service(/*{required this.ApiEndPoint}*/);
  late final ConfigurationModel configModel;

  LanDashBoard_Service() {
    getSelectedConfigurationModel();
  }

  Future<ConfigurationModel> getSelectedConfigurationModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    String test = prefs.getString('Configurations').toString();
    List<ConfigurationModel> configsList =
        (json.decode(prefs.getString('Configurations')!) as List)
            .map((data) => ConfigurationModel.fromJson(data))
            .toList();
    ConfigurationModel config = ConfigurationModel.fromJson(
        json.decode(prefs.getString('SelectedConfigurationModel')!));
    configModel = config;
    return configModel;
  }

  Future<LANSensor> FetchSensorData(String param) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // apiLanEndpoint = await prefs.getString(prefs_ApiLanEndpoint)!;
    String apiLanEndpoint = "http://" + configModel.espapiendpoint;
    final response =
        await http.get(Uri.parse(apiLanEndpoint + '/getValue?param=' + param));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      LANSensor sensor = LANSensor.fromJson(data);
      return sensor;
    } else {
      debugPrint(response.toString());
      return LANSensor(
          return_value: 'N/A',
          id: "id",
          name: "name",
          hardware: "hardware",
          connected: "connected");
    }
  }

  Future<bool> SwitchControllerMode(int status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // apiLanEndpoint = await prefs.getString(prefs_ApiLanEndpoint)!;
    String apiLanEndpoint = "http://" + configModel.espapiendpoint;
    int Mode;
    if (status == 2)
      Mode = 2;
    else if (status == 1)
      Mode = 1;
    else
      Mode = 0;

    bool isSuccess = false;

    final response = await http.get(Uri.parse(
        apiLanEndpoint + '/setControllerMode?param=' + Mode.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send command.');
    }
    return isSuccess;
  }

  Future<bool> SwitchApplicationMode(int status) async {
    String Mode;
    bool isSuccess = false;
    //  String sensorid =  FetchSensorData( "Application Mode") as String;
    String apiLanEndpoint = "http://" + configModel.espapiendpoint;
    if (status == 0)
      Mode = "MRS";
    else
      Mode = "AMF";

    final response = await http.get(Uri.parse(
        apiLanEndpoint + '/setApplicationMode?param=' + Mode.toString()));

    if (response.statusCode == 200) {
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update sensor');
    }
    return isSuccess;
  }

  Future<bool> SwitchMCBMode(bool status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // apiLanEndpoint = await prefs.getString(prefs_ApiLanEndpoint)!;
    String apiLanEndpoint = "http://" + configModel.espapiendpoint;
    int Mode;
    if (status)
      Mode = 1;
    else
      Mode = 0;

    bool isSuccess = false;
    final response = await http.get(
        Uri.parse(apiLanEndpoint + '/setMCBMode?param=' + Mode.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send command.');
    }

    return isSuccess;
  }

  Future<bool> SwitchGCBMode(bool status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // apiLanEndpoint = await prefs.getString(prefs_ApiLanEndpoint)!;
    String apiLanEndpoint = "http://" + configModel.espapiendpoint;
    int Mode;
    if (status)
      Mode = 1;
    else
      Mode = 0;

    bool isSuccess = false;
    final response = await http.get(
        Uri.parse(apiLanEndpoint + '/setGCBMode?param=' + Mode.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send command.');
    }

    return isSuccess;
  }

  Future<bool> SwitchAlarmClear(bool status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // apiLanEndpoint = await prefs.getString(prefs_ApiLanEndpoint)!;
    String apiLanEndpoint = "http://" + configModel.espapiendpoint;
    double alarmclearvalue;
    bool isSuccess = false;
    if (status)
      alarmclearvalue = 1;
    else
      alarmclearvalue = 0;

    final response = await http.get(Uri.parse(apiLanEndpoint +
        '/setFaultReset?params=' +
        alarmclearvalue.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send command.');
    }

    return isSuccess;
  }

  Future<bool> TurnGeneratorEngineOnOff(bool status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // apiLanEndpoint = await prefs.getString(prefs_ApiLanEndpoint)!;
    String apiLanEndpoint = "http://" + configModel.espapiendpoint;
    int Command;
    if (status)
      Command = 1;
    else
      Command = 0;
    bool isSuccess = false;
    final response = await http.get(Uri.parse(
        apiLanEndpoint + '/setEngineMode?param=' + Command.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send command.');
    }
    return isSuccess;
  }
}
