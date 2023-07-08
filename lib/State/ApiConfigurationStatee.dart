import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mymikano_app/models/GeneratorModel.dart';
import 'package:mymikano_app/services/ApiConfigurationService.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/ConfigurationModel.dart';

class ApiConfigurationStatee extends ChangeNotifier {
  bool DashBoardFirstTimeAccess = true;
  bool isSuccess = false;
  bool cloudModeValue = false;
  bool loading = false;
  String option = 'lan';
  String Message = '';
  String apiEndpointMessage = '';
  String chosenGeneratorId = '';
  var chosenSSID;
  var chosenGeneratorName;
  int RefreshRate =1;
  String ControllerAddress = '';
  int cloudMode = 0;
  String password = '';
  String cloudUsername = '';
  bool cloudConfigValue = true;
  String cloudPassword = '';
  String apiLanEndpoint = '';
  List<String> ssidList = [];
  List<String> generatorNameList = [];
  List<Generator> gens = [];
  String DeviceToken = '';
  String userID = '';
  ApiConfigurationService service = new ApiConfigurationService();

  ///the list of configurations//
  late ConfigurationModel configModel;
  late List<ConfigurationModel> configsList;  

  ApiConfigurationStatee() {
    //if(!DashBoardFirstTimeAccess)
    update();
  }

  void Loading(value) {
    loading = value;
    notifyListeners();
  }

  void ChangeMode(String value) async {
    option = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefs_ApiConfigurationOption, option);
    debugPrint(prefs.getString(prefs_ApiConfigurationOption));
    if (option == 'lan') {
      cloudMode = 0;
    }
    if (option == 'cloud') {
      cloudMode = 1;
    }

