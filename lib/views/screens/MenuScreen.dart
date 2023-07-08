import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymikano_app/State/UserState.dart';
import 'package:mymikano_app/models/ConfigurationModel.dart';
import 'package:mymikano_app/services/LogoutService.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/images.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/Dashboard/CloudDashboard_Index.dart';
import 'package:mymikano_app/views/screens/Dashboard/FetchGenerators.dart';
import 'package:mymikano_app/views/screens/Dashboard/LanDashboard_Index.dart';
import 'package:mymikano_app/views/widgets/AppWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddressScreen.dart';
import 'ContactUsScreen.dart';
import 'Dashboard/ApiConfigurationPagee.dart';
import 'Dashboard/Dashboard_Index.dart';
import 'FavoritesScreen.dart';
import 'MaintenanceHome.dart';
import 'MyInspectionsScreen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with ChangeNotifier {
  bool guestLogin = true;
  bool DashboardFirstTimeAccess = true;
  int RefreshRate = 2;
  String generatorType = '';

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> initializePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.guestLogin = await prefs.getBool("GuestLogin")!;
    Provider.of<UserState>(context, listen: false).guestLogin = this.guestLogin;
    // this.guestLogin = Provider.of<UserState>(context, listen: false).guestLogin;
    this.DashboardFirstTimeAccess =
        await prefs.getBool(prefs_DashboardFirstTimeAccess)!;
    this.RefreshRate = await prefs.getInt(prefs_RefreshRate)!;
    this.generatorType =
        await prefs.getString(prefs_ApiConfigurationOption).toString();
  }

  void isNotFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.DashboardFirstTimeAccess = false;
    prefs.setBool(prefs_DashboardFirstTimeAccess, false);
    notifyListeners();
  }
  // void notFirstTimeDashboardAccess() async {
  //   this.prefs = await SharedPreferences.getInstance();
  //   this.prefs?.setBool('DashboardFirstTimeAccess', false);
  // }

  Widget getPage() {
    if (this.DashboardFirstTimeAccess == true) {
      return ApiConfigurationPagee();
    } else if (this.generatorType == 'cloud') {
      return CloudDashboard_Index(
          /*ApiEndPoint: "https//iotapi.mauto.co/api/generators/values/",*/
          RefreshRate: this.RefreshRate);
    } else if (this.generatorType == 'comap') {
      return Dashboard_Index();
    } else {
      return LanDashboard_Index(
        RefreshRate: this.RefreshRate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context, listen: false);
    String role = user.Role;

    List<String> EcommerceRoles = [
      "admin",
      "user",
      "gen client",
      "gen employee",
      "fm client",
      "fm employee",
      "gen & fm client",
      "gen & fm employee",
    ];

    List<String> GeneratorRoles = [
      "admin",
      "gen client",
      "gen employee",
      "gen & fm client",
      "gen & fm employee",
    ];

    List<String> FacilityClientRoles = [
      "admin",
      "fm client",
      "gen & fm client",
    ];

    List<String> FacilityEmployeeRoles = [
      "admin",
      "fm employee",
      "gen & fm employee",
    ];

    List<String> MenuListNames = [
      if (!guestLogin && FacilityClientRoles.contains(role))
        "Maintenance & Repair",
      if (!guestLogin && FacilityEmployeeRoles.contains(role)) "My Inspections",
      if (!guestLogin && (GeneratorRoles.contains(role))) "Generator Dashboard",
      if (!guestLogin) "Favorites",
      if (!guestLogin) "Address",
      // if (!guestLogin) "Cards",
      // "About Us",
      "Contact Us",
    ];

    List<Widget> MenuListScreens = [
      if (!guestLogin && FacilityClientRoles.contains(role)) T5Maintenance(),
      if (!guestLogin && FacilityEmployeeRoles.contains(role))
        MyInspectionsScreen(),
      if (!guestLogin && (GeneratorRoles.contains(role))) getPage(),
      if (!guestLogin) FavoritesScreen(),
      if (!guestLogin) AddressScreen(),
      // if (!guestLogin) CardsScreen(),
      // AboutUsScreen(),
      ContactUsScreen(),
    ];

    List<String> MenuListIcons = [
      if (!guestLogin && FacilityClientRoles.contains(role))
        ic_Mainteance_and_Repair,
      if (!guestLogin && FacilityEmployeeRoles.contains(role))
        ic_Mainteance_and_Repair,
      if (!guestLogin && (GeneratorRoles.contains(role))) ic_Generator_Info,
      if (!guestLogin) ic_Favorites,
      if (!guestLogin) ic_Address,
      // if (!guestLogin) ic_Cards,
      // ic_About_Us,
      ic_Contact_Us
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: menuScreenColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: spacing_standard_new,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: MenuListScreens.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MenuListScreens[index],
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                        child: Row(
                          children: [
                            commonCacheImageWidget(MenuListIcons[index], 25,
                                width: 25),
                            SizedBox(
                              width: spacing_standard_new,
                            ),
                            Text(
                              MenuListNames[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: PoppinsFamily,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Colors.white,
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        logout();
                      },
                      child: Container(
                        padding: EdgeInsetsDirectional.all(8),
                        decoration: BoxDecoration(
                            color: mainColorTheme,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          !guestLogin ? 'Sign Out' : 'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: PoppinsFamily,
                            fontSize: 18,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Powered by: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                SvgPicture.asset(
                  ic_Mauto,
                  color: Colors.white,
                  height: 22.5,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
