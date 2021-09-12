import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mymikano_app/services/pushNotificationService.dart';
import 'package:mymikano_app/utils/main/store/AppStore.dart';
import 'package:mymikano_app/views/screens/InspectionScreen.dart';
import 'package:mymikano_app/views/screens/MyInspectionsScreen.dart';
import 'package:mymikano_app/views/screens/MainDashboard.dart';
import 'package:mymikano_app/views/screens/MyRequestsScreen.dart';
import 'package:mymikano_app/views/screens/SDDashboardScreen.dart';
import 'package:mymikano_app/views/screens/SDExamScreen.dart';
import 'package:mymikano_app/views/screens/SignInScreen.dart';
import 'package:mymikano_app/views/screens/SplashScreen.dart';
import 'package:mymikano_app/views/screens/TechnicianHome.dart';
import 'package:sizer/sizer.dart';

AppStore appStore = AppStore();

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging _fcm = FirebaseMessaging.instance;
    PushNotificationService(_fcm).initialise(context);
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'My Mikano',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: new OPSplashScreen(),
      );
    });
  }
}
