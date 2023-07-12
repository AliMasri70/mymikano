import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymikano_app/State/CloudGeneratorState.dart';
import 'package:mymikano_app/models/ConfigurationModel.dart';
import 'package:mymikano_app/models/GeneratorModel.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/images.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/viewmodels/CloudDashBoard_ModelView.dart';
import 'package:mymikano_app/views/screens/AlarmNotifcationScreen.dart';
import 'package:mymikano_app/views/screens/Dashboard/FetchGenerators.dart';
import 'package:mymikano_app/views/screens/Dashboard/GeneratorAlertsPage.dart';
import 'package:mymikano_app/views/screens/Dashboard/LanDashboard_Index.dart';
import 'package:mymikano_app/views/screens/MenuScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:mymikano_app/services/CloudDashboard_Service.dart';
import '../../../State/ApiConfigurationStatee.dart';
import '../../widgets/Custom_GaugeWidget.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CloudDashboard_Index extends StatefulWidget {
  final int RefreshRate;
  CloudDashboard_Index({Key? key, required this.RefreshRate}) : super(key: key);

  @override
  _CloudDashboard_IndexState createState() => _CloudDashboard_IndexState();
}

class _CloudDashboard_IndexState extends State<CloudDashboard_Index> {
  late Timer timer;

  bool? isFetched;
  int _value = 0;
  bool isOnleft = false;
  bool isOnMiddle = false;
  bool isOnRight = false;
  late CloudDashBoard_Service CloudService;
  late ConfigurationModel configModel;
  late Generator ConfigGenerator;
  bool isReset = false;
  bool greenline = false;
  //late final List<ConfigurationModel> configsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSelectedConfigurationModel();

    isDataFetched().whenComplete(() {
      setState(() {});
    });

