import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymikano_app/State/CurrencyState.dart';
import 'package:mymikano_app/State/ProductState.dart';
import 'package:mymikano_app/State/UserState.dart';
import 'package:mymikano_app/models/StoreModels/ProductCartModel.dart';
import 'package:mymikano_app/models/StoreModels/ProductModel.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/images.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/screens/CartPage.dart';
import 'package:mymikano_app/views/widgets/AppWidget.dart';
import 'package:mymikano_app/views/widgets/SubTitleText.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:mymikano_app/views/widgets/itemElement.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'PDFViewScreen.dart';
import 'RFQFormScreen.dart';

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
  void initState() {
    // TODO: implement initState
    Provider.of<ProductState>(context, listen: false)
        .getRelatedProducts(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Quantity = 1;
    return Consumer2<ProductState, UserState>(
      builder: (context, state, userState, child) => Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // IconButton(
                    //     onPressed: () => finish(context),
                    //     icon: Icon(Icons.arrow_back_ios_new)),
                    IconButton(
                        onPressed: () {
                          // Pop until dashboard screen
                          Navigator.popUntil(
                              context, ModalRoute.withName('dashboard'));
                        },
                        icon: Icon(Icons.home)),
                  ],
                ),
                userState.guestLogin
                    ? Container()
                    : Consumer<ProductState>(
                        builder: (context, state, child) => GestureDetector(
                            onTap: () {
                              state
                                  .addorremoveProductToFavorite(widget.product);
                            },
                            child: commonCacheImageWidget(ic_heart, 30,
                                color: widget.product.liked
                                    ? mainColorTheme
                                    : null)),
                      )
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(children: [
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: size.height / 2.7,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: CarouselSlider.builder(
                                    options: CarouselOptions(
                                      height: 400,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: false,
                                      reverse: false,
                                      autoPlay: false,
                                      autoPlayInterval: Duration(seconds: 5),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.2,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    itemCount: widget.product.Images.length,
                                    itemBuilder: (BuildContext context,
                                            int index, int pageViewIndex) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${widget.product.Images[index]}',
                                            fit: BoxFit.contain,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress)),
                                            errorWidget: (_, __, ___) {
                                              return SizedBox(
                                                  height: 85, width: 85);
                                            },
                                          ),
                                        )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child:
                                    SubTitleText(title: widget.product.Name)),
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
                                  return Icon(Icons.star,
                                      color: mainColorTheme);
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
                              '${Provider.of<CurrencyState>(context, listen: false).currency.currencySymbol} ${NumberFormat.decimalPattern().format(widget.product.Price)}',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: PoppinsFamily),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            userState.guestLogin
                                ? Container()
                                : QuantityChooser(),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            TitleText(title: lbl_About_the_product),
                            SizedBox(height: 11),
                            Text(
                              widget.product.Description
                                  .replaceAll("</p>", "")
                                  .replaceAll("<p>", "")
                                  .replaceAll("&nbsp;", ""),
                              maxLines: 1000,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: PoppinsFamily,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 30),
                            if (widget.product.dataSheetLabel.toString() != "")
                              TitleText(title: lbl_Data_Sheet),
                            SizedBox(height: 11),
                            if (widget.product.dataSheetLabel.toString() != "")
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PDFViewScreen(
                                          Path: widget.product.dataSheet
                                              .toString(),
                                          Code: widget.product.Code)));
                                },
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  size: 80,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        if (state.relatedProducts.length != 0)
                          TitleText(title: lbl_Related_Products),
                        if (state.relatedProducts.length != 0)
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.relatedProducts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: SizedBox(
                                      width: 140,
                                      child: ItemElement(
                                        product: state.relatedProducts[index],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        SizedBox(
                          height: 50,
                        ),
                      ]),
                ),
                if (userState.guestLogin)
                  Container()
                else if (!widget.product.call_for_price)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 60,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  CartProduct p = CartProduct(
                                      product: widget.product,
                                      quantity: Quantity);
                                  state.addProduct(p);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CartPage())));
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
                    ),
                  )
                else
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 60,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: T13Button(
                                textContent: 'Request For Quote',
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RFQFormScreen(
                                          id: widget.product.id)));
                                }),
                          )))
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
