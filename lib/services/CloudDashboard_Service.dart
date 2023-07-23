import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mymikano_app/models/CloudSensor_Model.dart';
import 'package:mymikano_app/models/ConfigurationModel.dart';
import 'package:mymikano_app/models/Sensor_Model.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:nb_utils/nb_utils.dart';

class CloudDashBoard_Service {
  //final String ApiEndPoint;
  //String GeneratorID = "";
  //aded by youssef//
  late final ConfigurationModel configModel;

  CloudDashBoard_Service() {
    getSelectedConfigurationModel();
    //configModel=model;
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

  //fin added by youssef//

  late List<CloudSensor> cloudsensors = [];

  Future<List<CloudSensor>> FetchData() async {
    final responseAuth = await http.post(Uri.parse(cloudIotMautoAuthUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': configModel.cloudUser,
          'password': configModel.cloudPassword,
        }));

    final token = jsonDecode((responseAuth.body))['token'];

    final response = await http.get(
        Uri.parse(/*ApiEndPoint + GeneratorID*/ cloudIotMautoSensorsUrl +
            configModel.generatorId),
        headers: {'Authorization': 'Bearer ' + token.toString()});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      data['nominalLoadkW'];
      // print(data['nominalLoadkW']);
      // debugPrint("resssssssss: " + data['values'].toString());
      // printLongString(data['values'].toString());
      CloudSensor nominalLoadkW = CloudSensor(
          sensorID: "0000-1111",
          sensorName: "nominalLoadkW",
          value: data['nominalLoadkW'],
          unit: '',
          timeStamp: '');
      cloudsensors =
          (data['values'] as List).map((s) => CloudSensor.fromJson(s)).toList();
      cloudsensors.add(nominalLoadkW);

      return cloudsensors;
    } else {
      debugPrint(response.toString());
      // printLongString(response.toString());

      List<CloudSensor> emptylist = [];
      return emptylist;
    }
  }

  Future<bool> SwitchControllerMode(int status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    // List<ConfigurationModel> configsList = (json.decode(prefs.getString('Configurations')!) as List)
    //     .map((data) => ConfigurationModel.fromJson(data))
    //     .toList();
    // ConfigurationModel configModel=configsList.last;
    String Mode;
    bool isSuccess = false;

    if (status == 2)
      Mode = "AUTO";
    else if (status == 1)
      Mode = "MAN";
    else
      Mode = "OFF";

    final responseAuth = await http.post(Uri.parse(cloudIotMautoAuthUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': configModel.cloudUser,
          'password': configModel.cloudPassword,
        }));
    final token = jsonDecode((responseAuth.body))['token'];

    final response = await http.post(
      Uri.parse(cloudIotMautoSensorsUrl + configModel.generatorId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: jsonEncode([
        <String, String>{
          'generatorSensorID': dotenv.env['ControllerMode_id'].toString(),
          'value': Mode.toString(),
          //'timeStamp':DateTime.now().toString()
          'timeStamp': DateTime.now().toIso8601String()
        }
      ]),
    );

    if (response.statusCode == 200) {
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update sensor');
    }
    return isSuccess;
  }

////////////////

  Future<bool> SwitchApplicationMode(int status) async {
    String Mode;
    bool isSuccess = false;
    // String sensorid = FindSensorr(cloudsensors, "Application Mode");

    print("sensor.sensorID change: " +
        dotenv.env['ApplicationMode_id'].toString());
    // Fluttertoast.showToast(
    //     msg: "sensor.sensorID change: " +dotenv.env['ApplicationMode_id'].toString(),
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
    if (status == 0)
      Mode = "MRS";
    else
      Mode = "AMF";

    final responseAuth = await http.post(Uri.parse(cloudIotMautoAuthUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': configModel.cloudUser,
          'password': configModel.cloudPassword,
        }));
    final token = jsonDecode((responseAuth.body))['token'];

    final response = await http.post(
      Uri.parse(cloudIotMautoSensorsUrl + configModel.generatorId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: jsonEncode([
        <String, String>{
          'generatorSensorID': dotenv.env['ApplicationMode_id'].toString(),
          'value': Mode.toString(),
          //'timeStamp':DateTime.now().toString()
          'timeStamp': DateTime.now().toIso8601String()
        }
      ]),
    );

    if (response.statusCode == 200) {
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update sensor');
    }
    return isSuccess;
  }

  String FindSensorr(List<CloudSensor> cloudsensors, String param) {
    final index = cloudsensors
        .indexWhere((element) => element.sensorName.trim() == param.trim());
    CloudSensor sensor = cloudsensors.elementAt(index);

    return sensor.sensorID;
  }
