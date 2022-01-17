import 'dart:core';
import 'package:mymikano_app/models/MaintenanceRequestModel.dart';
import 'package:mymikano_app/utils/colors.dart';

import 'images.dart';
import 'package:mymikano_app/models/DashboardCardModel.dart';

List<T5Category> getDItems() {
  List<T5Category> list = [];

  var category1 = T5Category();
  category1.name = "Generators";
  category1.color = t5Cat1;
  category1.icon = ic_generator;
  list.add(category1);
  var category3 = T5Category();
  category3.name = "Electrical";
  category3.color = t5Cat3;
  category3.icon = ic_electricity;
  list.add(category3);
  var category4 = T5Category();
  category4.name = "Motors";
  category4.color = t5Cat4;
  category4.icon = ic_motor;
  list.add(category4);

  var category5 = T5Category();
  category5.name = "Steel";
  category5.color = t5Cat5;
  category5.icon = ic_steel;
  list.add(category5);

  var category = T5Category();
  category.name = "Medical";
  category.color = t5Cat6;
  category.icon = ic_Medical;
  list.add(category);
  return list;
}

List<T5Category> getCategoryItems() {
  List<T5Category> list = [];

  var category1 = T5Category();
  category1.name = "General Repair";
  category1.color = t5Cat1;
  category1.icon = ic_general_repair;
  list.add(category1);
  var category2 = T5Category();
  category2.name = "Mechanical Repair";
  category2.color = t5Cat2;
  category2.icon = ic_mechanical_repair;
  list.add(category2);
  var category3 = T5Category();
  category3.name = "Electrical Repair";
  category3.color = t5Cat3;
  category3.icon = ic_img_electrical;
  list.add(category3);
  var category4 = T5Category();
  category4.name = "Security";
  category4.color = t5Cat4;
  category4.icon = ic_security;
  list.add(category4);

  var category5 = T5Category();
  category5.name = "Cleaning";
  category5.color = t5Cat5;
  category5.icon = ic_cleaning;
  list.add(category5);

  var category = T5Category();
  category.name = "Landscape";
  category.color = t5Cat6;
  category.icon = ic_img_landscape;
  list.add(category);

  return list;
}

List<String> getSliders() {
  List<String> list = [];
  String model1 = "assets/MaskGroup2.png";
  String model2 = "assets/MaskGroup2.png";
  String model3 = "assets/MaskGroup2.png";

  list.add(model1);
  list.add(model2);
  list.add(model3);
  return list;
}

List<T5Bill> getListData() {
  List<T5Bill> list = [];
  var bill = T5Bill();
  bill.name = "Electric bill";
  bill.day = "22";
  bill.icon = ic_light_bulb;
  bill.amount = "155.00";
  bill.date = "10/2/2019";

  list.add(bill);

  var bill1 = T5Bill();
  bill1.name = "Water bill";
  bill1.day = "20";
  bill1.icon = ic_drop;
  bill1.amount = "855.00";
  bill1.date = "10/2/2019";

  list.add(bill1);

  var bill2 = T5Bill();
  bill2.name = "Water bill";
  bill2.day = "12";
  bill2.icon = ic_drop;
  bill2.amount = "155.00";
  bill2.isPaid = true;
  bill2.date = "10/2/2019";

  list.add(bill2);

  var bill3 = T5Bill();
  bill3.name = "Phone bill";
  bill3.day = "12";
  bill3.icon = ic_call_answer;
  bill3.amount = "25.00";
  bill3.date = "10/2/2019";

  list.add(bill3);

  var bill4 = T5Bill();
  bill4.name = "Internet bill";
  bill4.day = "11";
  bill4.icon = ic_wifi;
  bill4.amount = "70.00";
  bill4.date = "10/2/2019";

  list.add(bill4);
  var bill5 = T5Bill();
  bill5.name = "Electric bill";
  bill5.day = "10";
  bill5.icon = ic_light_bulb;
  bill5.amount = "600.00";
  bill5.date = "10/2/2019";
  bill5.isPaid = true;
  list.add(bill);
  list.add(bill2);
  list.add(bill);
  list.add(bill);
  list.add(bill1);
  list.add(bill2);
  list.add(bill3);
  list.add(bill4);
  list.add(bill);
  list.add(bill1);
  list.add(bill2);
  list.add(bill3);
  list.add(bill4);

  return list;
}

List<MaintenanceRequestModel2> getMaintenanceListData() {
  List<MaintenanceRequestModel2> list = [];
  var bill = MaintenanceRequestModel2();
  bill.categoryname = "Water bill";
  bill.preferredVisitTimee = "1969-07-20 20:18:04Z";
  bill.maintenanceStatusDescription = "Pending";
  bill.userId = 1;
  bill.maintenanceCategoryId = 1;

  list.add(bill);

  var bill1 = MaintenanceRequestModel2();
  bill1.categoryname = "Water bill";
  bill1.preferredVisitTimee = "1969-07-20 20:18:04Z";
  bill1.maintenanceStatusDescription = "Accepted";
  bill1.userId = 1;
  bill1.maintenanceCategoryId = 1;

  list.add(bill1);

  var bill2 = MaintenanceRequestModel2();
  bill2.categoryname = "Water bill";
  bill2.preferredVisitTimee = "1969-07-20 20:18:04Z";
  bill2.maintenanceStatusDescription = "Accepted";
  bill2.userId = 1;
  bill2.maintenanceCategoryId = 1;

  list.add(bill2);
  var bill3 = MaintenanceRequestModel2();
  bill3.categoryname = "Water bill";
  bill3.preferredVisitTimee = "1969-07-20 20:18:04Z";
  bill3.maintenanceStatusDescription = "Accepted";
  bill3.userId = 1;
  bill3.maintenanceCategoryId = 1;

  list.add(bill3);

  var bill4 = MaintenanceRequestModel2();
  bill4.categoryname = "Water bill";
  bill4.preferredVisitTimee = "1969-07-20 20:18:04Z";
  bill4.maintenanceStatusDescription = "Accepted";
  bill4.userId = 1;
  bill4.maintenanceCategoryId = 1;

  list.add(bill4);
  var bill5 = MaintenanceRequestModel2();
  bill5.categoryname = "Water bill";
  bill5.preferredVisitTimee = "1969-07-20 20:18:04Z";
  bill5.maintenanceStatusDescription = "Accepted";
  bill5.userId = 1;
  bill5.maintenanceCategoryId = 1;

  list.add(bill);
  list.add(bill2);
  list.add(bill);
  list.add(bill);
  list.add(bill1);
  list.add(bill2);
  list.add(bill3);
  list.add(bill4);
  list.add(bill);
  list.add(bill1);
  list.add(bill2);
  list.add(bill3);
  list.add(bill4);

  return list;
}
