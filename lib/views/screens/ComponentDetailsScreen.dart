import 'package:flutter/material.dart';
import 'package:mymikano_app/models/InspectionChecklistItem.dart';
import 'package:mymikano_app/models/InspectionModel.dart';
import 'package:mymikano_app/models/MaintenaceCategoryModel.dart';
import 'package:mymikano_app/services/ChangeComponentStatusService.dart';
import 'package:mymikano_app/utils/QiBusConstant.dart';
import 'package:mymikano_app/viewmodels/LIstComponentStatusViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mymikano_app/utils/colors.dart';
import 'package:mymikano_app/utils/AppWidget.dart';
import 'Booking.dart';
import 'InspectionScreen.dart';

class BankingShareInformation extends StatefulWidget {
  static var tag = "/BankingShareInformation";
  late final InspectionChecklistItem? checklistItem;
  late final InspectionModel mInspection;
  Categ category;
  List<ComponentStatusViewModel> statusList=[];
  BankingShareInformation({ Key? key, required this.checklistItem, required this.mInspection,required this.statusList,required this.category}) : super(key: key);

  @override
  _BankingShareInformationState createState() => _BankingShareInformationState();
}

class _BankingShareInformationState extends State<BankingShareInformation> {

  late String defaultValue ;
  late String currentValue ;
  late int idStsSelected;

  int mIsSelect = 0;

  var mTime = 0;
  int _selected =0;
  @override
  void initState() {
    defaultValue = widget.checklistItem!.componentStatus!.componentStatusDescription;
    currentValue= widget.checklistItem!.componentStatus!.componentStatusDescription;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.black);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Container(
        //   padding: EdgeInsets.all(16),
        child:SingleChildScrollView(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[
              SizedBox(height: 30),
              Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left, color: Colors.black,size: 40.0),
                      onPressed: () {
                        _cancel();
                      },
                    ),
                    SizedBox(width: 10),
                    text(widget.checklistItem!.customComponent.componentName +" Details", textColor: Colors.black, fontSize: textSizeNormal,fontFamily: fontBold)
                  ]),
           Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child:Container(
            margin: EdgeInsets.all(spacing_standard_new),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

            SizedBox(height:20),
            ticketInfo(t13_name, widget.checklistItem!.customComponent.componentName ,Colors.black87,col:Colors.black),

            Divider(height: 24),
            ticketInfo(t13_description ,widget.checklistItem!.customComponent.componentDescription ,Colors.black87,col:Colors.black),


            Divider(height: 24),

            ticketInfo(t13_provider, widget.checklistItem!.customComponent.componentProvider ,Colors.black87,col:Colors.black),

            Divider(height: 24),
            ticketInfo(t13_unit_price,"\$"+widget.checklistItem!.customComponent.componentUnitPrice.toString(),Colors.black87 ,col:Colors.black),

            Divider(height: 24),
            text(t13_status,fontFamily: fontBold,textColor: Colors.black),
            SizedBox(height:20),
              GridView.builder(

                scrollDirection: Axis.vertical,
                itemCount: this.widget.statusList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {

                  return Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      // padding: EdgeInsets.all(8),
                      // margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: currentValue == this.widget.statusList[index].mcomponentStatus!.componentStatusDescription ? switchColor(this.widget.statusList[index].mcomponentStatus!.componentStatusDescription.toString()) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: currentValue == this.widget.statusList[index].mcomponentStatus!.componentStatusDescription.toString() ? white : grey),
                      ),
                      child: Center(child:Text(this.widget.statusList[index].mcomponentStatus!.componentStatusDescription.toString(), style: primaryTextStyle(color: currentValue == this.widget.statusList[index].mcomponentStatus!.componentStatusDescription.toString() ? white : grey)),
                      )).onTap(() {
                         idStsSelected=this.widget.statusList[index].mcomponentStatus!.idComponentStatus;
                    mIsSelect = index;
                    setState(() {
                      currentValue = this.widget.statusList[index].mcomponentStatus!.componentStatusDescription.toString();
                    });
                  }, splashColor: white);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing:8, childAspectRatio: 3),
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing:16, crossAxisSpacing:16, childAspectRatio: 8),
              ),
            180.height,
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        // finish(context);
                        _cancel();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(border: Border.all(color: food_textColorPrimary), borderRadius: BorderRadius.circular(24)),
                        child: Text(t13_cancel, style: primaryTextStyle()).center(),
                      ),),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,

                    child: GestureDetector(
                      onTap: () {
                        // finish(context);
                        _save();
                      },
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(color: t5Cat3, borderRadius: BorderRadius.circular(24)),
                        child: Text(t13_save, style: primaryTextStyle(color: food_white)).center(),
                      ),
                    ),
                  )
                ],
              )

              ]))),
               // Expanded(
               //   child: Container(
               //     color: Colors.amber,
               //     width: 100,
               //   ),
               // ),


            ],


          ),
        ),
      ),
    );
  }

  _save() async {
    // toast(currentValue);
    // toast(widget.checklistItem!.idInspectionChecklistItem!.toString());
   // toast(idStsSelected.toString());
    await  changeChecklistItemStatus(widget.checklistItem!.idInspectionChecklistItem!, idStsSelected);
    //finish(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => T13InspectionScreen(mInspection:widget.mInspection,statusList: this.widget.statusList,category: this.widget.category,),
      ),
    );


  }
  _cancel() async {

    currentValue=defaultValue;
    toast(currentValue);
  // finish(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => T13InspectionScreen(mInspection:widget.mInspection,statusList: this.widget.statusList,category: this.widget.category,),
      ),
    );

  }

  switchColor<Color>(String status) {

    if (status.toUpperCase() == "N/A".toUpperCase()) {
      return Colors.grey;
    }
    else if (status.toUpperCase() == 'poor'.toUpperCase()) {
      return Colors.amberAccent;
    }
    else if (status.toUpperCase() == 'repair'.toUpperCase()) {
      return Colors.red;
    }
    else if (status.toUpperCase() == 'good'.toUpperCase()) {
      return Colors.orange;
    }
    else if (status.toUpperCase() == 'replace'.toUpperCase()) {
      return Colors.blue;
    }
    else if(status.toUpperCase() == 'satisfactory'.toUpperCase()) {
      return Colors.green;
    }
    else{
      return Colors.grey;
    }

  }
}