///////////

  Future<bool> SwitchAlarmClear(bool status) async {
    double alarmclearvalue;
    bool isSuccess = false;
    if (status)
      alarmclearvalue = 1;
    else
      alarmclearvalue = 0;
    final responseAuth = await http.post(Uri.parse(cloudIotMautoAuthUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': configModel.cloudUser,
          'password': configModel.cloudPassword,
        }));
    final token = jsonDecode((responseAuth.body))['token'];

    final response = await http.post(
      Uri.parse(cloudIotMautoSensorsUrl + configModel.generatorId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: jsonEncode([
        <String, String>{
          'generatorSensorID': dotenv.env['AlarmClear_id'].toString(),
          'value': alarmclearvalue.toString(),
          'timeStamp': DateTime.now().toIso8601String()
        }
      ]),
    );
    if (response.statusCode == 200) {
      isSuccess = true;
    } else {
      throw Exception('Failed to update sensor');
    }
    return isSuccess;
  }

  Future<bool> SwitchMCBMode(bool status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    // List<ConfigurationModel> configsList = (json.decode(prefs.getString('Configurations')!) as List)
    //     .map((data) => ConfigurationModel.fromJson(data))
    //     .toList();
    // ConfigurationModel configModel=configsList.last;
    String Mode;
    bool isSuccess = false;

    if (status)
      Mode = "Close-On";
    else
      Mode = "Close-Off";
    final responseAuth = await http.post(Uri.parse(cloudIotMautoAuthUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': configModel.cloudUser,
          'password': configModel.cloudPassword,
        }));
    final token = jsonDecode((responseAuth.body))['token'];

    final response = await http.post(
      Uri.parse(cloudIotMautoSensorsUrl + configModel.generatorId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: jsonEncode([
        <String, String>{
          'generatorSensorID': dotenv.env['MCBMode_id'].toString(),
          'value': Mode.toString(),
          //'timeStamp':DateTime.now().toString()
          'timeStamp': DateTime.now().toIso8601String()
        }
      ]),
    );

    if (response.statusCode == 200) {
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update sensor');
    }
    return isSuccess;
  }

  Future<bool> SwitchGCBMode(bool status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    // List<ConfigurationModel> configsList = (json.decode(prefs.getString('Configurations')!) as List)
    //     .map((data) => ConfigurationModel.fromJson(data))
    //     .toList();
    // ConfigurationModel configModel=configsList.last;
    String Mode;
    bool isSuccess = false;

    if (status)
      Mode = "Close-On";
    else
      Mode = "Close-Off";
    final responseAuth = await http.post(Uri.parse(cloudIotMautoAuthUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': configModel.cloudUser,
          'password': configModel.cloudPassword,
        }));
    final token = jsonDecode((responseAuth.body))['token'];

    final response = await http.post(
      Uri.parse(cloudIotMautoSensorsUrl + configModel.generatorId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: jsonEncode([
        <String, String>{
          'generatorSensorID': dotenv.env['GCB_id'].toString(),
          'value': Mode.toString(),
          //'timeStamp':DateTime.now().toString()
          'timeStamp': DateTime.now().toIso8601String()
        }
      ]),
    );

    if (response.statusCode == 200) {
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update sensor');
    }
    return isSuccess;
  }

  Future<bool> TurnGeneratorEngineOnOff(bool status) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    // List<ConfigurationModel> configsList = (json.decode(prefs.getString('Configurations')!) as List)
    //     .map((data) => ConfigurationModel.fromJson(data))
    //     .toList();
    // ConfigurationModel configModel=configsList.last;
    String Command;
    bool isSuccess = false;
    if (status)
      Command = "ON";
    else
      Command = "OFF";

    final responseAuth = await http.post(Uri.parse(cloudIotMautoAuthUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': configModel.cloudUser,
          'password': configModel.cloudPassword,
        }));
    final token = jsonDecode((responseAuth.body))['token'];

    final response = await http.post(
      Uri.parse(cloudIotMautoSensorsUrl + configModel.generatorId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: jsonEncode([
        <String, String>{
          'generatorSensorID': dotenv.env['EngineOnOff_id'].toString(),
          'value': Command.toString(),
          //'timeStamp':DateTime.now().toString()
          'timeStamp': DateTime.now().toIso8601String(),
        }
      ]),
    );
    if (response.statusCode == 200) {
      isSuccess = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update sensor');
    }
    return isSuccess;
  }
}

void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((RegExpMatch match) => print(match.group(0)));
}
