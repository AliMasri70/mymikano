import 'package:flutter/material.dart';
import 'package:mymikano_app/models/StoreModels/ProductModel.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/NotificationBell.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:mymikano_app/views/widgets/itemElement.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mymikano_app/services/StoreServices/ProductService.dart';

import 'NotificationsScreen.dart';

class ListPage extends StatelessWidget {
  final String title;
  ListPage({Key? key, required this.title}) : super(key: key);

  TextEditingController seearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int page = 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
              t13EditTextStyle(lbl_Search, seearchController),
              SizedBox(
                height: 40,
              ),
              FutureBuilder(
                future: ProductsService().getProducts(limit: 8, page: page),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Product temp = snapshot.data!.elementAt(index);
                        return ItemElement(
                          product: temp,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        )),
      ),
    );
  }
}
