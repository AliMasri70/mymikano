import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mymikano_app/models/CloudSensor_Model.dart';
import 'package:mymikano_app/services/CloudDashboard_Service.dart';

class CloudGeneratorState extends ChangeNotifier {
  late CloudDashBoard_Service cloudService;

  //CloudDashBoard_Service cloudService=new CloudDashBoard_Service();
  CloudSensor EngineState = CloudSensor(
    sensorID: "Error",
    sensorName: "Error",
    value: "100",
    unit: "Error",
    timeStamp: "Error",
  );
  CloudSensor BreakState = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor RunningHours = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  late String Hours;
  late String Minutes;
  CloudSensor Rpm = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor BatteryVoltage = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor OilPressure = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor CoolantTemp = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor FuelLevel = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor GeneratorVoltage = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor GeneratorFrequency = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor GeneratorLoad = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor ControllerMode = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor ApplicationMode = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor MCBMode = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor GCBMode = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor Engine = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor nominalLoadkW = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor LoadAL1 = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor LoadAL2 = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor LoadAL3 = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor generatorL1N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor generatorL2N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor generatorL3N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor mainsvoltageL1N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor mainsvoltageL2N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor mainsvoltageL3N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor mainsvoltageL1L2N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor mainsvoltageL1L3N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor mainsvoltageL2L3N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor generatorvoltageL1L2N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor generatorvoltageL1L3N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor generatorvoltageL2L3N = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor mainsFrequency = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor LoadPowerFactor = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor ReadyToLoad = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor MainsHealthy = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor MCBFeedback = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor GCBFeedback = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor AlarmClear = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor LoadKva = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor LoadKvar = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor LoadKWh = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  CloudSensor TotalFuelConsumption = CloudSensor(
      sensorID: "Error",
      sensorName: "Error",
      value: "100",
      unit: "Error",
      timeStamp: "Error");
  int ControllerModeStatus = 1;
  bool MCBModeStatus = false;
  bool AppModeStatus = false;
  bool PowerStatus = false;
  bool isGCB = false;
  bool isIO = false;
  bool isReadyToLoad = false;
  bool MCBFeedbackState = false;
  bool GCBFeedbackState = false;
  bool MainsHealthyStatus = false;
  bool alarmsclear = false;
  changeControllerModeStatus(value) async {
    bool isSuccess = await cloudService.SwitchControllerMode(value);
    if (isSuccess == true) {
      ControllerModeStatus = value;
      notifyListeners();
    }
  }

  changeAlarmClear(value) async {
    bool isSuccess = await cloudService.SwitchAlarmClear(value);
    if (isSuccess == true) {
      alarmsclear = value;
      notifyListeners();
    }
  }

  changeIsIO(value) async {
    bool isSuccess = await cloudService.TurnGeneratorEngineOnOff(value);
    if (isSuccess == true) {
      isIO = value;
      notifyListeners();
    }
  }

  changeIsGCB(value) async {
    bool isSuccess = await cloudService.SwitchGCBMode(value);
    if (isSuccess == true) {
      isGCB = value;
      notifyListeners();
    }
  }

  changeMCBModeStatus(value) async {
    bool isSuccess = await cloudService.SwitchMCBMode(value);
    if (isSuccess == true) {
      MCBModeStatus = value;
      notifyListeners();
    }
  }

  changeAppModeStatus(value) async {
    bool isSuccess = await cloudService.SwitchApplicationMode(value);
    if (isSuccess == true) {
      AppModeStatus = value;
      notifyListeners();
    }
  }

