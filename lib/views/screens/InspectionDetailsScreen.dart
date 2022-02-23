import 'package:flutter/material.dart';
import 'package:mymikano_app/State/InspectionsState.dart';
import 'package:mymikano_app/State/RequestFormState.dart';
import 'package:mymikano_app/models/ComponentModel.dart';
import 'package:mymikano_app/models/InspectionModel.dart';
import 'package:mymikano_app/models/MaintenanceRequestModel.dart';
import 'package:mymikano_app/services/ComponentService.dart';
import 'package:mymikano_app/services/RequestFormService.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/strings.dart';
import 'package:mymikano_app/views/widgets/ComponentItem.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TitleText.dart';
import 'package:mymikano_app/views/widgets/TopRowBar.dart';
import 'package:mymikano_app/views/widgets/list.dart';
import 'package:mymikano_app/views/widgets/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class InspectionDetailsScreen extends StatefulWidget {
  InspectionModel mInspection;
  MaintenanceRequestModel Maintenance;

  InspectionDetailsScreen(
      {Key? key, required this.mInspection, required this.Maintenance})
      : super(key: key);
  @override
  InspectionDetailsScreenState createState() => InspectionDetailsScreenState();
}

class InspectionDetailsScreenState extends State<InspectionDetailsScreen> {
  var NotesController = TextEditingController();
  var ComponentNameController = TextEditingController();
  var ComponentDescriptionController = TextEditingController();
  var ComponentPriceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<RequestFormState>(context, listen: false).allComponents.clear();
    Provider.of<RequestFormState>(context, listen: false)
        .fetchPredefinedComponents(this.widget.mInspection.idInspection);
    Provider.of<RequestFormState>(context, listen: false)
        .fetchCustomComponents(this.widget.mInspection.idInspection);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionsState>(
      builder: (context, InsState, child) => Consumer<RequestFormState>(
        builder: (context, state, child) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TopRowBar(title: lbl_Request_Form),
                        SizedBox(
                          height: 40,
                        ),
                        TitleText(title: lbl_Description),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            this
                                .widget
                                .Maintenance
                                .requestDescription
                                .toString(),
                            style: TextStyle(
                                fontSize: 12, color: mainGreyColorTheme)),
                        SizedBox(
                          height: 30,
                        ),
                        TitleText(title: lbl_Images),
                        SizedBox(
                          height: 10,
                        ),
                        this
                                    .widget
                                    .Maintenance
                                    .maintenanceRequestImagesFiles!
                                    .length !=
                                0
                            ? SizedBox(
                                height: 200,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: this
                                        .widget
                                        .Maintenance
                                        .maintenanceRequestImagesFiles!
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Widget temp = SizedBox(
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 0.0, 8.0, 0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: commonCacheImageWidget(
                                                  this
                                                          .widget
                                                          .Maintenance
                                                          .maintenanceRequestImagesFiles![
                                                      index],
                                                  80,
                                                  fit: BoxFit.fill,
                                                ),
                                              )));
                                      return temp;
                                    }),
                              )
                            : Center(
                                child: Text("No Images"),
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        TitleText(title: lbl_Audio),
                        SizedBox(
                          height: 10,
                        ),
                        this
                                    .widget
                                    .Maintenance
                                    .maintenanceRequestRecordsFiles!
                                    .length !=
                                0
                            ? SizedBox(
                                height: this
                                        .widget
                                        .Maintenance
                                        .maintenanceRequestRecordsFiles!
                                        .length *
                                    45,
                                child: ListView.builder(
                                    itemCount: 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      List<String> tempList = this
                                          .widget
                                          .Maintenance
                                          .maintenanceRequestRecordsFiles!
                                          .map((e) => e.toString())
                                          .toList();
                                      Widget temp = RecordsUrl(
                                        records: tempList,
                                      );
                                      return temp;
                                    }),
                              )
                            : Container(
                                height: 50,
                                child: Center(
                                  child: Text("No Audio"),
                                ),
                              ),
                        TitleText(title: lbl_Additional_Notes),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: lightBorderColor),
                          child: TextFormField(
                            enabled: false,
                            textAlignVertical: TextAlignVertical.top,
                            expands: true,
                            cursorColor: Colors.black,
                            controller: NotesController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding:
                                  EdgeInsets.fromLTRB(26, 14, 4, 14),
                              hintText: lbl_Text_Here,
                              hintStyle: TextStyle(
                                  height: 1.4, color: textFieldHintColor),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleText(title: lbl_Components),
                            IconButton(
                                onPressed: () {
                                  bottomSheet(context);
                                },
                                icon: Icon(Icons.add))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (state.allComponents.length != 0)
                          Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            height: 64 * (state.allComponents.length / 3) + 60,
                            decoration: BoxDecoration(
                              color: lightBorderColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 4,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 10),
                                itemCount: state.allComponents.length,
                                itemBuilder: (context, index) {
                                  return state.allComponents[index];
                                }),
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        TitleText(title: lbl_Change_Status),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: lightBorderColor),
                          child: TextFormField(
                            enabled: false,
                            textAlignVertical: TextAlignVertical.top,
                            expands: true,
                            cursorColor: Colors.black,
                            controller: NotesController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: this
                                  .widget
                                  .Maintenance
                                  .maintenaceRequestStatus!
                                  .maintenanceStatusDescription,
                              hintStyle: TextStyle(
                                  height: 1.4, color: textFieldHintColor),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        T13Button(
                            textContent: this
                                        .widget
                                        .Maintenance
                                        .maintenaceRequestStatus!
                                        .maintenanceStatusDescription ==
                                    "Assigned"
                                ? lbl_Submit
                                : lbl_Revert_Status,
                            onPressed: () {
                              RequestFormService()
                                  .SubmitRequestForm(
                                      this
                                          .widget
                                          .mInspection
                                          .maintenanceRequestID
                                          .toString(),
                                      this
                                                  .widget
                                                  .Maintenance
                                                  .maintenaceRequestStatus!
                                                  .maintenanceStatusDescription ==
                                              "Assigned"
                                          ? "4"
                                          : "2")
                                  .then((value) {
                                if (value) {
                                  toast("Submitted Successfully");
                                  InsState.fetchInspectionByUser();
                                  Navigator.pop(context);
                                } else {
                                  toast("Error! please try again.");
                                }
                              });
                            }),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Consumer<RequestFormState>(
          builder: (context, value, child) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => finish(context),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios_new),
                        Text(lbl_Back)
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lightBorderColor),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      cursorColor: Colors.black,
                      controller: ComponentNameController,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: lbl_Component_Name,
                        hintStyle:
                            TextStyle(height: 1.4, color: textFieldHintColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lightBorderColor),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      cursorColor: Colors.black,
                      controller: ComponentDescriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: lbl_Component_Description,
                        hintStyle:
                            TextStyle(height: 1.4, color: textFieldHintColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lightBorderColor),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      cursorColor: Colors.black,
                      controller: ComponentPriceController,
                      keyboardType: TextInputType.number,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: lbl_Component_Price,
                        hintStyle:
                            TextStyle(height: 1.4, color: textFieldHintColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  T13Button(
                      textContent: lbl_Submit,
                      onPressed: () {
                        ComponentModel component = ComponentModel(
                            componentName: ComponentNameController.text,
                            componentDescription:
                                ComponentDescriptionController.text,
                            componentProvider: "",
                            componentUnitPrice:
                                ComponentPriceController.text.toInt());
                        ComponentService()
                            .AddCustomComponentService(
                                component, this.widget.mInspection.idInspection)
                            .then((value) {
                          if (value) {
                            toast("Component Added Successfully");
                            Provider.of<RequestFormState>(context,
                                    listen: false)
                                .addComponent(ComponentItem(
                              Component: component,
                              deletable: true,
                            ));
                            ComponentNameController.clear();
                            ComponentDescriptionController.clear();
                            ComponentPriceController.clear();
                            Navigator.pop(context);
                          } else {
                            toast("Error! please try again.");
                          }
                        });
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
