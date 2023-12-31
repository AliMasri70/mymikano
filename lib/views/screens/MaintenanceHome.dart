import 'package:flutter/material.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/MaintenanceGridListScreen.dart';
import 'package:mymikano_app/views/widgets/TopRowBar.dart';
import 'package:nb_utils/nb_utils.dart';

import 'MyRepairsScreen.dart';

class T5Maintenance extends StatefulWidget {
  static var tag = "/T5Dashboard";

  @override
  T5MaintenanceState createState() => T5MaintenanceState();
}

class T5MaintenanceState extends State<T5Maintenance> {
  bool passwordVisible = false;
  bool isRemember = false;
  var currentIndexPage = 0;
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  void changeSldier(int index) {
    setState(() {
      currentIndexPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - 50;

    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: TopRowBar(
                title: lbl_Maintenace_And_Repair,
              ),
              bottom: TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4.0,
                    color: mainColorTheme,
                  ),
                  insets: EdgeInsets.fromLTRB(15.0, 0.0, 140.0, 0.0),
                ),
                indicatorColor: mainColorTheme,
                indicatorWeight: 4,
                labelStyle: boldTextStyle(color: mainBlackColorTheme),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Maintenance",
                          style: TextStyle(color: mainBlackColorTheme),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "My Repairs",
                          style: TextStyle(color: mainBlackColorTheme),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                  child: MaintenanceGridListScreen(),
                ),
                MyRepairsScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
