import 'package:flutter/material.dart';
import 'package:mymikano_app/State/UserState.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/SubTitleText.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:mymikano_app/views/widgets/TopRowBar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, state, child) => Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopRowBar(title: 'END USER LICENSE AGREEMENT', textSize: 18,),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubTitleText(title: lbl_Terms),
                    SizedBox(height: 11),
                    Text(txt_Terms,
                        style: TextStyle(
                            fontFamily: PoppinsFamily,
                            fontSize: 12,
                            color: mainGreyColorTheme)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubTitleText(title: lbl_Use_License),
                    SizedBox(height: 11),
                    Text(txt_Use_License,
                        style: TextStyle(
                            fontFamily: PoppinsFamily,
                            fontSize: 12,
                            color: mainGreyColorTheme)),
                  ],
                ),
              ),
              Spacer(),
              if (!state.getTermsState)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            finish(context);
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              color: mainBlackColorTheme,
                            ),
                            child: Center(
                                child: Text("Decline",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: PoppinsFamily))),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            state
                                .setTermsState(true)
                                .then((value) => Navigator.of(context).pop());
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              color: mainColorTheme,
                            ),
                            child: Center(
                                child: Text("Accept",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: PoppinsFamily))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        )),
      ),
    );
  }
}
