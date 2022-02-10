import 'package:flutter/material.dart';
import 'package:mymikano_app/State/UserState.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/SubTitleText.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TopRowBar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({Key? key}) : super(key: key);
  TextEditingController UsernameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var temp = Provider.of<UserState>(context);
    UsernameController.text = "${temp.getUser.username}";
    EmailController.text =
        temp.getUser.email == "null" ? "" : temp.getUser.email;
    PhoneNumberController.text =
        temp.getUser.phoneNumber == "null" ? "" : temp.getUser.phoneNumber;
    return Consumer<UserState>(
      builder: (context, state, child) => Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TopRowBar(title: lbl_Profile),
            SizedBox(height: 20.0),
            SubTitleText(title: lbl_Edit_Profile),
            SizedBox(height: 10.0),
            t13EditTextStyle(lbl_UserName, UsernameController,
                isPassword: false, keyboardType: TextInputType.name),
            SizedBox(height: 10.0),
            t13EditTextStyle(lbl_hint_Email, EmailController,
                isPassword: false, keyboardType: TextInputType.emailAddress),
            SizedBox(height: 10.0),
            t13EditTextStyle(lbl_Phone_Number, PhoneNumberController,
                isPassword: false, keyboardType: TextInputType.phone),
            Spacer(),
            T13Button(
                textContent: lbl_Save,
                onPressed: () {
                  state.updateUserInfo(UsernameController.text,
                      EmailController.text, PhoneNumberController.text);
                  toast(lbl_Update_Success);
                  Navigator.pop(context);
                }),
            SizedBox(height: 20.0),
          ]),
        )),
      ),
    );
  }
}
