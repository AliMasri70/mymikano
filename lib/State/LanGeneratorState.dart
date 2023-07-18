import 'package:flutter/material.dart';
import 'package:mymikano_app/models/CloudSensor_Model.dart';
import 'package:mymikano_app/models/LanSensor_Model.dart';
import 'package:mymikano_app/services/LanDashboard_Service.dart';

class LanGeneratorState extends ChangeNotifier {
  late LanDashBoard_Service LanService;
  //LanDashBoard_Service LanService = LanDashBoard_Service();
  final Map EnState = {
    'Init': 0,
    'Ready': 1,
    'NotReady': 2,
    'Prestart': 3,
    'Cranking': 4,
    'Pause': 5,
    'Starting': 6,
    'Running': 7,
    'Loaded': 8,
    'Softunld': 9,
    'Cooling': 10,
    'Stop': 11,
    'Shutdown': 12,
    'Ventil': 13,
    'EmergMan': 14,
    'Softload': 15,
    'WaitStop': 16,
    'SDVentil': 17
  };
  final Map BrState = {
    'Init': 0,
    'BrksOff': 1,
    'IslOper': 2,
    'MainsOper': 3,
    'ParalOper': 4,
    'RevSync': 5,
    'Synchro': 6,
    'MainsFlt': 7,
    'ValidFlt': 8,
    'MainsRet': 9,
    'MultIslOp': 10,
    'MultParOp': 11,
    'EmergMan': 12
  };
  LANSensor EngineState = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor BreakState = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor RunningHours = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  String Hours = "10";
  String Minutes = "10";
  LANSensor Rpm = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor ApplicationMode = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor BatteryVoltage = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor OilPressure = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor CoolantTemp = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor FuelLevel = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor GeneratorVoltage = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor GeneratorFrequency = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor GeneratorLoad = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor ControllerMode = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor MCBMode = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor GCBMode = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor Engine = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor LoadAL1 = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor LoadAL2 = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor LoadAL3 = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor generatorL1N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor generatorL2N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor generatorL3N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor mainsvoltageL1N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor mainsvoltageL2N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor mainsvoltageL3N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor mainsFrequency = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor generatorFrequency = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor LoadPowerFactor = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor ReadyToLoad = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor MainsHealthy = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor MCBFeedback = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor GCBFeedback = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor mainsvoltageL1L2N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor mainsvoltageL1L3N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor mainsvoltageL2L3N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor generatorvoltageL1L2N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor generatorvoltageL1L3N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor generatorvoltageL2L3N = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor LoadKvr = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor LoadKWh = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor LoadKVA = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  LANSensor TotalFuelConsumption = LANSensor(
      return_value: 10,
      id: "Error",
      name: "Error",
      hardware: "Error",
      connected: "Error");
  int ControllerModeStatus = 1;
  bool MCBModeStatus = false;
  bool PowerStatus = false;
  int AppModeStatus = 0;
  late bool MCBisAuto = MCBModeStatus;
  bool isIO = false;
  bool isGCB = false;
  bool isReadyToLoad = false;
  bool MCBFeedbackState = false;
  bool GCBFeedbackState = false;
  bool MainsHealthyStatus = false;
  bool alarmsclear = false;

  var powerStatusValue = [
    "Init",
    "Ready",
    "NotReady",
    "Prestart",
    "Cranking",
    "Pause",
    "Starting",
    "Running",
    "Loaded",
    "Soft unld",
    "Cooling",
    "Stop",
    "Shutdown",
    "Ventil",
    "EmergMan",
    "Soft load",
    "WaitStop",
    "SDVentil"
  ];

  changeControllerModeStatus(value) async {
    bool isSuccess = await LanService.SwitchControllerMode(value);
    if (isSuccess == true) {
      ControllerModeStatus = value;
      notifyListeners();
    }
  }

  changeAlarmClear(value) async {
    bool isSuccess = await LanService.SwitchAlarmClear(value);
    if (isSuccess == true) {
      alarmsclear = value;
      notifyListeners();
    }
  }

  changeIsIO(value) async {
    bool isSuccess = await LanService.TurnGeneratorEngineOnOff(value);
    if (isSuccess == true) {
      isIO = value;
      notifyListeners();
    }
  }

  changeIsGCB(value) async {
    bool isSuccess = await LanService.SwitchGCBMode(value);
    if (isSuccess == true) {
      isGCB = value;
      notifyListeners();
    }
  }

  changeMCBModeStatus(value) async {
    bool isSuccess = await LanService.SwitchMCBMode(value);
    if (isSuccess == true) {
      MCBModeStatus = value;
      notifyListeners();
    }
  }