  Future<bool> FetchData() async {
    List<CloudSensor> cloudsensors = [];
    cloudsensors = await cloudService.FetchData();

    if (cloudsensors == []) {
      return false;
    } else {
      EngineState =
          FindSensor(cloudsensors, dotenv.env['EngineState_id'].toString());
      BreakState =
          FindSensor(cloudsensors, dotenv.env['BreakerState_id'].toString());
      RunningHours =
          FindSensor(cloudsensors, dotenv.env['RunningHours_id'].toString());
      // Hours = RunningHours.value.toString();
      // Minutes = RunningHours.value.toString() != "Restricted"
      //     ? ((double.parse(RunningHours.value.toString()) -
      //                 double.parse(Hours)) *
      //             60)
      //         .round()
      //         .toString()
      //     : "Restricted";
      Rpm = FindSensor(cloudsensors, dotenv.env['Rpm_id'].toString());
      BatteryVoltage =
          FindSensor(cloudsensors, dotenv.env['BatteryVoltage_id'].toString());
      OilPressure =
          FindSensor(cloudsensors, dotenv.env['OilPressure_id'].toString());
      CoolantTemp =
          FindSensor(cloudsensors, dotenv.env['CoolantTemp_id'].toString());
      FuelLevel =
          FindSensor(cloudsensors, dotenv.env['FuelLevel_id'].toString());
      GeneratorVoltage = FindSensor(
          cloudsensors, dotenv.env['GeneratorVoltage_id'].toString());
      //GeneratorFrequency = await DashModelView.GetGeneratorFrequency();
      GeneratorLoad =
          FindSensor(cloudsensors, dotenv.env['GeneratorLoad_id'].toString());

      ControllerMode =
          FindSensor(cloudsensors, dotenv.env['ControllerMode_id'].toString());
      ApplicationMode =
          FindSensor(cloudsensors, dotenv.env['ApplicationMode_id'].toString());

      MCBMode = FindSensor(cloudsensors, dotenv.env['MCBMode_id'].toString());
      GCBMode = FindSensor(cloudsensors, dotenv.env['GCB_id'].toString());
      Engine =
          FindSensor(cloudsensors, dotenv.env['EngineOnOff_id'].toString());
      nominalLoadkW =
          FindSensor(cloudsensors, dotenv.env['nominalLoad_id'].toString());

      LoadAL3 = FindSensor(cloudsensors, dotenv.env['Load_A_L3_id'].toString());
      LoadAL1 = FindSensor(cloudsensors, dotenv.env['Load_A_L1_id'].toString());
      LoadAL2 = FindSensor(cloudsensors, dotenv.env['Load_A_L2_id'].toString());
      generatorL1N =
          FindSensor(cloudsensors, dotenv.env['generator_L1-N_id'].toString());
      generatorL2N =
          FindSensor(cloudsensors, dotenv.env['generator_L2-N_id'].toString());
      generatorL3N =
          FindSensor(cloudsensors, dotenv.env['generator_L3-N_id'].toString());
      mainsvoltageL1N = FindSensor(
          cloudsensors, dotenv.env['mainsvoltage_L1-N_id'].toString());
      mainsvoltageL2N = FindSensor(
          cloudsensors, dotenv.env['mainsvoltage_L2-N_id'].toString());
      mainsvoltageL3N = FindSensor(
          cloudsensors, dotenv.env['mainsvoltage_L3-N_id'].toString());
      generatorL3N =
          FindSensor(cloudsensors, dotenv.env['generator_L3-N_id'].toString());
      GeneratorFrequency = FindSensor(
          cloudsensors, dotenv.env['GeneratorFrequency_id'].toString());
      mainsFrequency =
          FindSensor(cloudsensors, dotenv.env['Mains_Frequency_id'].toString());
      LoadPowerFactor = FindSensor(
          cloudsensors, dotenv.env['Load_Power_Factor_id'].toString());
      ReadyToLoad =
          FindSensor(cloudsensors, dotenv.env['ReadyToLoad_id'].toString());
      MainsHealthy =
          FindSensor(cloudsensors, dotenv.env['MainsHealthy_id'].toString());
      MCBFeedback =
          FindSensor(cloudsensors, dotenv.env['MCBFeedback_id'].toString());
      GCBFeedback =
          FindSensor(cloudsensors, dotenv.env['GCBFeedback_id'].toString());
      mainsvoltageL1L2N = FindSensor(
          cloudsensors, dotenv.env['mainsvoltage_L1-L2_id'].toString());
      mainsvoltageL1L3N = FindSensor(
          cloudsensors, dotenv.env['mainsvoltage_L1-L3_id'].toString());
      mainsvoltageL2L3N = FindSensor(
          cloudsensors, dotenv.env['mainsvoltage_L2-L3_id'].toString());
      generatorvoltageL1L2N = FindSensor(
          cloudsensors, dotenv.env['generatorvoltage_L1-L2_id'].toString());
      generatorvoltageL1L3N = FindSensor(
          cloudsensors, dotenv.env['generatorvoltage_L1-L3_id'].toString());
      generatorvoltageL2L3N = FindSensor(
          cloudsensors, dotenv.env['generatorvoltage_L2-L3_id'].toString());
      LoadKva = FindSensor(cloudsensors, dotenv.env['LoadKva_id'].toString());
      LoadKvar = FindSensor(cloudsensors, dotenv.env['LoadKvr_id'].toString());
      LoadKWh = FindSensor(cloudsensors, dotenv.env['LoadKWh_id'].toString());
      TotalFuelConsumption = FindSensor(
          cloudsensors, dotenv.env['TotalFuelConsumption_id'].toString());
      //for testing purposes only//
      //MCBMode = await DashModelView.GetControllerMode();

      if (ControllerMode.value == "AUTO")
        ControllerModeStatus = 2;
      else if (ControllerMode.value == "MAN")
        ControllerModeStatus = 1;
      else if (ControllerMode.value == "OFF") ControllerModeStatus = 0;

      //for testing purposes only
      //MCBMode.value="1";
      if (MCBMode.value == "Close-On")
        MCBModeStatus = true;
      else
        MCBModeStatus = false;

      if (GCBMode.value == "Close-On")
        isGCB = true;
      else
        isGCB = false;

      if (Engine.value == "ON")
        isIO = true;
      else
        isIO = false;

      if (EngineState.value == "Loaded" || EngineState.value == "Running")
        PowerStatus = true;
      else
        PowerStatus = false;
      if (MCBFeedback.value == '1')
        MCBFeedbackState = true;
      else
        MCBFeedbackState = false;
      if (GCBFeedback.value == 1)
        GCBFeedbackState = true;
      else
        GCBFeedbackState = false;
      if (MCBFeedback.value == 1)
        MCBFeedbackState = true;
      else
        MCBFeedbackState = false;
      if (GCBFeedback.value == 1)
        GCBFeedbackState = true;
      else
        GCBFeedbackState = false;
      if (ReadyToLoad.value == 1)
        isReadyToLoad = true;
      else
        isReadyToLoad = false;

      return true;
    }
  }

  CloudSensor FindSensor(List<CloudSensor> cloudsensors, String param) {
    final index =
        cloudsensors.indexWhere((element) => element.sensorID == param);
    CloudSensor sensor = cloudsensors.elementAt(index);

    return sensor;
  }

  Future<void> ReinitiateCloudService() async {
    cloudService = new CloudDashBoard_Service();
  }
}
