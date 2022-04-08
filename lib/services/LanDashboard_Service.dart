import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mymikano_app/models/LanSensor_Model.dart';
import 'package:mymikano_app/utils/appsettings.dart';

class LanDashBoard_Service {
  //final String ApiEndPoint;
  LanDashBoard_Service(/*{required this.ApiEndPoint}*/);
  Future<LANSensor> FetchSensorData(String param) async {
    final response =
        await http.get(Uri.parse(lanESPUrl + '/getValue?params=' + param));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      LANSensor sensor = LANSensor.fromJson(data);
      return sensor;
    } else {
      print(response);
      return LANSensor(
          return_value: 0,
          id: "id",
          name: "name",
          hardware: "hardware",
          connected: "connected");
    }
  }

  Future<String> SwitchControllerMode(bool status) async {
    int Mode;
    if (status)
      Mode = 2;
    else
      Mode = 1;
    final response = await http.get(
        Uri.parse(lanESPUrl + '/setControllerMode?params=' + Mode.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return (response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send command.');
    }
  }

  Future<String> SwitchMCBMode(bool status) async {
    int Mode;
    if (status)
      Mode = 1;
    else
      Mode = 0;
    final response = await http
        .get(Uri.parse(lanESPUrl + '/setMCBMode?params=' + Mode.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return (response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send command.');
    }
  }

  Future<String> TurnGeneratorOnOff(bool status) async {
    int Command;
    if (status)
      Command = 0;
    else
      Command = 1;
    final response = await http.get(
        Uri.parse(lanESPUrl + '/setEngineMode?params=' + Command.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return (response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send command.');
    }
  }
}
