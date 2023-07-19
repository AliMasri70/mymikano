import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymikano_app/State/CarouselState.dart';
import 'package:mymikano_app/State/MainDashboardState.dart';
import 'package:mymikano_app/State/ProductState.dart';
import 'package:mymikano_app/State/UserState.dart';
import 'package:mymikano_app/models/StoreModels/ProductModel.dart';
import 'package:mymikano_app/services/LocalUserPositionService.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/images.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/AppWidget.dart';
import 'package:mymikano_app/views/widgets/HorizontalItemElement.dart';
import 'package:mymikano_app/views/widgets/NotificationBell.dart';
import 'package:mymikano_app/views/widgets/SubTitleText.dart';
import 'package:mymikano_app/views/widgets/itemElement.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ListPage.dart';
import 'LoadCalculationScreen.dart';
import 'ProductDetailsPage.dart';

class Dashboard extends StatefulWidget {
  static var tag = "/T5Dashboard";

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  bool guestLogin = true;

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    guestLogin = await prefs.getBool("GuestLogin")!;
    if (!guestLogin) {
      // sendGpsCoord();
    }
    guestLogin
        ? null
        : await Provider.of<UserState>(context, listen: false).update();
    setState(() {});
  }

  void sendGpsCoord() async {
    gps.canceled = false;
    gps.StartTimer();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer3<ProductState, UserState, MainDashboardState>(
      builder: (context, state, userState, mainDashboardState, child) =>
          Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                controller: mainDashboardState.scrollController(),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  SafeArea(
                    child: Container(
                      transform: Matrix4.translationValues(0.0, 8.0, 0.0),
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoadCalculationScreen()));
                                  },
                                  child: SvgPicture.asset(ic_KVA,
                                      height: 50, width: 50))),
                          Align(
                              alignment: Alignment.center,
                              child: commonCacheImageWidget(ic_AppLogo, 60)),
                          !guestLogin
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: NotificationBell(),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 140,
                      child: ListView.builder(
                          itemCount:
                              Provider.of<CarouselState>(context, listen: false)
                                  .topImages
                                  .length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            bool pressed = false;
                            return Provider.of<CarouselState>(context,
                                            listen: false)
                                        .topImages[index]
                                        .position
                                        .toString() ==
                                    "top"
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (pressed) {
                                          return;
                                        }
                                        pressed = true;
                                        String link =
                                            Provider.of<CarouselState>(context,
                                                    listen: false)
                                                .topImages[index]
                                                .link
                                                .toString();
                                        String type =
                                            Provider.of<CarouselState>(context,
                                                    listen: false)
                                                .topImages[index]
                                                .linkType
                                                .toString();
                                        if (type == "external") {
                                          try {
                                            await launch(link);
                                          } catch (e) {
                                            debugPrint(e.toString());
                                            toast(
                                                "There was an error, pelase try again later");
                                          }
                                        } else if (type == "product") {
                                          Product product = await state
                                              .fetchProductById(link.toInt());
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailsPage(
                                                        product: product,
                                                      )));
                                        } else if (type == "category") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => ListPage(
                                                      title: state
                                                          .mainCategories
                                                          .firstWhere(
                                                              (element) =>
                                                                  element.id!
                                                                      .toInt() ==
                                                                  link.toInt())
                                                          .name
                                                          .toString(),
                                                      categoryID: state
                                                          .mainCategories
                                                          .firstWhere(
                                                              (element) =>
                                                                  element.id!
                                                                      .toInt() ==
                                                                  link.toInt())
                                                          .id!)));
                                        }
                                        pressed = false;
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: Provider.of<CarouselState>(
                                                  context,
                                                  listen: false)
                                              .topImages[index]
                                              .url
                                              .toString(),
                                          height: 280,
                                          memCacheHeight: 280,
                                          memCacheWidth: 420,
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
                                                height: 300, width: width);
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 0,
                                    height: 0,
                                  );
                          })),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SubTitleText(
                            title: lbl_Top_Categories,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  SizedBox(
                    height: 100,
                    child: state.mainCategories.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.mainCategories.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ListPage(
                                                title: state
                                                    .mainCategories[index].name
                                                    .toString(),
                                                categoryID: state
                                                    .mainCategories[index]
                                                    .id!)));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: boxDecoration(
                                              radius: 33,
                                              showShadow: false,
                                              bgColor: mainGreyColorTheme
                                                  .withOpacity(0.3)),
                                          child: commonCacheImageWidget(
                                            state.mainCategories[index].image!
                                                .src,
                                            60,
                                            width: 80,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        state.mainCategories[index].name
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: PoppinsFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  SizedBox(
                    height: 41,
                  ),
                  Container(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubTitleText(title: "Top Deals", color: Colors.white),
                          ViewMoreBtn(title: "Top Deals"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 250,
                      child: state.topDealProducts.length != 0
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.topDealProducts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    width: 140,
                                    child: ItemElement(
                                      product: state.topDealProducts[index],
                                    ),
                                  ),
                                );
                              })
                          : Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  SizedBox(
                    height: 41,
                  ),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      itemCount:
                          Provider.of<CarouselState>(context, listen: false)
                              .bottomImages
                              .length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: Provider.of<CarouselState>(context,
                                      listen: false)
                                  .bottomImages[index]
                                  .url
                                  .toString(),
                              height: 280,
                              useOldImageOnUrlChange: true,
                              memCacheHeight: 280,
                              memCacheWidth: 420,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                              errorWidget: (_, __, ___) {
                                return SizedBox(height: 300, width: width);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubTitleText(
                              title: lbl_Featured_Products,
                              color: Colors.white),
                          ViewMoreBtn(title: lbl_Featured_Products),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  SizedBox(
                      height: 250,
                      child: state.featuredProducts.length != 0
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.featuredProducts.length,
                              itemBuilder: (context, index) {
                                Product temp = state.featuredProducts[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    width: 140,
                                    child: ItemElement(
                                      product: temp,
                                    ),
                                  ),
                                );
                              })
                          : Center(child: CircularProgressIndicator())),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubTitleText(
                              title: lbl_Top_Brands, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  SizedBox(
                      height: 60,
                      child: state.brandCategories != 0
                          ? ListView.builder(
                              itemCount: state.brandCategories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => ListPage(
                                                title: state
                                                    .brandCategories[index].name
                                                    .toString(),
                                                categoryID: state
                                                    .brandCategories[index].id!,
                                              )))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      width: 105,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: lightBorderColor, width: 1),
                                      ),
                                      // child: commonCacheImageWidget(
                                      //     state.brandCategories[index].image!.src, 60,
                                      //     width: 60),
                                      child: Center(
                                          child: commonCacheImageWidget(
                                              state.brandCategories[index]
                                                  .image!.src,
                                              100)),
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: CircularProgressIndicator(),
                            )),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubTitleText(
                              title: lbl_Trending_Now, color: Colors.white),
                          ViewMoreBtn(title: lbl_Trending_Now)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: state.trendingProducts.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.trendingProducts.length,
                            itemBuilder: (context, index) {
                              Product temp = state.trendingProducts[index];
                              return HorizontalItemElement(
                                product: temp,
                              );
                            })
                        : Center(child: CircularProgressIndicator()),
                  )
                ]),
              )),
    );
  }
}

class ViewMoreBtn extends StatelessWidget {
  String title;

  ViewMoreBtn({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //TODO View More Logic
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ListPage(title: title)));
        },
        child: Text(lbl_View_more,
            style: TextStyle(
                color: mainGreyColorTheme,
                fontSize: 15,
                fontFamily: PoppinsFamily)));
  }
}
