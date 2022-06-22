import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mymikano_app/State/CurrencyState.dart';
import 'package:mymikano_app/State/ProductState.dart';
import 'package:mymikano_app/State/UserState.dart';
import 'package:mymikano_app/models/StoreModels/ProductCartModel.dart';
import 'package:mymikano_app/models/StoreModels/ProductModel.dart';
import 'package:mymikano_app/models/TechnicianModel.dart';
import 'package:mymikano_app/services/PaymentService.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/images.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/CartPage.dart';
import 'package:mymikano_app/views/widgets/AppWidget.dart';
import 'package:mymikano_app/views/widgets/SubTitleText.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'PDFViewScreen.dart';

int Quantity = 1;

class ProductDetailsPage extends StatefulWidget {
  Product product;

  ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isFavorite = false;

  RegExp exp = RegExp(r"<[^>]/*>", multiLine: true, caseSensitive: true);

  RegExp exp2 = RegExp(r"<[^>]*/>", multiLine: true, caseSensitive: true);

  RegExp exp3 = RegExp(r"</[^>]*>", multiLine: true, caseSensitive: true);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Quantity = 1;
    return Consumer2<ProductState, UserState>(
      builder: (context, state, userState, child) => Scaffold(
          body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: size.height / 2,
                              padding:
                                  EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 0.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: CachedNetworkImage(
                                imageUrl: '${widget.product.Image}',
                                height: 100,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress)),
                                errorWidget: (_, __, ___) {
                                  return SizedBox(height: 85, width: 85);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () => finish(context),
                              icon: Icon(Icons.arrow_back_ios_new)),
                          userState.guestLogin
                              ? Container()
                              : Consumer<ProductState>(
                                  builder: (context, state, child) =>
                                      GestureDetector(
                                          onTap: () {
                                            state.addorremoveProductToFavorite(
                                                widget.product);
                                          },
                                          child: commonCacheImageWidget(
                                              ic_heart, 30,
                                              color: state.allProducts
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          widget.product.id)
                                                      .liked? mainColorTheme
                                                  : null)),
                                )
                        ],
                      ),
                    ]),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: SubTitleText(title: widget.product.Name)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 18,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.product.Rating,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Icon(Icons.star, color: mainColorTheme);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 18,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5 - widget.product.Rating,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Icon(Icons.star_border,
                                  color: mainColorTheme);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${Provider.of<CurrencyState>(context, listen: false).currency!.currencySymbol} ${widget.product.Price}',
                          style: TextStyle(
                              fontSize: 20, fontFamily: PoppinsFamily),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        userState.guestLogin ? Container() : QuantityChooser(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        TitleText(title: lbl_About_the_product),
                        SizedBox(height: 11),
                        Text(
                          widget.product.Description,
                          maxLines: 1000,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: PoppinsFamily,
                              color: mainGreyColorTheme),
                        ),
                        SizedBox(height: 30),
                        TitleText(title: lbl_Data_Sheet),
                        SizedBox(height: 11),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PDFViewScreen(
                                    Path: widget.product.dataSheet.toString(),
                                    Code: widget.product.Code)));
                          },
                          child: Text(
                            widget.product.dataSheetLabel.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: PoppinsFamily,
                                color: Colors.lightBlue),
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ]),
            ),
            userState.guestLogin
                ? Container()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                CartProduct p = CartProduct(
                                    product: widget.product,
                                    quantity: Quantity);
                                state.addProduct(p);

                                Navigator.push(context, MaterialPageRoute(builder: ((context) => CartPage())));
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  color: mainBlackColorTheme,
                                ),
                                child: Center(
                                    child: Text(lbl_Buy_Now,
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
                                CartProduct p = CartProduct(
                                    product: widget.product,
                                    quantity: Quantity);
                                state.addProduct(p);
                                toast("${widget.product.Name} added to cart");
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  color: mainColorTheme,
                                ),
                                child: Center(
                                    child: Text(lbl_Add_To_Cart,
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
                  )
          ]),
        ),
      )),
    );
  }
}

class QuantityChooser extends StatefulWidget {
  const QuantityChooser({
    Key? key,
  }) : super(key: key);

  @override
  State<QuantityChooser> createState() => _QuantityChooserState();
}

class _QuantityChooserState extends State<QuantityChooser> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: lightBorderColor, width: 1)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: IconButton(
                  onPressed: () {
                    Quantity > 0 ? Quantity-- : null;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.minimize,
                    color: mainGreyColorTheme,
                  )),
            ),
            Text(
              Quantity.toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: PoppinsFamily),
            ),
            IconButton(
                onPressed: () {
                  Quantity++;
                  setState(() {});
                },
                icon: Icon(Icons.add, color: mainGreyColorTheme)),
          ],
        ));
  }
}
