import 'dart:async';
import 'dart:convert';

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
import 'package:mymikano_app/views/screens/Dashboard/FetchGenerators.dart';
import 'package:mymikano_app/views/screens/Dashboard/GeneratorAlertsPage.dart';
import 'package:mymikano_app/views/screens/Dashboard/LanDashboard_Index.dart';
import 'package:mymikano_app/views/screens/MenuScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:mymikano_app/services/CloudDashboard_Service.dart';
import '../../../State/ApiConfigurationStatee.dart';
import '../../widgets/Custom_GaugeWidget.dart';

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
    if(configsList.length != 0){
       prefs.setBool(
       prefs_DashboardFirstTimeAccess, false);
    }
    ConfigurationModel config = ConfigurationModel.fromJson(
        json.decode(prefs.getString('SelectedConfigurationModel')!));
    configModel = config;
    return configModel;
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
                                     Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MenuScreen()));
                                    },
                                  ),
                                  Spacer(),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
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
                                          //value:value.selectedConfigurationModel.generatorId,
                                          value: configModel.generatorId,
                                          onChanged: (item) async { 
                              
                                            ConfigurationModel model = value
                                                .configsList
                                                .firstWhere((element) =>
                                                    element.generatorId ==
                                                    item);       
                                            value.configModel = model;
                                            
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
                                        
                                            value.resetPreferences(configModel.espapiendpoint);
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ApiConfigurationPage()));
                                            value.generatorNameList.add(
                                                configModel.generatorName);

                                            //value.chosenGeneratorName=value.generatorNameList.elementAt(0);
                                            value.configsList.removeWhere(
                                                (element) =>
                                                    element.generatorId ==
                                                    configModel.generatorId);
                                            
                                            if (value.configsList.length != 0){
                                              value.configModel =
                                                  value.configsList.elementAt(
                                                      0);
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
                                              RefreshRate: configModel
                                                                  .refreshRate)));
                              value.isNotFirstTime();
                                            }
                                    
                                              else{
                                                 Navigator.of(context)
                                                  .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FetchGenerators()));
                                              }
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
                                                     
                             
                              value.chosenGeneratorName =
                                  value.generatorNameList.elementAt(0); 
                           
                                    Navigator.of(context)
                                                  .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FetchGenerators()));
                                         
                                            
                                      },
                                      icon: Icon(Icons.settings)),
                                  // Spacer(),
                                  // IconButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context).push(
                                  //         MaterialPageRoute(
                                  //              builder: (context) =>
                                  //                  GeneratorAlertsPage()));
                                  //    },
                                  //    icon: Icon(Icons.warning)),

                                      GestureDetector(
                                      onTap: () {
                                     /*   Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GeneratorAlertsPage())); */
                                      },
                                      child: Icon(Icons.warning)),  
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
                                    selected: cloud.ControllerModeStatus==2?true:false,
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
                                    selected: cloud.ControllerModeStatus == 1?true:false,
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
                                    label: Text("Off"),
                                     selected: cloud.ControllerModeStatus == 0?true:false,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        //_value = (selected ? 1 : null)!;
                                        cloud.changeControllerModeStatus(0); 
                                      
                                        cloud.changeIsIO(false); 
                                       
                                        
                                      });
                                    },
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
                                                    color: cloud.MCBModeStatus
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
                                              color: cloud.MCBModeStatus  
                                                  ? GreenpowerColor
                                                  : mainColorTheme,  
                                            ),
                                          )),
                                      if (cloud.ControllerModeStatus != 2)
                                        Positioned(
                                          top: 72,
                                          left: 232,
                                          child: new GestureDetector( 
                                              onTap: () {
                                           
                                                setState(() {
                                                  isOnleft = false;  
                                                  isOnMiddle = false;
                                                  isOnRight = false;
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
                                          child: new GestureDetector(
                                              onTap: (){
                                            
                                                    
                                                  setState(() async{
                                                    
                                                    
                                                    cloud.changeIsIO(true);
                                                  }
                                                   );
                                                   
                                                if ((double.parse(cloud
                                                        .GeneratorVoltage  
                                                        .value)) >
                                                    0) {
                                                  setState(() { 
                                                    isOnRight = true;  
                                                  });
                                                }
                                                if (cloud.MCBModeStatus == 
                                                    true) {
                                                  setState(() {
                                                    isOnleft = true;
                                                  });
                                                }
                                                if (cloud.isGCB == true) {
                                                  setState(() {
                                                    isOnMiddle = true;
                                                  });
                                                }
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
                                              color: isOnRight
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
                                              color: isOnMiddle
                                                  ? GreenpowerColor
                                                  : mainColorTheme,
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
                                              color: cloud.isGCB
                                                  ? GreenpowerColor
                                                  : mainGreyColorTheme,
                                            ),
                                          )),
                                      if (cloud.ControllerModeStatus != 2)
                                        Positioned(
                                          top: 72,
                                          left: 67,
                                          
                                          child: new GestureDetector(
                                              onTap: () {
                                                    if(cloud.MCBModeStatus == false){

                                                      cloud.changeMCBModeStatus(
                                                          true);  
                                                    }
                                                    else{
                                                      cloud.changeMCBModeStatus(
                                                          false); 
                                                    }
                                                    
                                              },
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
                                          child: new GestureDetector(
                                          
                                              onTap: () {
                                                
                                                 if(cloud.isGCB==false){
                                                   
                                                    
                                                      cloud.changeIsGCB(true);
                                                 }
                                                 else{
                                                  cloud.changeIsGCB(false);
                                                 }
                                                    
                                              },
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
                                            max: cloud.nominalLoadkW.value.toDouble(),
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
                                    title: Text(lbl_Engine),
                                    children: [
                                      ListView(
                                        physics: const ScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          infotile(
                                            title: lbl_Pressure,
                                            value: (double.parse(
                                                    cloud.OilPressure.value))
                                                .toString(),
                                          ),
                                          infotile(
                                            title: lbl_Temperature,
                                            value: cloud.CoolantTemp.value
                                                .toString(),
                                          ),
                                          infotile(
                                            title: "Fuel Level",
                                            value: cloud.FuelLevel.value
                                                .toString(),
                                          ),
                                          infotile(
                                            title: "Running Hours",
                                            value: cloud.RunningHours.value
                                                .toString(),
                                          ),
                                          infotile(
                                            title: "Battery Voltage",
                                            value: cloud.BatteryVoltage.value
                                                .toString(),
                                          ),
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
                                            value: cloud.generatorL1N.value.toString(),
                                          ),
                                          infotile(
                                            title: "L2-N",
                                            value: cloud.generatorL2N.value.toString(),
                                          ),
                                          infotile(
                                            title: "L3-N",
                                            value: cloud.generatorL3N.value.toString(),
                                          ),
                                          infotile(
                                            title: "L1",
                                            value: cloud.LoadAL1.value.toString(),
                                          ),
                                          infotile(
                                            title: "L2",
                                            value: cloud.LoadAL2.value.toString(),
                                          ),
                                          infotile(
                                            title: "L3",
                                            value: cloud.LoadAL3.value.toString(),
                                          ),
                                          infotile(
                                            title: "Hz",
                                            value: cloud.GeneratorFrequency.value.toString(),
                                          ),
                                          infotile(
                                            title: "Pf",
                                            value: cloud.LoadPowerFactor.value.toString(),
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
                                            value: cloud.mainsvoltageL1N.value.toString(),
                                          ),
                                          infotile(
                                            title: "L2-N",
                                            value: cloud.mainsvoltageL2N.value.toString(),
                                          ),
                                          infotile(
                                            title: "L3-N",
                                            value: cloud.mainsvoltageL3N.value.toString(),
                                          ),
                                          infotile(
                                            title: "L1",
                                            value: cloud.LoadAL1.value.toString(),
                                          ),
                                          infotile(
                                            title: "L2",
                                            value: cloud.LoadAL2.value.toString(),
                                          ),
                                          infotile(
                                            title: "L3",
                                            value: cloud.LoadAL3.value.toString(),
                                          ),
                                          infotile(
                                            title: "Hz",
                                            value: cloud.mainsFrequency.value.toString(),
                                          ),
                                          infotile(
                                            title: "Pf",
                                            value: cloud.LoadPowerFactor.value.toString(),
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
