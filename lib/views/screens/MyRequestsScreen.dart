import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymikano_app/models/DashboardCardModel.dart';
import 'package:mymikano_app/models/MaintenanceRequestModel.dart';
import 'package:mymikano_app/utils/AppWidget.dart';
import 'package:mymikano_app/utils/T2Colors.dart';
import 'package:mymikano_app/utils/T5DataGenerator.dart';
import 'package:mymikano_app/utils/T5Images.dart';
import 'package:mymikano_app/utils/T5Strings.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:mymikano_app/utils/auto_size_text/auto_size_text.dart';
import 'package:mymikano_app/viewmodels/ListMaintenanceRequestsViewModel.dart';
import 'package:mymikano_app/views/widgets/DartList.dart';
import 'package:mymikano_app/views/widgets/T5GridListing.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'DashboardScreen.dart';

class MyRequests extends StatefulWidget {
  static var tag = "/T5Dashboard";
  List<MaintenanceRequestModel> mRequestt=[];
  MyRequests({Key? key, required this.mRequestt,}) : super(key: key);
  @override
  MyRequestsState createState() => MyRequestsState();
}

class MyRequestsState extends State<MyRequests> {
  int selectedPos = 1;
  late List<T5Bill> mCards;

  @override
  void initState() {
    super.initState();
    selectedPos = 1;
    mCards = getListData();

    if(this.widget.mRequestt.length==0)
      print("empty"+this.widget.mRequestt.length.toString());
    //print("helpppppp");
 // print(this.widget.mRequestt[1].maintenanceCategory!.maintenanceCategoryName.toString()+"hello");
  }

  void changeSldier(int index) {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(t5DarkNavy);
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    Widget child;
    if (this.widget.mRequestt.length==0) {
      child = Center(child:
      Text("You don't have any request !",textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.black)
      )
      );
    } else {
    child = GridView.builder(
    scrollDirection: Axis.vertical,
    physics: ScrollPhysics(),
    itemCount: this.widget.mRequestt.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
    itemBuilder: (BuildContext context, int index) {
    return Container(
    padding: EdgeInsets.only(left: 16, right: 16),
    decoration: boxDecoration(radius: 16, showShadow: true, bgColor: Colors.white),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    SvgPicture.asset(mCards[index].icon, width: width / 13, height: width / 13),
    SizedBox(height: 10),
    //text(this.widget.mRequestt[index].maintenanceCategory!.maintenanceCategoryName, textColor: appStore.textPrimaryColor, fontSize: textSizeLargeMedium, fontFamily: fontSemibold),
    //text((this.widget.mRequestt[index].preferredVisitTimee), fontSize: textSizeMedium),
      Flexible(child: AutoSizeText(this.widget.mRequestt[index].maintenanceCategory!.maintenanceCategoryName, style: boldTextStyle(color: Colors.black, size: 16))),
      Flexible(child: AutoSizeText(this.widget.mRequestt[index].preferredVisitTimee!)),
    SizedBox(height: 10),
    Container(
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    decoration:this.widget.mRequestt[index].maintenaceRequestStatus!.maintenanceStatusDescription=="Pending" ? boxDecoration(bgColor: t5Cat3, radius: 16) : boxDecoration(bgColor: t5Cat4, radius: 16),
    child: text(this.widget.mRequestt[index].maintenaceRequestStatus!.maintenanceStatusDescription=="Pending" ? "Pending" : "Accepted", fontSize: textSizeMedium, textColor: t5White),
    ),
    ],
    ),
    );
    });
    }
    //return new Container(child: child);


    return Scaffold(
      backgroundColor: t5DarkNavy,
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 70,
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // IconButton(
                      //   icon: SvgPicture.asset(t5_arrow_back, width: 25, height: 25, color: t5White),
                      //   onPressed: () {
                      //     print("ihh");
                      //
                      //   }, //do something,
                      // ),
                      IconButton(
                        icon: Icon(Icons.arrow_back_rounded, color: t5White,size: 30.0,),
                        onPressed: () {
                          finish(context);
                        },
                      ),
                      SizedBox(width: 10),
                      SvgPicture.asset(t5_general_repair, width: 25, height: 25, color: t5White),
                      SizedBox(width: 8),
                      text(t5_maintenance_repair, textColor: t5White, fontSize: textSizeNormal, fontFamily: fontMedium)
                    ],
                  ), // SvgPicture.asset(t5_options, width: 25, height: 25, color: t5White)
                ],
              ),
            ),

       Expanded(
          child:   SingleChildScrollView(
             //padding: EdgeInsets.only(top: 100),
                child: Container(
          //      padding: EdgeInsets.only(top: 18),

                alignment: Alignment.topLeft,
             height: MediaQuery.of(context).size.height ,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                child: Column(
                  // children: tab[_currentIndex],
                   children: <Widget>[
                      // T5SliderWidget(mSliderList),
                      SizedBox(height: 20),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),

              child:child


                        ),
                      )
                    ]

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
     // bottomNavigationBar: (),
    );
  }
}
