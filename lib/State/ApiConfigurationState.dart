import 'package:flutter/material.dart';
import 'package:mymikano_app/models/GeneratorModel.dart';
import 'package:mymikano_app/services/ApiConfigurationService.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:nb_utils/nb_utils.dart';

class ApiConfigurationState extends ChangeNotifier {
  bool DashBoardFirstTimeAccess = true;
  bool isSuccess = false;
  bool cloudModeValue = false;
  bool loading = false;
  String option = 'lan';
  String Message = '';
  String chosenGeneratorId = '';
  var chosenSSID;
  var chosenGeneratorName;
  int RefreshRate = 1;
  int cloudMode = 0;
  String password = '';
  String cloudUsername = '';
  bool cloudConfigValue = true;
  String cloudPassword = '';
  String apiLanEndpoint = '';
  String DeviceToken = '';
  List<String> ssidList = [];
  List<String> generatorNameList = [];
  List<Generator> gens = [];
  ApiConfigurationService service = new ApiConfigurationService();

  ApiConfigurationState() {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DashBoardFirstTimeAccess = prefs.getBool(prefs_DashboardFirstTimeAccess)!;
    option = prefs.getString(prefs_ApiConfigurationOption)!;
    RefreshRate = prefs.getInt(prefs_RefreshRate)!;
    password = prefs.getString(prefs_Password)!;   
    chosenSSID = prefs.getString(prefs_SSID);
    cloudUsername = prefs.getString(prefs_CloudUsername)!;
    cloudPassword = prefs.getString(prefs_CloudPassword)!;
    cloudMode = prefs.getInt(prefs_CloudMode)!;
    chosenGeneratorId = prefs.getString(prefs_GeneratorId)!;
    apiLanEndpoint = prefs.getString(prefs_ApiLanEndpoint)!;
    notifyListeners();
  }

  void getGeneratorIds(clouduser, cloudpass) async {
    generatorNameList.clear();
    List<Generator> generators =
        await service.getGeneratorsOfUser(clouduser, cloudpass, DeviceToken);
    // generators.forEach((element) {
    //   generatorNameList.add(element.name);
    // });
    gens = generators;
    //generatorNameList.add(generators.elementAt(0).name);
    if (gens.isEmpty) {
      isSuccess = false;
      Message = 'Invalid input, try again.';
    } else {
      generatorNameList.add(gens.elementAt(0).name);
      isSuccess = true;
      Message = 'Generators fetched successfully.';
    }
    notifyListeners();
  }

  void changeRefreshRate(int rate) {
    RefreshRate = rate;
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
    // notifyListeners();
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

  void resetPreferences() async {
    clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(prefs_DashboardFirstTimeAccess, true);   
    prefs.remove(prefs_SSID);
    prefs.remove(prefs_Password);
    prefs.remove(prefs_RefreshRate); 
    prefs.remove(prefs_CloudUsername);
    prefs.remove(prefs_CloudPassword);
    prefs.remove(prefs_CloudMode);
    prefs.remove(prefs_GeneratorId);
    service.resetESP(prefs.getString(prefs_ApiLanEndpoint).toString());
    prefs.remove(prefs_ApiLanEndpoint);
    notifyListeners();
  }

  Future<void> setpref(ssid, password, int refreshRate, cloudUsername,
      cloudPassword, int cloudMode, generatorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefs_SSID, ssid);
    prefs.setString(prefs_Password, password);
    prefs.setInt(prefs_RefreshRate, refreshRate);
    prefs.setString(prefs_CloudUsername, cloudUsername);
    prefs.setString(prefs_CloudPassword, cloudPassword);
    prefs.setInt(prefs_CloudMode, cloudMode);
    prefs.setString(prefs_GeneratorId, generatorId);
  }

  void setApiLanEndpoint(String apiEndpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefs_ApiLanEndpoint, apiEndpoint);
  }
}