  Future<bool> FetchData() async {
    try {
      EngineState = await LanService.FetchSensorData("EngineState");
      BreakState = await LanService.FetchSensorData("BreakerState");
      RunningHours = await LanService.FetchSensorData("RunningHours");
      Hours = RunningHours.return_value.toString();
      Minutes = RunningHours.return_value.toString() != "Restricted"
          ? ((double.parse(RunningHours.return_value.toString()) -
                      double.parse(Hours)) *
                  60)
              .round()
              .toString()
          : "Restricted";
      ApplicationMode = await LanService.FetchSensorData("ApplicationMode");

      Rpm = await LanService.FetchSensorData("RPM");
      BatteryVoltage = await LanService.FetchSensorData("BatteryVoltage");
      OilPressure = await LanService.FetchSensorData("OilPressure");
      CoolantTemp = await LanService.FetchSensorData("CoolantTemp");
      FuelLevel = await LanService.FetchSensorData("TotalFuelConsumption");
      GeneratorVoltage = await LanService.FetchSensorData("OutputVoltage");
      GeneratorFrequency = await LanService.FetchSensorData("BreakerState");
      GeneratorLoad = await LanService.FetchSensorData("Load");
      ControllerMode = await LanService.FetchSensorData("ControllerMode");
      MCBMode = await LanService.FetchSensorData("MCB");
      GCBMode = await LanService.FetchSensorData("GCB");
      Engine = await LanService.FetchSensorData("EngineState");
      LoadAL1 = await LanService.FetchSensorData("LoadAL1");
      LoadAL2 = await LanService.FetchSensorData("LoadAL2");
      LoadAL3 = await LanService.FetchSensorData("LoadAL3");
      LoadKvr = await LanService.FetchSensorData("LoadKvr");
      LoadKWh = await LanService.FetchSensorData("LoadKWh");
      LoadKVA = await LanService.FetchSensorData("LoadKVA");
      generatorL1N = await LanService.FetchSensorData("GenVL1N");
      generatorL2N = await LanService.FetchSensorData("GenVL2N");
      generatorL3N = await LanService.FetchSensorData("GenVL3N");
      mainsvoltageL1N = await LanService.FetchSensorData("MainVL1N");
      mainsvoltageL2N = await LanService.FetchSensorData("MainVL2N");
      mainsvoltageL3N = await LanService.FetchSensorData("MainVL3N");
      mainsFrequency = await LanService.FetchSensorData("MainFrequency");
      generatorFrequency = await LanService.FetchSensorData("Frequency");
      LoadPowerFactor = await LanService.FetchSensorData("PowerFactor");
      ReadyToLoad = await LanService.FetchSensorData("ReadyToLoad");
      MainsHealthy = await LanService.FetchSensorData("MainsHealthy");
      MCBFeedback = await LanService.FetchSensorData("MCBFeedback");
      GCBFeedback = await LanService.FetchSensorData("GCBFeedback");
      mainsvoltageL1L2N = await LanService.FetchSensorData("MainVL1L2N");
      mainsvoltageL1L3N = await LanService.FetchSensorData("MainVL3L1N");
      mainsvoltageL2L3N = await LanService.FetchSensorData("MainVL2L3N");
      generatorvoltageL1L2N = await LanService.FetchSensorData("GenVL1L2N");
      generatorvoltageL1L3N = await LanService.FetchSensorData("GenVL3L1N");
      generatorvoltageL2L3N = await LanService.FetchSensorData("GenVL2L3N");
      if (ControllerMode.return_value == 2)
        ControllerModeStatus = 2;
      else if (ControllerMode.return_value == 1)
        ControllerModeStatus = 1;
      else if (ControllerMode.return_value == 0) ControllerModeStatus = 0;

      if (MCBMode.return_value == 1)
        MCBModeStatus = true;
      else
        MCBModeStatus = false;

      if (GCBMode.return_value == 1)
        isGCB = true;
      else
        isGCB = false;

      if (Engine.return_value == 8 || Engine.return_value == 7)
        isIO = true;
      else
        isIO = false;
      if (MCBFeedback.return_value == 1)
        MCBFeedbackState = true;
      else
        MCBFeedbackState = false;
      if (GCBFeedback.return_value == 1)
        GCBFeedbackState = true;
      else
        GCBFeedbackState = false;
      if (ReadyToLoad.return_value == 1)
        isReadyToLoad = true;
      else
        isReadyToLoad = false;
      if (EngineState.return_value == 8 || EngineState.return_value == 7)
        PowerStatus = true;
      else
        PowerStatus = false;

      if (ApplicationMode.return_value == 1.00) {
        AppModeStatus = 0;
      } else {
        AppModeStatus = 1;
      }

      notifyListeners();
      return true;
    } on Exception {
      return false;
    }
  }

  changeAppModeStatus(value) async {
    bool isSuccess = await LanService.SwitchApplicationMode(value);
    print("isSuccess: " + isSuccess.toString());
    if (isSuccess == true) {
      print("isSuccess: " + value.toString());

      AppModeStatus = value;
      notifyListeners();
    }
  }

  Future<void> ReinitiateLanService() async {
    LanService = new LanDashBoard_Service();
  }
}
