import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mymikano_app/State/ProductState.dart';
import 'package:mymikano_app/models/StoreModels/ProductModel.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/NotificationBell.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:mymikano_app/views/widgets/itemElement.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  final String title;
  ListPage({Key? key, required this.title}) : super(key: key);

  TextEditingController seearchController = TextEditingController();
  bool isfirst = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductState>(builder: (context, state, child) {
      if (isfirst) {
        state.clearListOfProducts();
        state.page = 0;
        state.Paginate();
        isfirst = false;
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification notification) {
            if (notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
              state.Paginate();
            }
            return true;
          },
          child: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            finish(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 32.0,
                          )),
                      Spacer(),
                      TitleText(title: title),
                      Spacer(),
                      NotificationBell()
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontSize: textSizeMedium, fontFamily: PoppinsFamily),
                    obscureText: false,
                    cursorColor: black,
                    controller: seearchController,
                    onChanged: state.fillListOfProductsToShow,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
                      hintText: lbl_Search,
                      hintStyle: primaryTextStyle(color: textFieldHintColor),
                      filled: true,
                      fillColor: lightBorderColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemCount: seearchController.text.length!=0? state.ListOfProductsToShow.length:state.ListOfProducts.length,
                    itemBuilder: (context, index) {
                      if ((seearchController.text.length!=0? state.ListOfProductsToShow.length:state.ListOfProducts.length) != 0) {
                        return ItemElement(
                          product: (seearchController.text.length!=0? state.ListOfProductsToShow:state.ListOfProducts)[index],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  state.ListOfProductsLoaded
                      ? Container()
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            )),
          ),
        ),
      );
    });
  }
}
