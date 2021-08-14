import 'package:mymikano_app/models/DashboardCardModel.dart';
import 'package:mymikano_app/models/MaintenanceRequestModel.dart';

import 'T2Colors.dart';
import 'T5Images.dart';
List<T5Category> getDItems() {
  List<T5Category> list = [];

  var category1 = T5Category();
  category1.name = "Generators";
  category1.color = t5Cat1;
  category1.icon = t5_generator;
  list.add(category1);
  /*var category2 = T5Category();
  category2.name = "Wallet";
  category2.color = t5Cat2;
  category2.icon = t5_wallet;
  list.add(category2);*/
  var category3 = T5Category();
  category3.name = "Electrical";
  category3.color = t5Cat3;
  category3.icon = t5_electricity;
  list.add(category3);
  var category4 = T5Category();
  category4.name = "Motors";
  category4.color = t5Cat4;
  category4.icon = t5_engine;
  list.add(category4);

  var category5 = T5Category();
  category5.name = "Steel";
  category5.color = t5Cat5;
  category5.icon = t5_steel;
  list.add(category5);

  var category = T5Category();
  category.name = "More";
  category.color = t5Cat6;
  category.icon = t5_circle;
  list.add(category);
  return list;
}
List<T5Category> getCategoryItems() {
  List<T5Category> list = [];

  var category1 = T5Category();
  category1.name = "General Repair";
  category1.color = t5Cat1;
  category1.icon = t5_general_repair;
  list.add(category1);
  var category2 = T5Category();
  category2.name = "Mechanical Repair";
  category2.color = t5Cat2;
  category2.icon = t5_mechanical_repair;
  list.add(category2);
  var category3 = T5Category();
  category3.name = "Electrical Repair";
  category3.color = t5Cat3;
  category3.icon = t5_img_electrical;
  list.add(category3);
  var category4 = T5Category();
  category4.name = "Security";
  category4.color = t5Cat4;
  category4.icon = t5_security;
  list.add(category4);

  var category5 = T5Category();
  category5.name = "Cleaning";
  category5.color = t5Cat5;
  category5.icon = t5_cleaning;
  list.add(category5);

  var category = T5Category();
  category.name = "Landscape";
  category.color = t5Cat6;
  category.icon = t5_img_landscape;
  list.add(category);
  return list;
}

List<T5Category> getBottomSheetItems() {
  List<T5Category> list = [];
  var category1 = T5Category();
  category1.name = "Transfer";
  category1.color = t5Cat1;
  category1.icon = t5_paperplane;
  list.add(category1);
  var category2 = T5Category();
  category2.name = "Wallet";
  category2.color = t5Cat2;
  category2.icon = t5_wallet;
  list.add(category2);
  var category3 = T5Category();
  category3.name = "Voucher";
  category3.color = t5Cat3;
  category3.icon = t5_coupon;
  list.add(category3);
  var category4 = T5Category();
  category4.name = "Pay Bill";
  category4.color = t5Cat4;
  category4.icon = t5_invoice;
  list.add(category4);

  var category5 = T5Category();
  category5.name = "Exchange";
  category5.color = t5Cat5;
  category5.icon = t5_dollar_exchange;
  list.add(category5);

  var category6 = T5Category();
  category6.name = "Services";
  category6.color = t5Cat6;
  category6.icon = t5_circle;
  list.add(category6);

  var category9 = T5Category();
  category9.name = "Crypto";
  category9.color = t5Cat3;
  category9.icon = t5_invoice;
  list.add(category9);
  var category11 = T5Category();
  category11.name = "Mobile";
  category11.color = t5Cat5;
  category11.icon = t5_dollar_exchange;
  list.add(category11);

  var category12 = T5Category();
  category12.name = "Services";
  category12.color = t5Cat6;
  category12.icon = t5_circle;
  list.add(category12);

  var category7 = T5Category();
  category7.name = "Pay Bill";
  category7.color = t5Cat4;
  category7.icon = t5_invoice;
  list.add(category7);
  var category8 = T5Category();
  category8.name = "Exchange";
  category8.color = t5Cat5;
  category8.icon = t5_dollar_exchange;
  list.add(category8);

  var category10 = T5Category();
  category10.name = "Services";
  category10.color = t5Cat6;
  category10.icon = t5_circle;
  list.add(category10);

  return list;
}

List<T5Slider> getSliders() {
  List<T5Slider> list = [];
  T5Slider model1 = T5Slider();
  model1.balance = "\$150000";
  model1.accountNo = "145 250 230 120 150";
  model1.image = t5_card1;
  T5Slider model2 = T5Slider();
  model2.balance = "\$150000";
  model2.accountNo = "145 250 230 120 150";
  model2.image =  t5_card1;
  T5Slider model3 = T5Slider();
  model3.balance = "\$150000";
  model3.accountNo = "145 250 230 120 150";
  model3.image =  t5_card1;

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
  bill.icon = t5_light_bulb;
  bill.amount = "\$155.00";
  bill.date = "10/2/2019";

  list.add(bill);

  var bill1 = T5Bill();
  bill1.name = "Water bill";
  bill1.day = "20";
  bill1.icon = t5_drop;
  bill1.amount = "\$855.00";
  bill1.date = "10/2/2019";

  list.add(bill1);

  var bill2 = T5Bill();
  bill2.name = "Water bill";
  bill2.day = "12";
  bill2.icon = t5_drop;
  bill2.amount = "\$155.00";
  bill2.isPaid = true;
  bill2.date = "10/2/2019";

  list.add(bill2);

  var bill3 = T5Bill();
  bill3.name = "Phone bill";
  bill3.day = "12";
  bill3.icon = t5_call_answer;
  bill3.amount = "\$25.00";
  bill3.date = "10/2/2019";

  list.add(bill3);

  var bill4 = T5Bill();
  bill4.name = "Internet bill";
  bill4.day = "11";
  bill4.icon = t5_wifi;
  bill4.amount = "\$70.00";
  bill4.date = "10/2/2019";

  list.add(bill4);
  var bill5 = T5Bill();
  bill5.name = "Electric bill";
  bill5.day = "10";
  bill5.icon = t5_light_bulb;
  bill5.amount = "\$600.00";
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


