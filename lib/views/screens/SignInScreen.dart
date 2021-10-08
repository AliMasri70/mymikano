import 'package:mymikano_app/services/LoginService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/colors.dart';
import 'package:mymikano_app/utils/T13Images.dart';
import 'package:mymikano_app/utils/T13Strings.dart';
import 'package:mymikano_app/utils/T13Widget.dart';
import 'package:mymikano_app/utils/AppWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainDashboard.dart';
import 'SignUpScreen.dart';

class T13SignInScreen extends StatefulWidget {
  static String tag = '/T13SignInScreen';

  @override
  T13SignInScreenState createState() => T13SignInScreenState();
}

class T13SignInScreenState extends State<T13SignInScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget mSocial(var bgColor, var icon) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        width: width * 0.11,
        height: width * 0.11,
        child: Padding(
          padding: EdgeInsets.all(spacing_standard),
          child: Image.asset(icon, color: t13_white),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                left: spacing_standard_new, right: spacing_standard_new),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                commonCacheImageWidget(t13_ic_logo, 85, width: width * 0.8),
                SizedBox(height: spacing_xlarge),
                t13EditTextStyle(t13_hint_Email, emailController,
                    isPassword: false),
                SizedBox(height: spacing_standard_new),
                t13EditTextStyle(t13_hint_password, passController,
                    isPassword: true),
                SizedBox(height: spacing_large),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: T13Button(
                        textContent: t13_lbl_login,
                        onPressed: () async {
                          await Login(emailController.text.toString(),
                              passController.text.toString(), this.context);
                          emailController.text = "";
                          passController.text = "";
                        },
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                SizedBox(height: spacing_large),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    text(
                      t13_lbl_need_an_account,
                      textColor: t13_textColorSecondary,
                    ),
                    SizedBox(
                      width: spacing_control,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => T13SignUpScreen())),
                      child: Container(
                        child: text(t13_lbl_sign_up,
                            fontSize: 14.0, fontFamily: fontMedium),
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
