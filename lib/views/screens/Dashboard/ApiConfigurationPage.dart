import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymikano_app/State/ApiConfigurationState.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/Dashboard/CloudDashboard_Index.dart';
import 'package:mymikano_app/views/screens/Dashboard/Dashboard_Index.dart';
import 'package:mymikano_app/views/screens/Dashboard/LanDashboard_Index.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TopRowBar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ApiConfigurationPage extends StatelessWidget {
  ApiConfigurationPage({Key? key}) : super(key: key);
  final refreshRateController = TextEditingController();
  final cloudUsernameController = TextEditingController();
  final cloudPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final apiEndpointLanController = TextEditingController(text: lanESPUrl);
  bool isFirstTimeInThisPage = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiConfigurationState>(
      builder: (context, value, child) => Scaffold(
          body: SafeArea(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  TopRowBar(title: lbl_API_Configuration),
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
                          side: BorderSide(width: 2.0, color: mainColorTheme),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          padding: EdgeInsets.all(0.0),
                        ),
                        onPressed: () {
                          value.ChangeMode('lan');
                          //added by youssef//
                          value.changeCloudConfigValue(true);
                          if (value.DashBoardFirstTimeAccess == false) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LanDashboard_Index(
                                      RefreshRate: value.RefreshRate,
                                    )));
                          }
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
                          side: BorderSide(width: 2.0, color: mainColorTheme),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          padding: EdgeInsets.all(0.0),
                        ),
                        onPressed: () {
                          value.ChangeMode('cloud');
                          //added by youssef
                          value.changeCloudConfigValue(false);
                          if (value.DashBoardFirstTimeAccess == false) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CloudDashboard_Index(
                                      RefreshRate: value.RefreshRate,
                                    )));
                          }
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
                          side: BorderSide(width: 2.0, color: mainColorTheme),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          padding: EdgeInsets.all(0.0),
                        ),
                        onPressed: () {
                          value.ChangeMode('comap');
                          if (value.DashBoardFirstTimeAccess == false) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Dashboard_Index()));
                          }
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
                  if (value.DashBoardFirstTimeAccess == true &&
                      value.cloudMode == 1) ...[
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

                    // ListTile(
                    //   title: const Text('With Configuration'),
                    //   leading: Radio(
                    //     value: ConfigValue.withConfig,
                    //     groupValue: value.cloudConfigValue,
                    //     onChanged: (ConfigValue? val) =>
                    //     {
                    //       value.changeCloudConfigValue(val),
                    //     }
                    //   ),
                    // ),
                    // ListTile(
                    //   title: const Text('Without Configuration'),
                    //   leading: Radio(
                    //     value: ConfigValue.withoutConfig,
                    //     groupValue: value.cloudConfigValue,
                    // onChanged: (ConfigValue? val)
                    // {
                    //   value.changeCloudConfigValue(val);
                    // }
                    //   ),
                    // ),
                  ],
                  if (value.DashBoardFirstTimeAccess == true) ...[
                    Expanded(
                      child: Column(children: [
                        TextFormField(
                          onChanged: (username) =>
                              value.changeCloudUsername(username),
                          style: TextStyle(
                              fontSize: textSizeMedium,
                              fontFamily: PoppinsFamily),
                          obscureText: false,
                          cursorColor: black,
                          controller: cloudUsernameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
                            hintText: lbl_Cloud_Username,
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
                        SizedBox(height: 20),
                        t13EditTextStyle(
                            lbl_Cloud_Password, cloudPasswordController),
                        SizedBox(height: 20),
                        SizedBox(height: 10),
                        if (value.isSuccess == true && value.Message != "")
                          Container(
                              width: MediaQuery.of(context).size.width - 16,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: GreenColor.withOpacity(0.1)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: GreenColor),
                                      child: Icon(
                                        Icons.check_sharp,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                  Text(value.Message)
                                ],
                              )),
                        if (value.isSuccess == false && value.Message != "")
                          Container(
                              width: MediaQuery.of(context).size.width - 16,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mainColorTheme.withOpacity(0.1)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(Icons.error,
                                          color: mainColorTheme, size: 20)),
                                  Text(value.Message)
                                ],
                              )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              width: MediaQuery.of(context).size.width / 2.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mainGreyColorTheme)),
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
                                      value.ChooseGeneratorName(
                                          item.toString());
                                      int i = (value.gens).indexWhere(
                                          (element) =>
                                              element.name == item.toString());
                                      value.setChosenGeneratorId(
                                          value.gens.elementAt(i).generatorId);
                                    }),
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 50,
                              child: T13Button(
                                  textContent: lbl_Fetch_Generators,
                                  onPressed: () async {
                                    value.getGeneratorIds(
                                        cloudUsernameController.text,
                                        cloudPasswordController.text);
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        if (value.isSuccess == true &&
                            value.cloudConfigValue == true) ...[
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
                          t13EditTextStyle(
                              lbl_hint_password, passwordController),
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
                              contentPadding:
                                  EdgeInsets.fromLTRB(26, 14, 4, 14),
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
                                value.Loading(true);

                                if (value.DashBoardFirstTimeAccess == true) {
                                  await value.setpref(
                                      value.chosenSSID,
                                      passwordController.text,
                                      int.parse(refreshRateController.text),
                                      cloudUsernameController.text,
                                      cloudPasswordController.text,
                                      value.cloudMode,
                                      value.chosenGeneratorId);
                                }

                                await value.service.Connecttossid(
                                    value.chosenSSID,
                                    passwordController.text,
                                    cloudUsernameController.text,
                                    cloudPasswordController.text,
                                    value.cloudMode.toString(),
                                    value.chosenGeneratorId,
                                    "");

                                // value.service.RestartESP();
                                Timer(Duration(seconds: 15), () {
                                  // to add before this switch to cloud mode as get request to the esp
                                  value.Loading(false);
                                });
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
                              contentPadding:
                                  EdgeInsets.fromLTRB(26, 14, 4, 14),
                              hintText: lbl_Api_Endpoint,
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
                          SizedBox(height: 20),
                          T13Button(
                              textContent: lbl_Submit_Settings,
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                value.setApiLanEndpoint(
                                    "http://" + apiEndpointLanController.text);
                                if (value.option == 'cloud') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CloudDashboard_Index(
                                              RefreshRate: value.RefreshRate)));
                                } else if (value.option == 'comap') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Dashboard_Index()));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LanDashboard_Index(
                                            RefreshRate: value.RefreshRate,
                                          )));
                                }
                               value.isNotFirstTime();
                              prefs.setBool(
                                    prefs_DashboardFirstTimeAccess, false);
                              }),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                        if (value.isSuccess == true &&
                            value.cloudConfigValue == false &&
                            value.option == 'cloud')
                          T13Button(
                              textContent: lbl_Submit_Settings,
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                value.setApiLanEndpoint(
                                    "http://" + apiEndpointLanController.text);
                                if (value.DashBoardFirstTimeAccess == true) {
                                  await value.setpref(
                                      "",
                                      "",
                                      10,
                                      cloudUsernameController.text,
                                      cloudPasswordController.text,
                                      value.cloudMode,
                                      value.chosenGeneratorId);
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CloudDashboard_Index(RefreshRate: 1)));
                                value.isNotFirstTime();
                               prefs.setBool(
                                  prefs_DashboardFirstTimeAccess, false);  
                              }),
                      ]),
                    ),
                  ],
                ]),
              ),
            )
          ],
        ),
      )),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String selectedSSID) =>
      DropdownMenuItem(value: selectedSSID, child: Text(selectedSSID));
}

enum ConfigValue { withConfig, withoutConfig }
