import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mymikano_app/State/UserState.dart';
import 'package:mymikano_app/services/LogoutService.dart';
import 'package:mymikano_app/services/StoreServices/CustomerService.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/SubTitleText.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../services/LocalUserPositionService.dart';
import 'PrivacyPolicyScreen.dart';
import 'ProfileEditScreen.dart';
import 'PurchasesScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool privacyPolicyAccepted = false;

  bool switchstate = false;
  bool serviceEnabled = false;
  @override
  void initState() {
    checkLocationServicesEnabled();
    super.initState();
  }

  Future<void> setGPSService(bool value) async {
    print("GPSEnabled 2 : " + value.toString());
    if (value == false) {
      // GeolocatorPlatform.instance.checkPermission();
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

      // Disable location updates
      await geolocator.openAppSettings();
    } else {
      getLocation();
    }
  }

  void getLocation() async {
    // await Geolocator.isLocationServiceEnabled();

    await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    // sendGpsCoord();

    checkLocationServicesEnabled();
  }

  void sendGpsCoord() async {
    // gps().canceled = false;
    gps.StartTimer();
  }

  Future<void> checkLocationServicesEnabled() async {
    LocationPermission permission;

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permission is permanently denied, handle accordingly
      setState(() {
        serviceEnabled = false;
      });
    }

    // Request location permission if it is not granted
    if (permission == LocationPermission.denied) {
      // Location permission is denied, handle accordingly
      setState(() {
        serviceEnabled = false;
      });
    }

    // Request location permission if it is not granted
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // Location permission is denied, handle accordingly
      setState(() {
        serviceEnabled = true;
      });
    }

    print("GPSEnabled 33: " + serviceEnabled.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, state, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TitleText(
                    title: lbl_Profile,
                  ),
                ),
                // TopRowBar(title: lbl_Profile),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                  child: SubTitleText(title: lbl_Account),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 32.5,
                            backgroundColor: lightBorderColor,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${state.getUser.username}',
                                  style: TextStyle(
                                      color: mainBlackColorTheme,
                                      fontSize: 18,
                                      fontFamily: PoppinsFamily),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 6.0, 0.0, 0.0),
                                  child: Text(
                                    state.getUser.email,
                                    style: TextStyle(
                                        color: mainGreyColorTheme,
                                        fontSize: 14,
                                        fontFamily: PoppinsFamily),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                        Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: ((context) => ProfileEditScreen()))),
                          icon: Icon(
                            Icons.edit,
                            color: mainGreyColorTheme,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: lightBorderColor,
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SubTitleText(
                              title: lbl_Notifications,
                            ),
                          ),
                          Switch(
                            value: state.NotificationsEnabled,
                            onChanged: (value) {
                              state.setNotificationsState(value);
                            },
                            activeColor: mainColorTheme,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SubTitleText(
                              title: lbl_gps,
                            ),
                          ),
                          Switch(
                            value: serviceEnabled,
                            onChanged: (value) {
                              print("GPSEnabled : " + value.toString());
                              setGPSService(value);
                            },
                            activeColor: mainColorTheme,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SubTitleText(
                              title: lbl_Language,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 14.0, 0.0),
                                    child: Text(
                                      'English',
                                      style: TextStyle(
                                          color: mainGreyColorTheme,
                                          fontSize: 14,
                                          fontFamily: PoppinsFamily),
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: mainGreyColorTheme),
                                      child: Icon(
                                        Icons.keyboard_arrow_right_outlined,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SubTitleText(
                              // title: lbl_Purchases,
                              title: "My Orders",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PurchasesScreen()));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: mainGreyColorTheme),
                                  child: Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SubTitleText(
                              title: lbl_Privacy,
                            ),
                          ),
                          state.getTermsState
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicyScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 8.0, 0.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: mainGreyColorTheme),
                                        child: Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: Colors.white,
                                        )),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicyScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 8.0, 0.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: yellowColor),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                lbl_Actions_Needed,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_right_outlined,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SubTitleText(
                              title: "Delete Account",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Delete Account"),
                                        content: Text(
                                            "Are you sure you want to delete your account?"),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0)),
                                              padding: EdgeInsets.all(0.0),
                                            ),
                                            onPressed: () async {
                                              if (await CustomerService()
                                                  .deleteAccount()) {
                                                toast(
                                                    "Account deleted successfully");
                                                logout();
                                              } else {
                                                toast(
                                                    "Failed to delete account");
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14.0,
                                                    vertical: 12.0),
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          T13Button(
                                            textContent: "No",
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: mainGreyColorTheme),
                                  child: Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
