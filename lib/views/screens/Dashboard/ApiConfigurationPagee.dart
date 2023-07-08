import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/Dashboard/FetchGenerators.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TopRowBar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../State/ApiConfigurationStatee.dart';

class ApiConfigurationPagee extends StatelessWidget {
  ApiConfigurationPagee({Key? key}) : super(key: key);

  final cloudUsernameController = TextEditingController();
  final cloudPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiConfigurationStatee>(
      builder: (context, value, child) => Scaffold(
        body: SafeArea(
          child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
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
                  // if (value.DashBoardFirstTimeAccess == true) ...[
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            T13Button(
                                textContent: lbl_Fetch_Generators,
                                onPressed: () async {
                                  
                                 
                                  await value.getGeneratorIds(
                                      cloudUsernameController.text,
                                      cloudPasswordController.text);
                                  //we need to save the cloudusername and password to shared pref and then got to fetch generator page//
                                  
                                  //value.Loading(true);
                                  await value.saveCloudUser(
                                    cloudUsernameController.text,
                                    cloudPasswordController.text,
                                  );
                                  if (value.isSuccess) {
                                   // value.isNotFirstTime();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        // builder: (context) => ApiConfigurationPage(),
                                        builder: (context) => FetchGenerators(RefreshRate: 1),
                                      ),
                                    );
                                  }
                                }),
                          ]),
                    ]),
                  )
                ]),
              ),
            )
          ]),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String selectedSSID) =>
      DropdownMenuItem(value: selectedSSID, child: Text(selectedSSID));
}

enum ConfigValue { withConfig, withoutConfig }
