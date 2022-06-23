import 'package:flutter/material.dart';
import 'package:mymikano_app/State/ApiConfigurationState.dart';
import 'package:mymikano_app/views/screens/Dashboard/ApiConfigurationPage.dart';
import 'package:mymikano_app/views/widgets/TopRowBar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class Dashboard_Test extends StatefulWidget {
  const Dashboard_Test({Key? key}) : super(key: key);

  @override
  _Dashboard_TestState createState() => _Dashboard_TestState();
}

class _Dashboard_TestState extends State<Dashboard_Test> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiConfigurationState>(
      builder: (context, value, child) => Scaffold(
          body: SafeArea(
        child: Column(children: [
          TopRowBar(title: 'DashBoard_Test'),
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (prefs.getBool('DashboardFirstTimeAccess')! == false) {
                  value.DashBoardFirstTimeAccess =
                      prefs.getBool('DashboardFirstTimeAccess')!;
                  debugPrint("it's not first time");
                }

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ApiConfigurationPage()));
              },
              icon: Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                value.resetPreferences();
              },
              icon: Icon(Icons.refresh))
        ]),
      )),
    );
  }
}
