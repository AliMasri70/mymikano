import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymikano_app/models/MaintenaceCategoryModel.dart';
import 'package:mymikano_app/models/MaintenanceRequestModel.dart';
import 'package:mymikano_app/utils/SDDashboardScreen.dart';
import 'package:mymikano_app/utils/T13Strings.dart';
import 'package:mymikano_app/utils/auto_size_text/auto_size_text.dart';
import 'package:mymikano_app/viewmodels/ListMaintenanceCategoriesViewModel.dart';
import 'package:mymikano_app/viewmodels/ListMaintenanceRequestsViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mymikano_app/models/TechnicianModel.dart';
import 'package:mymikano_app/utils/T13Images.dart';
import 'package:mymikano_app/utils/AppWidget.dart';
import 'package:mymikano_app/utils/colors.dart';
import 'package:mymikano_app/utils/QiBusConstant.dart';
import 'package:mymikano_app/utils/T5Images.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import 'MyInspectionsScreen.dart';

class T5Profile extends StatefulWidget {
  static var tag = "/T5Profile";

  @override
  T5ProfileState createState() => T5ProfileState();
}

class T5ProfileState extends State<T5Profile> {
  late Directory directory;
  late File file; //
  late String fileContent;

  double? width;
  TechnicianModel? tech =
      new TechnicianModel(1, 'null', 'null', t5_profile_7, 'null', 'null');
  ListCategViewModel lcvm = new ListCategViewModel();
  ListMaintenanceRequestsViewModel mrqvm =
      new ListMaintenanceRequestsViewModel();
  List<Categ> catnames = [];
  List<MaintenanceRequestModel> reqst = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    directory = await getApplicationDocumentsDirectory();
    file = File('${directory.path}/credentials.json');
    fileContent = await file.readAsString();
    Map<String, dynamic> jwtData = {};

    JwtDecoder.decode(fileContent)!.forEach((key, value) {
      jwtData[key] = value;
    });
    tech = new TechnicianModel(1, jwtData['given_name'], jwtData['family_name'],
        t5_profile_7, "null", jwtData['email']);
    await lcvm.fetchAllCategories();
    int l = lcvm.allcategs!.length;
    for (int i = 0; i < l; i++) {
      catnames.add(lcvm.allcategs![i].mcateg!);
    }

    await mrqvm.fetchMaintenanceRequests();
    for (int i = 0; i < mrqvm.maintenanceRequests!.length; i++) {
      reqst.add(mrqvm.maintenanceRequests![i].mMaintenacerequest!);
    }
  }

  var currentIndex = 0;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget gridItem() {
    return GestureDetector(
        onTap: () async {
          await init();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => T5Listing(
                      cnames: catnames,
                      reqs: reqst,
                    )),
          );
        },
        child: Container(
            width: width! * 0.5,
            height: width! * 0.5,
            decoration:
                boxDecoration(radius: 24, showShadow: true, bgColor: t5White),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundColor: t5Cat2,
                  child: SvgPicture.asset(t13_ic_inspection2,
                      height: 90, width: 90, color: Colors.white),
                ),
                Flexible(
                    child: AutoSizeText("My Inspections",
                        style: boldTextStyle(color: Colors.black, size: 20)))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.black);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              height: width,
              color: t5DarkNavy,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                height: 60,
                child: commonCacheImageWidget(t5_ic_light_logo, 40,
                    width: width! * 0.33),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 70),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(top: 60),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        text(tech!.firstname + " " + tech!.lastname,
                            textColor: t5TextColorPrimary,
                            fontFamily: fontBold,
                            fontSize: textSizeNormal),
                        text(tech!.email, fontSize: textSizeLargeMedium),
                        SizedBox(height: 58),
                        gridItem()
                      ],
                    ),
                  ),
                  CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(tech!.image),
                      radius: 50)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
