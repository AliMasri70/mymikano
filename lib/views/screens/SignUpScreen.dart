import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mymikano_app/services/RegisterService.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/AppWidget.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:nb_utils/nb_utils.dart';

import 'SignInScreen.dart';

class T13SignUpScreen extends StatefulWidget {
  static String tag = '/T13SignUpScreen';

  @override
  T13SignUpScreenState createState() => T13SignUpScreenState();
}

class T13SignUpScreenState extends State<T13SignUpScreen> {
  final usernameController = TextEditingController();
  final fnController = TextEditingController();
  final lnController = TextEditingController();
  final emlController = TextEditingController();
  final passwController = TextEditingController();
  final confpasswController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;

  // regular expression to check if string
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  //A function that validate user entered password
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  bool matchPassword(String pass, String secondPass) {
    String _password = pass.trim();
    String _secondPassword = secondPass.trim();
    if (_password == _secondPassword) {
      return true;
    } else {
      return false;
    }
  }

  bool _isStatusBarHidden = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                    left: spacing_standard_new, right: spacing_standard_new),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Navigator.pop(context);
                              finish(context);
                            },
                            icon: Icon(Icons.arrow_back_ios),
                            color: Colors.black,
                          ),
                        ],
                      ),
                      // commonCacheImageWidget(lbl_ic_logo, 85, width: width * 0.8),
                      TitleText(
                        title: 'Sign Up here',
                      ),
                      SizedBox(height: spacing_middle),
                      SizedBox(height: spacing_standard_new),
                      t13EditTextStyle("Username", usernameController,
                          isPassword: false),
                      SizedBox(height: spacing_standard_new),
                      t13EditTextStyle("Firstname", fnController,
                          isPassword: false),
                      SizedBox(height: spacing_standard_new),
                      t13EditTextStyle("Lastname", lnController,
                          isPassword: false),
                      SizedBox(height: spacing_standard_new),
                      t13EditTextStyle(lbl_hint_Email, emlController,
                          isPassword: false),
                      SizedBox(height: spacing_standard_new),
                      // t13EditTextStyle(lbl_hint_password, passwController,
                      //     isPassword: true),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill in the field";
                          } else {
                            //call function to check password
                            bool result = validatePassword(value);
                            if (result) {
                              // create account event
                              return null;
                            } else {
                              return "Password should contain Capital, small letter, Number & Special";
                            }
                          }
                        },
                        style: TextStyle(
                            fontSize: textSizeMedium,
                            fontFamily: PoppinsFamily),
                        obscureText: !_passwordVisible,
                        cursorColor: black,
                        controller: passwController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              !_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
                          hintText: lbl_hint_password,
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
                      SizedBox(height: spacing_standard_new),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill in the field";
                          } else {
                            //call function to check password
                            bool result = matchPassword(
                                value, passwController.text.toString());
                            if (result) {
                              // create account event
                              return null;
                            } else {
                              return "Passwords should match";
                            }
                          }
                        },
                        style: TextStyle(
                            fontSize: textSizeMedium,
                            fontFamily: PoppinsFamily),
                        obscureText: !_passwordVisible2,
                        cursorColor: black,
                        controller: confpasswController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              !_passwordVisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible2 = !_passwordVisible2;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
                          hintText: "Confirm Password",
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
                      SizedBox(height: spacing_large),
                      T13Button(
                          textContent: lbl_Create_Account,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              Register(
                                  usernameController.text.toString(),
                                  fnController.text.toString(),
                                  lnController.text.toString(),
                                  emlController.text.toString(),
                                  passwController.text.toString(),
                                  this.context);
                            }
                          }),
                      SizedBox(height: spacing_large),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          text(lbl_lbl_already_member,
                              textColor: mainGreyColorTheme),
                          SizedBox(width: spacing_control),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => T13SignInScreen())),
                            child: Container(
                              child: text(lbl_lbl_login,
                                  fontSize: 14.0, textColor: mainColorTheme),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