    debugPrint("cloudmode: " + cloudMode.toString());
    notifyListeners();
  }

  void isNotFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.DashBoardFirstTimeAccess = false;
    prefs.setBool(prefs_DashboardFirstTimeAccess, false); 
    notifyListeners();
  }  

  void update() async {
    await getListConfigurationModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
     bool dashboardaccess = prefs.getBool(prefs_DashboardFirstTimeAccess)!;
    if (dashboardaccess == false) {
      await getSelectedConfigurationModel();
      await getListGenerators();
      generatorNameList = prefs.getStringList("generatorNameList")!;
      chosenGeneratorName = generatorNameList.elementAt(0);
      
    }
    cloudUsername = prefs.getString(prefs_CloudUsername).toString(); 
    cloudPassword = prefs.getString(prefs_CloudPassword).toString(); 
    userID = prefs.getString("IotUserID").toString();
     print(userID);
    notifyListeners();  
  }

  Future<void> getGeneratorIds(clouduser, cloudpass) async {
    generatorNameList.clear();
 SharedPreferences pref =
 await SharedPreferences.getInstance();
  DeviceToken = pref.getString("DeviceToken").toString();
    List<Generator> generators =
        await service.getGeneratorsOfUser(clouduser, cloudpass,DeviceToken);   
    gens = generators;  
    //generatorNameList.add(generators.elementAt(0).name);
    if (gens.isEmpty) {
      isSuccess = false;
      Message = 'Invalid input, try again.';
    } else {
      gens.forEach((element) {
        generatorNameList.add(element.name);
      });
      chosenGeneratorName = generatorNameList.elementAt(0);
      chosenGeneratorId = gens.elementAt(0).generatorId;
      isSuccess = true;
      Message = 'Generators fetched successfully.';
    }
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("generatorNameList", generatorNameList);
    String gensList = jsonEncode(gens);
    await prefs.setString('Generators', gensList);
  }

  void changeRefreshRate(int rate) {
    RefreshRate = rate;
    notifyListeners();
  }

  void changeControllerAddress(String Address) {
    ControllerAddress = Address;
    notifyListeners();
  }

  void changeCloudUsername(username) {
    cloudUsername = username;
    notifyListeners();
  }

  void changeCloudConfigValue(val) {
    cloudConfigValue = val;
    notifyListeners();
    //return cloudConfigValue;
  }

  void changeApiLanEndpoint(apiendpoint) {
    apiLanEndpoint = apiendpoint;
    notifyListeners();   
  }

  void changeCloudPassword(password) {
    cloudPassword = password;
    notifyListeners();
  }

  void ShowSSIDs() async {
    ssidList.clear();
    ssidList = await service.getSSIDList();
    // ssidList = [
    //   'ssid1',
    //   'ssid2',
    //   'ssid3',
    //   'ssid4',
    //   'ssid5',
    // ];
    notifyListeners();
  }

  void ComboBoxState(String splitted) {
    chosenSSID = splitted;
    notifyListeners();
  }

  void ChooseGeneratorName(String splitted) {
    chosenGeneratorName = splitted;
    notifyListeners();
  }

  void setChosenGeneratorId(String id) {
    chosenGeneratorId = id;
    notifyListeners();
  }

  void clear() {
    DashBoardFirstTimeAccess = true;
    isSuccess = false;
    loading = false;
    Message = '';
    cloudModeValue = false;
    option = 'lan';
    chosenSSID = null;
    chosenGeneratorId = '';
    chosenGeneratorName = null;
    RefreshRate = 1;
    cloudMode = 0;
    password = '';
    cloudUsername = '';
    apiLanEndpoint = '';
    cloudPassword = '';
    ssidList = [];
    generatorNameList = [];
    notifyListeners();
  }

  Future<void> saveCloudUser(cloudUsername, cloudPassword) async {
    this.cloudUsername = cloudUsername; 
    this.cloudPassword = cloudPassword; 
    this.userID = userID;
    SharedPreferences prefs = await SharedPreferences.getInstance();   
    prefs.setString(prefs_CloudUsername, cloudUsername);
    prefs.setString(prefs_CloudPassword, cloudPassword);
   
  }

  void setApiLanEndpoint(String apiEndpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefs_ApiLanEndpoint, apiEndpoint);  
  }

  //added newly by youssef for multiple gens//
  Future<ConfigurationModel> getSelectedConfigurationModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    if (prefs.getString('Configurations') == null)
      configModel = ConfigurationModel(
          ssid: "",
          password: "",
          refreshRate: 0,
          cloudUser: "",
          cloudPassword: "",
          cloudMode: 0,
          generatorId: "",
          generatorName: "",
          espapiendpoint: "",
          controllerAddress: "");
    else {
      List<ConfigurationModel> configsList =
          (json.decode(prefs.getString('Configurations').toString()) as List)
              .map((data) => ConfigurationModel.fromJson(data))
              .toList();
      ConfigurationModel config = ConfigurationModel.fromJson(
          json.decode(prefs.getString('SelectedConfigurationModel')!));
      configModel = config;
    }
    return configModel;
  }

  Future<List<ConfigurationModel>> getListConfigurationModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    String test = prefs.getString('Configurations').toString();
    if (prefs.getString('Configurations') == null)
      configsList = [];
    else {
      configsList =
          (json.decode(prefs.getString('Configurations').toString()) as List)
              .map((data) => ConfigurationModel.fromJson(data))
              .toList();
    }
    // ConfigurationModel config = ConfigurationModel.fromJson(json.decode(prefs.getString('SelectedConfigurationModel')!));
    // configModel=config;
    return configsList;
  }

  Future<List<Generator>> getListGenerators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cloudUsername = prefs.getString(prefs_CloudUsername)!;
    // String cloudPassword = prefs.getString(prefs_CloudPassword)!;
    // GeneratorID = prefs.getString(prefs_GeneratorId)!;
    if (prefs.getString('Generators') == null)
      gens = [];
    else {
      gens = (json.decode(prefs.getString('Generators').toString()) as List)
          .map((data) => Generator.fromJson(data))
          .toList();
    }
    // ConfigurationModel config = ConfigurationModel.fromJson(json.decode(prefs.getString('SelectedConfigurationModel')!));
    // configModel=config;
    return gens;
  }

  void resetPreferences(String Url) async {
    service.resetESP(Url);
    notifyListeners();
  }
}
