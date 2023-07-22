import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:mymikano_app/State/ApiConfigurationState.dart';
import 'package:mymikano_app/State/CloudGeneratorState.dart';
import 'package:mymikano_app/State/CurrencyState.dart';
import 'package:mymikano_app/State/LanGeneratorState.dart';
import 'package:mymikano_app/State/NotificationState.dart';
import 'package:mymikano_app/State/RequestFormState.dart';
import 'package:mymikano_app/State/WSVGeneratorState.dart';
import 'package:mymikano_app/models/ConfigurationModel.dart';
import 'package:mymikano_app/services/LanNotificationServicee.dart';
import 'package:mymikano_app/services/pushNotificationService.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/Dashboard/AlarmPage.dart';
import 'package:mymikano_app/views/screens/Dashboard/Dashboard_Index.dart';
import 'package:mymikano_app/views/screens/Dashboard/GeneratorAlertsPage.dart';
import 'package:mymikano_app/views/screens/Dashboard/NotificationPage.dart';
import 'package:mymikano_app/views/screens/SplashScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'State/ApiConfigurationStatee.dart';
import 'State/CarouselState.dart';
import 'State/InspectionsState.dart';
import 'State/LoadCalculationState.dart';
import 'State/MainDashboardState.dart';
import 'State/PDFState.dart';
import 'State/ProductState.dart';
import 'State/UserState.dart';
import 'models/LanAlarm.dart';

final GlobalKey<NavigatorState> navigator =
    GlobalKey<NavigatorState>(); //Create a key for navigator

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //aded by yousef k for lan notification
  AwesomeNotifications()
      .initialize('resource://drawable/ic_notification_icon', [
    // notification icon
    NotificationChannel(
      channelGroupKey: 'LanNotification_test',
      channelKey: 'LanNotification',
      channelName: 'LanNotification',
      channelDescription: 'Notification channel for lan',
      channelShowBadge: true,
      importance: NotificationImportance.High,
      enableVibration: true,
    ),
  ]);
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  // String config = await prefs.getString(prefs_ApiLanEndpoint) ?? "";
  ///////////setSystemUIOverlayStyle(style))))))//////////
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarBrightness: Brightness.light,
  //   statusBarColor: Colors.white,
  //   statusBarIconBrightness: Brightness.dark,
  // ));
  FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  // if (config.isNotEmpty) {
  //   print("in configggg");

  initializeService();
  // } else {
  //   print("not initialized yet");
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging _fcm = FirebaseMessaging.instance;
    PushNotificationService notificationService = PushNotificationService(_fcm);
    notificationService.initialise(context);
    // FirebaseMessaging.onBackgroundMessage(notificationService.messageHandler);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductState>(
            create: (context) => ProductState()),
        ChangeNotifierProvider<UserState>(create: (context) => UserState()),
        ChangeNotifierProvider<InspectionsState>(
            create: (context) => InspectionsState()),
        ChangeNotifierProvider<ApiConfigurationState>(
            create: ((context) => ApiConfigurationState())),
        ChangeNotifierProvider<ApiConfigurationStatee>(
            create: ((context) => ApiConfigurationStatee())),
        ChangeNotifierProvider<RequestFormState>(
            create: ((context) => RequestFormState())),
        ChangeNotifierProvider<CarouselState>(
            create: ((context) => CarouselState())),
        ChangeNotifierProvider<CloudGeneratorState>(
            create: ((context) => CloudGeneratorState())),
        ChangeNotifierProvider<LanGeneratorState>(
            create: ((context) => LanGeneratorState())),
        ChangeNotifierProvider<WSVGeneratorState>(
            create: ((context) => WSVGeneratorState())),
        ChangeNotifierProvider<CurrencyState>(
            create: ((context) => CurrencyState())),
        ChangeNotifierProvider<LoadCalculationState>(
            create: ((context) => LoadCalculationState())),
        ChangeNotifierProvider<MainDashboardState>(
            create: ((context) => MainDashboardState())),
        ChangeNotifierProvider<NotificationState>(
            create: ((context) => NotificationState())),
        ChangeNotifierProvider<PDFState>(create: (context) => PDFState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: !isProduction,
        navigatorKey: navigator,
        title: 'My Mikano',
        theme: ThemeData(
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: PoppinsFamily),
        home: new SplashScreen(),
      ),
    );
  }
}