    timer = Timer.periodic(Duration(seconds: widget.RefreshRate), (Timer t) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Refreshing values..."),
      ));
      isDataFetched().whenComplete(() {
        setState(() {});
      });
    });
  }

  Future<void> isDataFetched() async {
    await Provider.of<CloudGeneratorState>(context, listen: false)
        .ReinitiateCloudService();
    isFetched = await Provider.of<CloudGeneratorState>(context, listen: false)
        .FetchData();
  }

  Future<ConfigurationModel> getSelectedConfigurationModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String test = prefs.getString('Configurations').toString();
    List<ConfigurationModel> configsList =
        (json.decode(prefs.getString('Configurations')!) as List)
            .map((data) => ConfigurationModel.fromJson(data))
            .toList();
    if (configsList.length != 0) {
      prefs.setBool(prefs_DashboardFirstTimeAccess, false);
    }
    ConfigurationModel config = ConfigurationModel.fromJson(
        json.decode(prefs.getString('SelectedConfigurationModel')!));
    configModel = config;
    configModel = config;
    return configModel;
  }

  bool timedelayMCBFeedback(CloudGeneratorState c) {
    bool state = false;
    if (c.MCBFeedback.value == '1') {
      //sleep(Duration(seconds: 2));
      state = true;
    }
    return state;
  }

  bool timedelayGCBFeedback(CloudGeneratorState c) {
    bool state = false;
    if (c.GCBFeedback.value == '1') {
      //sleep(Duration(seconds: 2));
      state = true;
    }
    return state;
  }
  // Future<List<ConfigurationModel>> getListConfigurationModel() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String test=prefs.getString('Configurations').toString();
  //   configsList = (json.decode(prefs.getString('Configurations')!) as List)
  //       .map((data) => ConfigurationModel.fromJson(data))
  //       .toList();
  //   return configsList;
  // }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () {
          return isDataFetched();
        },
        child: Consumer2<ApiConfigurationStatee, CloudGeneratorState>(
            builder: (context, value, cloud, child) => Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          if (isFetched == true) ...[
                            Column(children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: backArrowColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Spacer(),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            lbl_Generator_ID,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Poppins",
                                              color: Colors.black,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                          items: value.configsList
                                              .map(buildMenuItem)
                                              .toList(),
                                          //  value:value.selectedConfigurationModel.generatorId,
                                          value: configModel.generatorId,
                                          onChanged: (item) async {
                                            ConfigurationModel model = value
                                                .configsList
                                                .firstWhere((element) =>
                                                    element.generatorId ==
                                                    item);
                                            value.configModel = model;

                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            //List<String> ConfigsEncoded = value.ConfigurationModelsList.map((config) => jsonEncode(ConfigurationModel.toJson())).;
                                            //String Configs=jsonEncode(value.ConfigurationModelsList);
                                            String Configs =
                                                jsonEncode(value.configsList);
                                            String SelectedConfigurationModel =
                                                jsonEncode(value.configModel);
                                            await sharedPreferences.setString(
                                                'Configurations', Configs);
                                            await sharedPreferences.setString(
                                                'SelectedConfigurationModel',
                                                SelectedConfigurationModel);

                                            List<String> gens =
                                                await sharedPreferences
                                                    .getStringList(
                                                        "generatorNameList")!;

                                            value.chosenGeneratorName = value
                                                .generatorNameList
                                                .elementAt(0);
                                            Generator Chosen = value.gens
                                                .firstWhere((element) =>
                                                    element.name ==
                                                    value.chosenGeneratorName);
                                            value.chosenGeneratorId =
                                                Chosen.generatorId;
                                            await sharedPreferences
                                                .setStringList(
                                                    "generatorNameList", gens);

                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CloudDashboard_Index(
                                                            RefreshRate: configModel
                                                                .refreshRate)));
                                            value.isNotFirstTime();
                                          }),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: 45,
                                    height: 50,
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title:
                                                    const Text('Reset Dialog'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text(
                                                          'Are you sure you want to Reset ?'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () async {
                                                      value.resetPreferences(
                                                          configModel
                                                              .espapiendpoint);
                                                      // Navigator.of(context).push(
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             ApiConfigurationPage()));
                                                      value.generatorNameList
                                                          .add(configModel
                                                              .generatorName);

                                                      //value.chosenGeneratorName=value.generatorNameList.elementAt(0);
                                                      value.configsList
                                                          .removeWhere((element) =>
                                                              element
                                                                  .generatorId ==
                                                              configModel
                                                                  .generatorId);
                                                      SharedPreferences
                                                          sharedPreferences =
                                                          await SharedPreferences
                                                              .getInstance();

                                                      if (value.configsList
                                                              .length !=
                                                          0) {
                                                        value.configModel =
                                                            value.configsList
                                                                .elementAt(0);

                                                        String Configs =
                                                            jsonEncode(value
                                                                .configsList);
                                                        String
                                                            SelectedConfigurationModel =
                                                            jsonEncode(value
                                                                .configModel);
                                                        await sharedPreferences
                                                            .setString(
                                                                'Configurations',
                                                                Configs);
                                                        await sharedPreferences
                                                            .setString(
                                                                'SelectedConfigurationModel',
                                                                SelectedConfigurationModel);

                                                        List<String> gens =
                                                            await sharedPreferences
                                                                .getStringList(
                                                                    "generatorNameList")!;

                                                        value.chosenGeneratorName =
                                                            value
                                                                .generatorNameList
                                                                .elementAt(0);
                                                        Generator Chosen = value
                                                            .gens
                                                            .firstWhere((element) =>
                                                                element.name ==
                                                                value
                                                                    .chosenGeneratorName);
                                                        value.chosenGeneratorId =
                                                            Chosen.generatorId;
                                                        await sharedPreferences
                                                            .setStringList(
                                                                "generatorNameList",
                                                                gens);

                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                            builder: (context) =>
                                                                CloudDashboard_Index(
                                                                    RefreshRate:
                                                                        configModel
                                                                            .refreshRate)));
                                                        value.isNotFirstTime();
                                                      } else {
                                                        String Configs =
                                                            jsonEncode(value
                                                                .configsList);
                                                        await sharedPreferences
                                                            .setString(
                                                                'Configurations',
                                                                Configs);

                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    FetchGenerators(
                                                                        RefreshRate:
                                                                            1)));
                                                        sharedPreferences.setBool(
                                                            prefs_DashboardFirstTimeAccess,
                                                            true);
                                                      }
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      //toExit = false;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.refresh), // <-- Icon
                                              Text(lbl_Reset),

                                              // <-- Text
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ApiConfigurationPage()));

                                        value.chosenGeneratorName = value
                                            .generatorNameList
                                            .elementAt(0);

                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FetchGenerators(
                                                        RefreshRate: 1)));
                                      },
                                      icon: Icon(Icons.settings)),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AlarmNotification()));
                                      },
                                      icon: Icon(Icons.warning)),

                                  /* GestureDetector(
                                      onTap: () {
                                     /*   Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GeneratorAlertsPage())); */
                                      },
                                      child: Icon(Icons.warning)),   */
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ChoiceChip(
                                    pressElevation: 0.0,
                                    selectedColor: mainColorTheme,
                                    backgroundColor: mainGreyColorTheme2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: mainGreyColorTheme2)),
                                    label: Text("Auto"),
                                    selected: cloud.ControllerModeStatus == 2
                                        ? true
                                        : false,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        // _value = (selected ? 0 : null)!;
                                        cloud.changeControllerModeStatus(2);
                                      });
                                    },
                                  ),
                                  ChoiceChip(
                                    pressElevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: mainGreyColorTheme2)),
                                    selectedColor: mainColorTheme,
                                    backgroundColor: mainGreyColorTheme2,
                                    label: Text("Manual"),
                                    selected: cloud.ControllerModeStatus == 1
                                        ? true
                                        : false,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        //_value = (selected ? 1 : null)!;
                                        cloud.changeControllerModeStatus(1);
                                      });
                                    },
                                  ),
                                  ChoiceChip(
                                    pressElevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: mainGreyColorTheme2)),
                                    selectedColor: mainColorTheme,
                                    backgroundColor: mainGreyColorTheme2,
                                    label: Text("OFF"),
                                    selected: cloud.ControllerModeStatus == 0
                                        ? true
                                        : false,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        //_value = (selected ? 1 : null)!;
                                        cloud.changeControllerModeStatus(0);

                                        //cloud.changeIsIO(false);
                                      });
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: Image.asset(ic_faultReset),
                                      onPressed: () {
                                        cloud.changeAlarmClear(true);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                      ),
                                      //child: const Text('Clear Alarms', style: TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.0, 4.0, 8.0, 8.0),
                                child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 4.0, 8.0, 8.0),
                                    width: 350,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 4,
                                          left: 15,
                                          child: Container(
                                              width: 90,
                                              height: 61,
                                              child: IconButton(
                                                icon: Image.asset(ic_tower,
                                                    color: ((double.parse(cloud
                                                                        .mainsvoltageL1N
                                                                        .value)) >
                                                                    0 ||
                                                                (double.parse(cloud
                                                                        .mainsvoltageL2N
                                                                        .value)) >
                                                                    0 ||
                                                                (double.parse(cloud
                                                                        .mainsvoltageL3N
                                                                        .value)) >
                                                                    0) &&
                                                            cloud.MainsHealthy
                                                                    .value ==
                                                                '1'
                                                        ? GreenpowerColor
                                                        : mainGreyColorTheme),
                                                onPressed: () {},
                                              ))),
                                      Positioned(
                                          top: 15,
                                          left: 80,
                                          child: Container(
                                            width: 40,
                                            height: 48,
                                            child: ImageIcon(
                                              AssetImage(ic_line),
                                              color: ((double.parse(cloud.mainsvoltageL1N.value)) > 0 ||
                                                          (double.parse(cloud.mainsvoltageL2N.value)) >
                                                              0 ||
                                                          (double.parse(cloud
                                                                  .mainsvoltageL3N
                                                                  .value)) >
                                                              0) &&
                                                      cloud.MainsHealthy.value ==
                                                          '1' &&
                                                      timedelayMCBFeedback(cloud) ==
                                                          true &&
                                                      cloud.MCBModeStatus ==
                                                          true
                                                  ? GreenpowerColor
                                                  : ((double.parse(cloud.mainsvoltageL1N.value)) > 0 ||
                                                              (double.parse(cloud.mainsvoltageL2N.value)) >
                                                                  0 ||
                                                              (double.parse(cloud.mainsvoltageL3N.value)) >
                                                                  0) &&
                                                          cloud.MainsHealthy.value ==
                                                              '1' &&
                                                          timedelayMCBFeedback(cloud) ==
                                                              false &&
                                                          cloud.MCBModeStatus ==
                                                              true
                                                      ? mainColorTheme
                                                      : mainGreyColorTheme,
                                            ),
                                          )),
                                      if (cloud.ControllerModeStatus != 2)
                                        Positioned(
                                          top: 72,
                                          left: 232,
                                          child: new Bounceable(
                                              scaleFactor: 0.6,
                                              onTap: () {
                                                setState(() {
                                                  cloud.changeIsIO(false);
                                                });
                                              },
                                              child: Container(
                                                  width: 65,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(ic_o),
                                                        fit: BoxFit.fitWidth),
                                                  ))),
                                        ),
                                      if (cloud.ControllerModeStatus != 2)
                                        Positioned(
                                          top: 4,
                                          left: 241,
                                          child: new Bounceable(
                                              scaleFactor: 0.6,
                                              onTap: () {
                                                setState(() {
                                                  cloud.changeIsIO(true);
                                                });
                                              },
                                              child: Container(
                                                  width: 48,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(ic_i),
                                                        fit: BoxFit.fitWidth),
                                                  ))),
                                        ),
                                      Positioned(
                                          top: 24,
                                          left: 185,
                                          child: Container(
                                            width: 60,
                                            height: 28,
                                            child: ImageIcon(
                                              AssetImage(ic_g),
                                              color:
                                                  cloud.ReadyToLoad.value == '1'
                                                      ? GreenpowerColor
                                                      : mainGreyColorTheme,
                                            ),
                                          )),
                                      Positioned(
                                          top: 15,
                                          left: 150,
                                          child: Container(
                                            width: 50,
                                            height: 48,
                                            child: ImageIcon(
                                              AssetImage(ic_line),
                                              color: greenline == true &&
                                                      cloud.isGCB == true &&
                                                      timedelayGCBFeedback(
                                                              cloud) ==
                                                          true
                                                  ? GreenpowerColor
                                                  : cloud.ReadyToLoad.value ==
                                                              '1' &&
                                                          timedelayGCBFeedback(
                                                                  cloud) ==
                                                              false &&
                                                          cloud.isGCB == true
                                                      ? mainColorTheme
                                                      : mainGreyColorTheme,
                                            ),
                                          )),
                                      Positioned(
                                          top: 24,
                                          left: 115,
                                          child: Container(
                                            width: 40,
                                            height: 26,
                                            child: ImageIcon(
                                              AssetImage(ic_factory),
                                              color: (cloud.ReadyToLoad.value ==
                                                              '1' &&
                                                          timedelayGCBFeedback(
                                                                  cloud) ==
                                                              true &&
                                                          cloud.isGCB ==
                                                              true) ||
                                                      (cloud.MainsHealthy
                                                                  .value ==
                                                              '1' &&
                                                          timedelayMCBFeedback(
                                                                  cloud) ==
                                                              true &&
                                                          cloud.MCBModeStatus ==
                                                              true)
                                                  ? GreenpowerColor
                                                  : mainGreyColorTheme,
                                            ),
                                          )),
                                      if (cloud.ControllerModeStatus != 2)
                                        Positioned(
                                          top: 72,
                                          left: 67,
                                          child: new Bounceable(
                                              scaleFactor: 0.6,
                                              onTap: () {
                                                if (cloud.MCBModeStatus ==
                                                    false) {
                                                  cloud.changeMCBModeStatus(
                                                      true);
                                                } else {
                                                  cloud.changeMCBModeStatus(
                                                      false);
                                                }
                                              },
                                              // onTap: () async {
                                              //       sleep(Duration(seconds: 2));
                                              //   await  Future.delayed(Duration(seconds: 2), () {
                                              //     if(cloud.MCBModeStatus == false){
                                              //
                                              //       cloud.changeMCBModeStatus(
                                              //           true);
                                              //     }
                                              //     else{
                                              //
                                              //       cloud.changeMCBModeStatus(
                                              //           false);
                                              //     }
                                              //   });
                                              //
                                              //
                                              // },
                                              child: Container(
                                                  width: 60,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image:
                                                            AssetImage(ic_io),
                                                        fit: BoxFit.fitWidth),
                                                  ))),
                                        ),
                                      if (cloud.ControllerModeStatus != 2)
                                        Positioned(
                                          top: 72,
                                          left: 147,
                                          child: new Bounceable(
                                              scaleFactor: 0.6,
                                              onTap: () {
                                                if (cloud.ReadyToLoad.value ==
                                                    '1') {
                                                  if (cloud.GCBFeedback.value ==
                                                      '1') {
                                                    greenline = true;
                                                  }
                                                }
                                                if (cloud.isGCB == false) {
                                                  cloud.changeIsGCB(true);
                                                } else {
                                                  cloud.changeIsGCB(false);
                                                }
                                              },
                                              //                                           onTap: () async {
                                              // await  Future.delayed(Duration(seconds: 2), () {
                                              //                                              if(cloud.ReadyToLoad.value == '1' ){
                                              //
                                              //                                                 if(cloud.GCBFeedback.value == '1'){
                                              //                                                   greenline = true;
                                              //                                                 }
                                              //
                                              //                                              }
                                              //                                               if(cloud.isGCB == false){
                                              //
                                              //                                                   cloud.changeIsGCB(
                                              //                                                       true);
                                              //                                                 }
                                              //                                                 else{
                                              //
                                              //                                                   cloud.changeIsGCB(
                                              //                                                       false);
                                              //                                                 }
                                              //                                           });
                                              // },
                                              child: Container(
                                                  width: 60,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image:
                                                            AssetImage(ic_io),
                                                        fit: BoxFit.fitWidth),
                                                  ))),
                                        ),
                                    ])),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                          height: 160,
                                          width: 160,
                                          decoration: BoxDecoration(
                                            color: mainGreyColorTheme2,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Custom_GaugeWidget(
                                            title: lbl_Actual_Power,
                                            value: (double.parse(
                                                cloud.GeneratorLoad.value)),
                                            needleColor: mainColorTheme,
                                            min: 0,
                                            max: cloud.nominalLoadkW.value
                                                .toDouble(),
                                          )),
                                    ],
                                  ),
                                  Spacer(),
                                  SizedBox(height: 10),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height: 160,
                                              width: 160,
                                              decoration: BoxDecoration(
                                                color: mainGreyColorTheme2,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Custom_GaugeWidget(
                                                  title: lbl_RPM,
                                                  value: (double.parse(
                                                      cloud.Rpm.value)),
                                                  min: 0,
                                                  max: 3000)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: <Widget>[
                                  ExpansionTile(
                                    title: Text('Engine Status'),
                                    children: [
                                      ListView(
                                        physics: const ScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          infotile(title: "Engine State", value: cloud.EngineState.value),
                                          infotile(
                                            title: lbl_Pressure,
                                            value: (double.parse(cloud
                                                                .OilPressure
                                                                .value))
                                                            .toString() ==
                                                        '65523.0' ||
                                                    (double.parse(cloud.OilPressure.value))
                                                            .toString() ==
                                                        '32678.0' ||
                                                    (double.parse(cloud.OilPressure.value))
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    (double.parse(cloud.OilPressure.value))
                                                            .toString() ==
                                                        '65536' ||
                                                    (double.parse(cloud.OilPressure.value))
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : (double.parse(cloud.OilPressure.value)).toString() +
                                                    " " +
                                                    cloud.OilPressure.unit,
                                          ),
                                          infotile(
                                            title: lbl_Temperature,
                                            value: cloud.CoolantTemp.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.CoolantTemp.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.CoolantTemp.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.CoolantTemp.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.CoolantTemp.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.CoolantTemp.value
                                                        .toString() +
                                                    " " +
                                                    cloud.CoolantTemp.unit,
                                          ),
                                          infotile(
                                            title: "Fuel Level",
                                            value: cloud.FuelLevel.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.FuelLevel.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.FuelLevel.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.FuelLevel.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.FuelLevel.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.FuelLevel.value
                                                        .toString() +
                                                    " " +
                                                    cloud.FuelLevel.unit,
                                          ),
                                          infotile(
                                            title: "Running Hours",
                                            value: cloud.RunningHours.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.RunningHours.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.RunningHours.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.RunningHours.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.RunningHours.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.RunningHours.value
                                                        .toString() +
                                                    " " +
                                                    cloud.RunningHours.unit,
                                          ),
                                          infotile(
                                            title: "Battery Voltage",
                                            value: cloud.BatteryVoltage.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.BatteryVoltage.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.BatteryVoltage.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.BatteryVoltage.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.BatteryVoltage.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.BatteryVoltage.value
                                                        .toString() +
                                                    " " +
                                                    cloud.BatteryVoltage.unit,
                                          ),
                                          //Remove fuel Consumption
                                          // infotile(
                                          //   title: "Fuel consumption",
                                          //   value: cloud.TotalFuelConsumption.value.toString() == '65523' || cloud.TotalFuelConsumption.value.toString() == '32678' ||
                                          //   cloud.TotalFuelConsumption.value.toString().compareTo('3267.8') == 0 || cloud.TotalFuelConsumption.value.toString() == '65536' ||
                                          //   cloud.TotalFuelConsumption.value.toString().compareTo('6553.6') == 0 ? 'N/A' : cloud.TotalFuelConsumption.value.toString() + " "+ cloud.BatteryVoltage.unit,
                                          // ),

                                          //Remove Total Fuel Consumption
                                          // infotile(
                                          //   title: "Total fuel consumption",
                                          //
                                          //     value: cloud.TotalFuelConsumption.value == '65523' || cloud.TotalFuelConsumption.value == '32678' ||
                                          //     cloud.TotalFuelConsumption.value == '3267.8' || cloud.TotalFuelConsumption.value == '65536' ||
                                          //     cloud.TotalFuelConsumption.value == '6553.6' ? 'N/A' : cloud.TotalFuelConsumption.value + " " + cloud.TotalFuelConsumption.unit,
                                          //
                                          //   ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Alternator"),
                                    children: [
                                      ListView(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        children: [
                                          infotile(
                                            title: "L1-N",
                                            value: cloud.generatorL1N.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.generatorL1N.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.generatorL1N.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.generatorL1N.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.generatorL1N.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.generatorL1N.value
                                                        .toString() +
                                                    " " +
                                                    cloud.generatorL1N.unit,
                                          ),
                                          infotile(
                                            title: "L2-N",
                                            value: cloud.generatorL2N.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.generatorL2N.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.generatorL2N.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.generatorL2N.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.generatorL2N.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.generatorL2N.value
                                                        .toString() +
                                                    " " +
                                                    cloud.generatorL2N.unit,
                                          ),
                                          infotile(
                                            title: "L3-N",
                                            value: cloud.generatorL3N.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.generatorL3N.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.generatorL3N.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.generatorL3N.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.generatorL3N.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.generatorL3N.value
                                                        .toString() +
                                                    " " +
                                                    cloud.generatorL3N.unit,
                                          ),
                                          infotile(
                                            title: "L1-L2",
                                            value: cloud.generatorvoltageL1L2N
                                                            .value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.generatorvoltageL1L2N
                                                            .value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.generatorvoltageL1L2N
                                                            .value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.generatorvoltageL1L2N
                                                            .value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.generatorvoltageL1L2N
                                                            .value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.generatorvoltageL1L2N
                                                        .value
                                                        .toString() +
                                                    " " +
                                                    cloud.mainsvoltageL3N.unit,
                                          ),
                                          infotile(
                                            title: "L1-L3",
                                            value: cloud.generatorvoltageL1L3N
                                                            .value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.generatorvoltageL1L3N
                                                            .value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.generatorvoltageL1L3N
                                                            .value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.generatorvoltageL1L3N
                                                            .value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.generatorvoltageL1L3N
                                                            .value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.generatorvoltageL1L3N
                                                        .value
                                                        .toString() +
                                                    " " +
                                                    cloud.mainsvoltageL3N.unit,
                                          ),
                                          infotile(
                                            title: "L2-L3",
                                            value: cloud.generatorvoltageL2L3N
                                                            .value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.generatorvoltageL2L3N
                                                            .value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.generatorvoltageL2L3N
                                                            .value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.generatorvoltageL2L3N
                                                            .value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.generatorvoltageL2L3N
                                                            .value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.generatorvoltageL2L3N
                                                        .value
                                                        .toString() +
                                                    " " +
                                                    cloud.mainsvoltageL3N.unit,
                                          ),
                                          infotile(
                                            title: "L1",
                                            value: cloud.LoadAL1.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud
                                                            .LoadAL1.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadAL1.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadAL1.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadAL1.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadAL1.value
                                                        .toString() +
                                                    " " +
                                                    cloud.LoadAL1.unit,
                                          ),
                                          infotile(
                                            title: "L2",
                                            value: cloud.LoadAL2.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud
                                                            .LoadAL2.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadAL2.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadAL2.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadAL2.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadAL2.value
                                                        .toString() +
                                                    " " +
                                                    cloud.LoadAL2.unit,
                                          ),
                                          infotile(
                                            title: "L3",
                                            value: cloud.LoadAL3.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud
                                                            .LoadAL3.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadAL3.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadAL3.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadAL3.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadAL3.value
                                                        .toString() +
                                                    " " +
                                                    cloud.LoadAL3.unit,
                                          ),
                                          infotile(
                                            title: "Energy",
                                            value: cloud.LoadKWh.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud
                                                            .LoadKWh.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadKWh.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadKWh.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadKWh.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadKWh.value
                                                        .toString() +
                                                    " " +
                                                    cloud.LoadKWh.unit,
                                          ),
                                          infotile(
                                            title: "Hz",
                                            value: cloud.GeneratorFrequency
                                                            .value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.GeneratorFrequency
                                                            .value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.GeneratorFrequency
                                                            .value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.GeneratorFrequency
                                                            .value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.GeneratorFrequency
                                                            .value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.GeneratorFrequency.value
                                                        .toString() +
                                                    " " +
                                                    cloud.GeneratorFrequency
                                                        .unit,
                                          ),
                                          infotile(
                                            title: "Pf",
                                            value: cloud.LoadPowerFactor.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.LoadPowerFactor.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadPowerFactor.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadPowerFactor.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadPowerFactor.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadPowerFactor.value
                                                    .toString(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Mains"),
                                    children: [
                                      ListView(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        children: [
                                          infotile(
                                            title: "L1-N",
                                            value: cloud.mainsvoltageL1N.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.mainsvoltageL1N.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.mainsvoltageL1N.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.mainsvoltageL1N.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.mainsvoltageL1N.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.mainsvoltageL1N.value
                                                        .toString() +
                                                    " " +
                                                    cloud.mainsvoltageL1N.unit,
                                          ),
                                          infotile(
                                            title: "L2-N",
                                            value: cloud.mainsvoltageL2N.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.mainsvoltageL2N.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.mainsvoltageL2N.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.mainsvoltageL2N.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.mainsvoltageL2N.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.mainsvoltageL2N.value
                                                        .toString() +
                                                    " " +
                                                    cloud.mainsvoltageL2N.unit,
                                          ),
                                          infotile(
                                            title: "L3-N",
                                            value: cloud.mainsvoltageL3N.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.mainsvoltageL3N.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.mainsvoltageL3N.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.mainsvoltageL3N.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.mainsvoltageL3N.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.mainsvoltageL3N.value
                                                        .toString() +
                                                    " " +
                                                    cloud.mainsvoltageL3N.unit,
                                          ),
                                          infotile(
                                            title: "L1-L2",
                                            value:
                                                cloud.mainsvoltageL1L2N.value
                                                                .toString() ==
                                                            '65523' ||
                                                        cloud.mainsvoltageL1L2N
                                                                .value
                                                                .toString() ==
                                                            '32678' ||
                                                        cloud
                                                                .mainsvoltageL1L2N
                                                                .value
                                                                .toString()
                                                                .compareTo(
                                                                    '3267.8') ==
                                                            0 ||
                                                        cloud.mainsvoltageL1L2N
                                                                .value
                                                                .toString() ==
                                                            '65536' ||
                                                        cloud.mainsvoltageL1L2N
                                                                .value
                                                                .toString()
                                                                .compareTo(
                                                                    '6553.6') ==
                                                            0
                                                    ? 'N/A'
                                                    : cloud.mainsvoltageL1L2N
                                                            .value
                                                            .toString() +
                                                        " " +
                                                        cloud.mainsvoltageL3N
                                                            .unit,
                                          ),
                                          infotile(
                                            title: "L1-L3",
                                            value:
                                                cloud.mainsvoltageL1L3N.value
                                                                .toString() ==
                                                            '65523' ||
                                                        cloud.mainsvoltageL1L3N
                                                                .value
                                                                .toString() ==
                                                            '32678' ||
                                                        cloud
                                                                .mainsvoltageL1L3N
                                                                .value
                                                                .toString()
                                                                .compareTo(
                                                                    '3267.8') ==
                                                            0 ||
                                                        cloud.mainsvoltageL1L3N
                                                                .value
                                                                .toString() ==
                                                            '65536' ||
                                                        cloud.mainsvoltageL1L3N
                                                                .value
                                                                .toString()
                                                                .compareTo(
                                                                    '6553.6') ==
                                                            0
                                                    ? 'N/A'
                                                    : cloud.mainsvoltageL1L3N
                                                            .value
                                                            .toString() +
                                                        " " +
                                                        cloud.mainsvoltageL3N
                                                            .unit,
                                          ),
                                          infotile(
                                            title: "L2-L3",
                                            value:
                                                cloud.mainsvoltageL2L3N.value
                                                                .toString() ==
                                                            '65523' ||
                                                        cloud.mainsvoltageL2L3N
                                                                .value
                                                                .toString() ==
                                                            '32678' ||
                                                        cloud
                                                                .mainsvoltageL2L3N
                                                                .value
                                                                .toString()
                                                                .compareTo(
                                                                    '3267.8') ==
                                                            0 ||
                                                        cloud.mainsvoltageL2L3N
                                                                .value
                                                                .toString() ==
                                                            '65536' ||
                                                        cloud.mainsvoltageL2L3N
                                                                .value
                                                                .toString()
                                                                .compareTo(
                                                                    '6553.6') ==
                                                            0
                                                    ? 'N/A'
                                                    : cloud.mainsvoltageL2L3N
                                                            .value
                                                            .toString() +
                                                        " " +
                                                        cloud.mainsvoltageL3N
                                                            .unit,
                                          ),
                                          infotile(
                                            title: "L1",
                                            value: cloud.LoadAL1.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud
                                                            .LoadAL1.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadAL1.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadAL1.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadAL1.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadAL1.value
                                                        .toString() +
                                                    " " +
                                                    cloud.LoadAL1.unit,
                                          ),
                                          infotile(
                                            title: "L2",
                                            value: cloud.LoadAL2.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud
                                                            .LoadAL2.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadAL2.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadAL2.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadAL2.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadAL2.value
                                                        .toString() +
                                                    " " +
                                                    cloud.LoadAL2.unit,
                                          ),
                                          infotile(
                                            title: "L3",
                                            value: cloud.LoadAL3.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud
                                                            .LoadAL3.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadAL3.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadAL3.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadAL3.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadAL3.value
                                                        .toString() +
                                                    " " +
                                                    cloud.LoadAL3.unit,
                                          ),

                                          //Remove Load KVA and Load KVR
                                          //  infotile(
                                          //   title: "Load KVA",
                                          //   value: cloud.LoadKva.value.toString() == '65523' || cloud.LoadKva.value.toString() == '32678' ||
                                          //   cloud.LoadKva.value.toString().compareTo('3267.8') == 0 || cloud.LoadKva.value.toString() == '65536' ||
                                          //   cloud.LoadKva.value.toString().compareTo('6553.6') == 0 ? 'N/A' : cloud.LoadKva.value.toString() + " "+ cloud.LoadKva.unit,
                                          // ),
                                          // infotile(
                                          //   title: "Load KVr",
                                          //   value: cloud.LoadKvar.value.toString() == '65523' || cloud.LoadKvar.value.toString() == '32678' ||
                                          //   cloud.LoadKvar.value.toString().compareTo('3267.8') == 0 || cloud.LoadKvar.value.toString() == '65536' ||
                                          //   cloud.LoadKvar.value.toString().compareTo('6553.6') == 0 ? 'N/A' : cloud.LoadKvar.value.toString() + " "+ cloud.LoadKvar.unit,
                                          // ),
                                          infotile(
                                            title: "Energy",
                                            value: cloud.LoadKWh.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud
                                                            .LoadKWh.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadKWh.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadKWh.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadKWh.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadKWh.value
                                                        .toString() +
                                                    " " +
                                                    cloud.LoadKWh.unit,
                                          ),
                                          infotile(
                                            title: "Hz",
                                            value: cloud.mainsFrequency.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.mainsFrequency.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.mainsFrequency.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.mainsFrequency.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.mainsFrequency.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.mainsFrequency.value
                                                        .toString() +
                                                    " " +
                                                    cloud.mainsFrequency.unit,
                                          ),
                                          infotile(
                                            title: "Pf ",
                                            value: cloud.LoadPowerFactor.value
                                                            .toString() ==
                                                        '65523' ||
                                                    cloud.LoadPowerFactor.value
                                                            .toString() ==
                                                        '32678' ||
                                                    cloud.LoadPowerFactor.value
                                                            .toString()
                                                            .compareTo(
                                                                '3267.8') ==
                                                        0 ||
                                                    cloud.LoadPowerFactor.value
                                                            .toString() ==
                                                        '65536' ||
                                                    cloud.LoadPowerFactor.value
                                                            .toString()
                                                            .compareTo(
                                                                '6553.6') ==
                                                        0
                                                ? 'N/A'
                                                : cloud.LoadPowerFactor.value
                                                    .toString(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ]),
                          ],
                          if (isFetched == false) ...[
                            Custom_Alert(
                                Title: 'Error Has Occured',
                                Description:
                                    "Something Went Wrong!, Please Check Your Internet Connection And Wait For The Next Reload.")
                          ],
                          if (isFetched == null) ...[
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SpinKitCircle(
                                    color: Colors.black,
                                    size: 65,
                                  ),
                                ],
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                )));
  }

  DropdownMenuItem<String> buildMenuItem(ConfigurationModel model) =>
      DropdownMenuItem(
          value: model.generatorId, child: Text(model.generatorName));
}

class infotile extends StatelessWidget {
  String title, value;
  infotile({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: lightBorderColor,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontFamily: PoppinsFamily,
              fontSize: 14,
              color: mainBlackColorTheme),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(bottom: 6, top: 6, left: 16, right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: mainColorTheme, width: 1),
                color: Colors.transparent,
              ),
              child: Text(value == "" ? "0" : value,
                  style: TextStyle(
                      color: mainColorTheme,
                      fontSize: 14,
                      fontFamily: PoppinsFamily)),
            ),
          ),
        ),
      ),
    );
  }
}

class Custom_Alert extends StatelessWidget {
  String Title;
  String Description;
  Custom_Alert({required this.Title, required this.Description});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        new Text(
          Title,
          style: TextStyle(color: Color(0XFF130925)),
        ),
      ]),
      content: new Text(
        Description,
        style: TextStyle(color: Colors.purple),
      ),
      actions: <Widget>[],
    );
  }
}
