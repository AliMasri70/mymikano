import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymikano_app/models/ConfigurationModel.dart';
import 'package:mymikano_app/models/GeneratorModel.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/Dashboard/CloudDashboard_Index.dart';
import 'package:mymikano_app/views/screens/Dashboard/Dashboard_Index.dart';
import 'package:mymikano_app/views/screens/Dashboard/LanDashboard_Index.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../State/ApiConfigurationStatee.dart';
import '../../../services/LanNotificationServicee.dart';

class FetchGenerators extends StatefulWidget {
  final int RefreshRate;
  FetchGenerators({Key? key, required this.RefreshRate}) : super(key: key);

  @override
  _FetchGenerators createState() => _FetchGenerators();
}

class _FetchGenerators  extends State<FetchGenerators>{
  
  final ControllerAddressController = TextEditingController();
  final refreshRateController = TextEditingController();
  final passwordController = TextEditingController();
  final apiEndpointLanController = TextEditingController(text: lanESPUrl);
  late ConfigurationModel configModel;
  bool hasError = false;

  //late final List<ConfigurationModel> configsList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    
   
  }



  Widget build(BuildContext context) {
    return Consumer<ApiConfigurationStatee>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,

            elevation: 0,
          ),

                body: SafeArea(
              child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(children: [
                      TitleText(
                        title: lbl_API_Configuration,
                      ),
                    
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 120,
                        height: 120,
                        child: Image(
                          image: AssetImage(logoAsset),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            width: 325,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: mainGreyColorTheme)),
                            // InputDecorator(
                            //   decoration: const InputDecoration(border: OutlineInputBorder()),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    lbl_Generator_ID,
                                    style: TextStyle(
                                        color: mainGreyColorTheme,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: mainGreyColorTheme,
                                  ),
                                  items: value.generatorNameList
                                      .map(buildMenuItem)
                                      .toList(),
                                  value: value.chosenGeneratorName,
                                  onChanged: (item) {
                                    value.ChooseGeneratorName(item.toString());
                                    int i = (value.gens).indexWhere((element) =>
                                        element.name == item.toString()); 
                                    value.setChosenGeneratorId(
                                        value.gens.elementAt(i).generatorId);
                                    //value.setChosenGeneratorId(item.toString());
                                  }),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: value.option == 'lan'
                                  ? mainColorTheme
                                  : Colors.white,
                              textStyle: TextStyle(
                                  color: value.option == 'lan'
                                      ? Colors.white
                                      : mainColorTheme),
                              elevation: 4,
                              side:
                                  BorderSide(width: 2.0, color: mainColorTheme),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              padding: EdgeInsets.all(0.0),
                            ),
                            onPressed: () {
                              value.ChangeMode('lan');
                              //added by youssef//
                              value.changeCloudConfigValue(true);
                              // if (value.DashBoardFirstTimeAccess == false) {
                              //   Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context) => LanDashboard_Index(
                              //             RefreshRate: value.RefreshRate,
                              //           )));
                              // }
                            },
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 12.0),
                                child: Text(
                                  lbl_LAN,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: value.option == 'lan'
                                          ? Colors.white
                                          : mainColorTheme),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                          SizedBox(width: 10),
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: value.option == 'cloud'
                                  ? mainColorTheme
                                  : Colors.white,
                              textStyle: TextStyle(
                                  color: value.option == 'cloud'
                                      ? Colors.white
                                      : mainColorTheme),
                              elevation: 4,
                              side:
                                  BorderSide(width: 2.0, color: mainColorTheme),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              padding: EdgeInsets.all(0.0),
                            ),
                            onPressed: () {
                              value.ChangeMode('cloud');
                              //added by youssef
                              value.changeCloudConfigValue(false);
                              // if (value.DashBoardFirstTimeAccess == false) {
                              //   Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context) => CloudDashboard_Index(
                              //             RefreshRate: value.RefreshRate,
                              //           )));
                              // }
                            },
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 12.0),
                                child: Text(
                                  lbl_Cloud,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: value.option == 'cloud'
                                          ? Colors.white
                                          : mainColorTheme),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                          SizedBox(width: 10),
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: value.option == 'comap'
                                  ? mainColorTheme
                                  : Colors.white,
                              textStyle: TextStyle(
                                  color: value.option == 'comap'
                                      ? Colors.white
                                      : mainColorTheme),
                              elevation: 4,
                              side:
                                  BorderSide(width: 2.0, color: mainColorTheme),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              padding: EdgeInsets.all(0.0),
                            ),
                            onPressed: () {
                              value.ChangeMode('comap'); 
                              // if (value.DashBoardFirstTimeAccess == false) {
                              //   Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context) => Dashboard_Index()));
                              // }
                            },
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 12.0),
                                child: Text(
                                  lbl_Comap,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: value.option == 'comap'
                                          ? Colors.white
                                          : mainColorTheme),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      //added by youssef with and without configuration for cloud
                      if (value.cloudMode == 1) ...[
                        Padding(
                          padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
                          child: CheckboxListTile(
                              title: const Text(
                                'Device Configuration',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: value.cloudConfigValue,
                              onChanged: (bool? val) {
                                value.changeCloudConfigValue(val);
                              }),
                        )
                      ],
                      SizedBox(
                        height: 25,
                      ),
                      if (value.cloudConfigValue == true) ...[
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mainGreyColorTheme)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      lbl_SSID,
                                      style: TextStyle(
                                          color: mainGreyColorTheme,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: mainGreyColorTheme,
                                    ),
                                    items: value.ssidList
                                        .map(buildMenuItem)
                                        .toList(),
                                    value: value.chosenSSID,
                                    onChanged: (item) {
                                      // String string = item.toString();
                                      // final splitted = string.split(' (');
                                      value.ComboBoxState(item.toString());
                                    }),
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 50,
                              child: T13Button(
                                  textContent: lbl_Fetch,
                                  onPressed: () async {
                                    value.ShowSSIDs();
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        t13EditTextStyle(lbl_hint_password, passwordController),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onChanged: (rate) =>
                              value.changeRefreshRate(int.parse(rate)),
                          style: TextStyle(
                              fontSize: textSizeMedium,
                              fontFamily: PoppinsFamily),
                          obscureText: false,
                          cursorColor: black,
                          controller: refreshRateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
                            hintText: lbl_Default_Refresh_Rate,
                            hintStyle:
                                primaryTextStyle(color: textFieldHintColor),
                            filled: true,
                            fillColor: lightBorderColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onChanged: (address) =>
                              value.changeControllerAddress(address),
                          style: TextStyle(
                              fontSize: textSizeMedium,
                              fontFamily: PoppinsFamily),
                          obscureText: false,
                          cursorColor: black,
                          controller: ControllerAddressController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
                            hintText: "Controller Address",
                            hintStyle:
                                primaryTextStyle(color: textFieldHintColor),
                            filled: true,
                            fillColor: lightBorderColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(height: 10),
                        Spacer(),
                        if (value.loading == true)
                          SpinKitCircle(
                            color: Colors.black,
                            size: 65,
                          ),
                        SizedBox(height: 20),
                        T13Button(
                            textContent: lbl_Save_Settings,
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              //added by youssef//
                              if(value.chosenSSID==null){
                                value.chosenSSID="";
                                value.password="";
                              }
                              else {
                                value.Loading(true);
                                await value.service.Connecttossid(
                                    value.chosenSSID,
                                    passwordController.text,
                                    value.cloudUsername, 
                                    value.cloudPassword,
                                    value.cloudMode.toString(),
                                    value.chosenGeneratorId,
                                    value.ControllerAddress);
                                Timer(Duration(seconds: 15), () {
                                  // to add before this switch to cloud mode as get request to the esp
                                  value.Loading(false);
                                });
                              }
                              // value.service.RestartESP();
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
            
                          onChanged: (apiendpoint) =>
                              value.changeApiLanEndpoint(apiendpoint),
                          style: TextStyle(
                              fontSize: textSizeMedium,
                              fontFamily: PoppinsFamily),
                          obscureText: false,
                          cursorColor: black,
                          controller: apiEndpointLanController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
                            hintText: lbl_Api_Endpoint,
                            hintStyle: 
                                primaryTextStyle(color: textFieldHintColor),
                            filled: true,   
                            fillColor: hasError ? Colors.red : lightBorderColor, 
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),  
                              borderSide: BorderSide(
                                  color:  Colors.transparent, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                          ),
               
                        ),
                        SizedBox(height: 20),
                        T13Button(
                            textContent: lbl_Submit_Settings,
                            onPressed: () async {
                               // final response = await http.get(Uri.parse("http://" + apiEndpointLanController.text));
                              var dio = Dio();
                              final response;
                           try {
                              response= await dio.get(
                                 'http://' + apiEndpointLanController.text +
                                     '/getValue?param=CoolantTemp');
                              if (response.statusCode == 200) {

                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                                value.setApiLanEndpoint(
                                    "http://" + apiEndpointLanController.text);
                                value.configsList.add(ConfigurationModel(
                                    ssid: value.chosenSSID,
                                    password: value.password,
                                    refreshRate: value.RefreshRate,
                                    cloudUser: value.cloudUsername,
                                    cloudPassword: value.cloudPassword,
                                    cloudMode: value.cloudMode,
                                    generatorId: value.chosenGeneratorId,
                                    generatorName: value.chosenGeneratorName,
                                    espapiendpoint: apiEndpointLanController.text,
                                    controllerAddress:
                                    ControllerAddressController.text));
                                prefs.setBool(
                                    prefs_DashboardFirstTimeAccess, false);
                                //await getListConfigurationModel();
                                //configsList.add(ConfigurationModel(ssid:value.chosenSSID, password:value.password, refreshRate:value.RefreshRate, cloudUser: value.cloudUsername, cloudPassword: value.cloudPassword, cloudMode: value.cloudMode, generatorId: value.chosenGeneratorId,generatorName: value.chosenGeneratorName,espapiendpoint: apiEndpointLanController.text));
                                value.configModel = ConfigurationModel(
                                  ssid: value.chosenSSID,
                                  password: value.password,
                                  refreshRate: value.RefreshRate,
                                  cloudUser: value.cloudUsername,
                                  cloudPassword: value.cloudPassword,
                                  cloudMode: value.cloudMode,
                                  generatorId: value.chosenGeneratorId,
                                  generatorName: value.chosenGeneratorName,
                                  espapiendpoint: apiEndpointLanController.text,
                                  controllerAddress:
                                  ControllerAddressController.text,
                                );
                                if (value.generatorNameList.length != 1) {
                                  SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();

                                  //List<String> ConfigsEncoded = value.ConfigurationModelsList.map((config) => jsonEncode(ConfigurationModel.toJson())).;
                                  //String Configs=jsonEncode(value.ConfigurationModelsList);
                                  String Configs = jsonEncode(value.configsList);
                                  String SelectedConfigurationModel =
                                  jsonEncode(value.configModel);
                                  await sharedPreferences.setString(
                                      'Configurations', Configs);
                                  await sharedPreferences.setString(
                                      'SelectedConfigurationModel',
                                      SelectedConfigurationModel);
                                  sharedPreferences.setBool(
                                      prefs_DashboardFirstTimeAccess, false);
                                  value.generatorNameList.removeWhere((generator) =>
                                  generator == value.chosenGeneratorName);
                                  value.chosenGeneratorName =
                                      value.generatorNameList.elementAt(0);
                                  List<String> gens = await sharedPreferences
                                      .getStringList("generatorNameList")!;
                                  gens.remove(value.chosenGeneratorName);
                                  Generator Chosen = value.gens.firstWhere(
                                          (element) =>
                                      element.name ==
                                          value.chosenGeneratorName);
                                  value.chosenGeneratorId = Chosen.generatorId;
                                  await sharedPreferences.setStringList(
                                      "genneratorNameList", gens);
                                  if (value.option == 'cloud') {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CloudDashboard_Index(
                                                    RefreshRate:
                                                    value.RefreshRate)));
                                  } else if (value.option == 'comap') {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Dashboard_Index()));
                                  } else {
                                    //added by youssef k to initialize the background lan notification service//
                                    if(await prefs.getBool("FirstLanGen")==null) {
                                      await initializeService();
                                    }
                                    await prefs.setBool("FirstLanGen", false);
                                    ///////////////////////////////////////////////////////////////////////////
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LanDashboard_Index(
                                                  RefreshRate: value.RefreshRate,
                                                )));
                                  }
                                  value.isNotFirstTime();
                                  prefs.setBool(
                                      prefs_DashboardFirstTimeAccess, false);
                                }
                                else if (value.generatorNameList.length == 1) {
                                  SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();

                                  //List<String> ConfigsEncoded = value.ConfigurationModelsList.map((config) => jsonEncode(ConfigurationModel.toJson())).;
                                  //String Configs=jsonEncode(value.ConfigurationModelsList);
                                  String Configs = jsonEncode(value.configsList);
                                  String SelectedConfigurationModel =
                                  jsonEncode(value.configModel);
                                  await sharedPreferences.setString(
                                      'Configurations', Configs);
                                  await sharedPreferences.setString(
                                      'SelectedConfigurationModel',
                                      SelectedConfigurationModel);
                                  sharedPreferences.setBool(
                                      prefs_DashboardFirstTimeAccess, false);

                                  value.chosenGeneratorName =
                                      value.generatorNameList.elementAt(0);
                                  List<String> gens = await sharedPreferences
                                      .getStringList("generatorNameList")!;
                                  gens.remove(value.chosenGeneratorName);
                                  Generator Chosen = value.gens.firstWhere(
                                          (element) =>
                                      element.name ==
                                          value.chosenGeneratorName);
                                  value.chosenGeneratorId = Chosen.generatorId;
                                  await sharedPreferences.setStringList(
                                      "genneratorNameList", gens);
                                  if (value.option == 'cloud') {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CloudDashboard_Index(
                                                    RefreshRate:
                                                    value.RefreshRate)));
                                  } else if (value.option == 'comap') {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Dashboard_Index()));
                                  } else {
                                    //added by youssef k to initialize the background lan notification service//
                                    if(await prefs.getBool("FirstLanGen")==null) {
                                      await initializeService();
                                    }
                                    await prefs.setBool("FirstLanGen", false);
                                    ///////////////////////////////////////////////////////////////////////////
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LanDashboard_Index(
                                                  RefreshRate: value.RefreshRate,
                                                )));
                                  }
                                  value.isNotFirstTime();
                                  prefs.setBool(
                                      prefs_DashboardFirstTimeAccess, false);
                                  value.generatorNameList.removeWhere((generator) =>
                                  generator == value.chosenGeneratorName);
                                }

                              }
                           }
                          on Exception catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(       content: Text("Api EndPoint Not Valid !"),     ));
                          }
  }
                            ),
  
                        SizedBox(height: 20),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                      if (value.cloudConfigValue == false &&
                          value.option == 'cloud')
                        T13Button(
                            textContent: lbl_Submit_Settings,
                            onPressed: () async {
                              value.setApiLanEndpoint(
                                  "http://" + apiEndpointLanController.text);
                              value.configsList.add(ConfigurationModel(
                                ssid: "",
                                password: "",
                                refreshRate: 1,
                                cloudUser: value.cloudUsername,
                                cloudPassword: value.cloudPassword,
                                cloudMode: value.cloudMode,
                                generatorId: value.chosenGeneratorId,
                                generatorName: value.chosenGeneratorName,
                                espapiendpoint: "",
                                controllerAddress: "",
                              ));
                              //await getListConfigurationModel();
                              //configsList.add(ConfigurationModel(ssid:"", password:"", refreshRate:10, cloudUser: value.cloudUsername, cloudPassword: value.cloudPassword, cloudMode: value.cloudMode, generatorId: value.chosenGeneratorId,generatorName: value.chosenGeneratorName,espapiendpoint: ""));
                              //value.configModel=null;
                              value.configModel = ConfigurationModel(
                                ssid: "",
                                password: "",
                                refreshRate: 1,
                                cloudUser: value.cloudUsername,
                                cloudPassword: value.cloudPassword,
                                cloudMode: value.cloudMode,
                                generatorId: value.chosenGeneratorId,
                                generatorName: value.chosenGeneratorName,
                                espapiendpoint: "",
                                controllerAddress: "",
                              );
                              if (value.generatorNameList.length != 1) {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                //List<String> ConfigsEncoded = value.ConfigurationModelsList.map((config) => jsonEncode(ConfigurationModel.toJson())).;
                                //String Configs=jsonEncode(value.ConfigurationModelsList);
                                String Configs = jsonEncode(value.configsList);
                                String SelectedConfigurationModel =
                                    jsonEncode(value.configModel);
                                await sharedPreferences.setString(
                                    'Configurations', Configs);
                                await sharedPreferences.setString(
                                    'SelectedConfigurationModel',
                                    SelectedConfigurationModel);

                                value.generatorNameList.removeWhere(
                                    (generator) =>
                                        generator == value.chosenGeneratorName);

                                List<String> gens = await sharedPreferences
                                    .getStringList("generatorNameList")!;
                                gens.remove(value.chosenGeneratorName);
                                value.chosenGeneratorName =
                                    value.generatorNameList.elementAt(0);
                                Generator Chosen = value.gens.firstWhere(
                                    (element) =>
                                        element.name ==
                                        value.chosenGeneratorName);
                                value.chosenGeneratorId = Chosen.generatorId;
                                await sharedPreferences.setStringList(
                                    "generatorNameList", gens);

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CloudDashboard_Index(
                                                RefreshRate: 1)));

                                value.isNotFirstTime();
                                sharedPreferences.setBool(
                                    prefs_DashboardFirstTimeAccess, false);
                              } else if (value.generatorNameList.length == 1) {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                //List<String> ConfigsEncoded = value.ConfigurationModelsList.map((config) => jsonEncode(ConfigurationModel.toJson())).;
                                //String Configs=jsonEncode(value.ConfigurationModelsList);
                                String Configs = jsonEncode(value.configsList);
                                String SelectedConfigurationModel =
                                    jsonEncode(value.configModel);
                                await sharedPreferences.setString(
                                    'Configurations', Configs);
                                await sharedPreferences.setString(
                                    'SelectedConfigurationModel',
                                    SelectedConfigurationModel);

                                List<String> gens = await sharedPreferences
                                    .getStringList("generatorNameList")!;
                                gens.remove(value.chosenGeneratorName);
                                value.chosenGeneratorName =
                                    value.generatorNameList.elementAt(0);
                                Generator Chosen = value.gens.firstWhere(
                                    (element) =>
                                        element.name ==
                                        value.chosenGeneratorName);
                                value.chosenGeneratorId = Chosen.generatorId;
                                await sharedPreferences.setStringList(
                                    "generatorNameList", gens);
                                sharedPreferences.setBool(
                                    prefs_DashboardFirstTimeAccess, false);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CloudDashboard_Index(
                                                RefreshRate: 1)));

                                value.isNotFirstTime();

                                value.generatorNameList.removeWhere(
                                    (generator) =>
                                        generator == value.chosenGeneratorName);
                              }  

                              // prefs.setBool(
                              //     prefs_DashboardFirstTimeAccess, false);
                            }),
                    ]),
                  ),
                ),
              ]),
            )));
  }

  DropdownMenuItem<String> buildMenuItem(String selectedSSID) =>
      DropdownMenuItem(value: selectedSSID, child: Text(selectedSSID));

  DropdownMenuItem<String> buildMenuItemgen(Generator gen) =>
      DropdownMenuItem(value: gen.generatorId, child: Text(gen.name));

// Future<List<ConfigurationModel>> getListConfigurationModel() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if(prefs.getString('Configurations')==null)
//       configsList=[];
//     else{
//       configsList = (json.decode(prefs.getString('Configurations')!) as List)
//           .map((data) => ConfigurationModel.fromJson(data))
//           .toList();
//     }
//     return configsList;
//   }

}

enum ConfigValue { withConfig, withoutConfig }
