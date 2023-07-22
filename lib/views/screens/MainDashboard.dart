import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymikano_app/State/CurrencyState.dart';
import 'package:mymikano_app/State/MainDashboardState.dart';
import 'package:mymikano_app/State/ProductState.dart';
import 'package:mymikano_app/services/LanNotificationServicee.dart';
import 'package:mymikano_app/services/PaymentService.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/images.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/MenuScreen.dart';
import 'package:mymikano_app/views/widgets/BankingBottomNavigationBar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'CartPage.dart';
import 'DashboardScreen.dart';
import 'ListPage.dart';
import 'ProfileScreen.dart';

class Theme5Dashboard extends StatefulWidget {
  @override
  _Theme5DashboardState createState() => _Theme5DashboardState();
}

class _Theme5DashboardState extends State<Theme5Dashboard> {
  var selectedIndex = 2;
  var pages = [];
  bool guestLogin = true;
  bool _isStatusBarHidden = false;

  init() async {
    pages.add(MenuScreen());
    pages.add(ListPage(
      title: lbl_Search,
      IsCategory: false,
    ));
    // pages.add(SearchPage());
    pages.add(Dashboard());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    guestLogin = prefs.getBool("GuestLogin")!;
    if (!guestLogin) {
      pages.add(CartPage());
    }
    if (!guestLogin) {
      pages.add(ProfileScreen());
    }
    Provider.of<MainDashboardState>(context, listen: false).setSelectedIndex(2);
    setState(() {});
    await PaymentService().initSdk();
    // Future.delayed(Duration(seconds: 5), () async {
    //   await PaymentService()
    //       .initSdk(Provider.of<CurrencyState>(context, listen: false).currency);
    // });
    try {
      await Provider.of<CurrencyState>(context, listen: false).update();
      await Provider.of<ProductState>(context, listen: false)
          .update(isGuestLogin: guestLogin);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    init();
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainDashboardState>(
      builder: ((context, mainDashboardState, child) => WillPopScope(
            onWillPop: () async {
              bool toExit = false;
              await showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Exit Dialog'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Are you sure you want to exit the app?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context);
                          toExit = true;
                        },
                      ),
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                          toExit = false;
                        },
                      ),
                    ],
                  );
                },
              );
              return toExit;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: BankingBottomNavigationBar(
                backgroundColor: bottomNavigationBarColor,
                selectedItemColor: bottomNavigationBarSelectedItemColor,
                unselectedItemColor: Colors.white,
                items: <BankingBottomNavigationBarItem>[
                  BankingBottomNavigationBarItem(icon: ic_menu),
                  BankingBottomNavigationBarItem(icon: ic_search),
                  BankingBottomNavigationBarItem(icon: ic_dog_house),
                  if (!guestLogin)
                    BankingBottomNavigationBarItem(icon: ic_handcart),
                  if (!guestLogin)
                    BankingBottomNavigationBarItem(icon: ic_customer),
                ],
                currentIndex: mainDashboardState.selectedIndex(),
                unselectedIconTheme:
                    IconThemeData(color: mainGreyColorTheme, size: 20),
                selectedIconTheme: IconThemeData(
                    color: bottomNavigationBarSelectedItemColor, size: 20),
                onTap: mainDashboardState.setSelectedIndex,
                type: BankingBottomNavigationBarType.fixed,
              ),
              body: pages[mainDashboardState.selectedIndex()],
            ),
          )),
    );
  }
}
