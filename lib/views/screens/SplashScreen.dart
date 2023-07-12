import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mymikano_app/utils/images.dart';
import 'package:mymikano_app/views/screens/EntryPage.dart';
import 'package:mymikano_app/views/widgets/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'Dashboard/NotificationPage.dart';
import 'MainDashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('IsLoggedIn') == true);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4), () {
      checkIfLoggedIn().then((value) {
        if (value) {
          finish(context);
          // Provider.of<CurrencyState>(context, listen: false).update();
          // Provider.of<ProductState>(context, listen: false).update();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Theme5Dashboard(),
                settings: RouteSettings(name: 'dashboard')),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EntryPage()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: commonCacheImageWidget(Splash_Screen_Mikano_Logo, 200),
      ),
    );
  }
}
