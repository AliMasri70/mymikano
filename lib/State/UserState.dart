import 'package:flutter/cupertino.dart';
import 'package:mymikano_app/models/StoreModels/AddressModel.dart';
import 'package:mymikano_app/models/TechnicianModel.dart';
import 'package:mymikano_app/services/StoreServices/CustomerService.dart';
import 'package:mymikano_app/services/UserService.dart';
import 'package:nb_utils/nb_utils.dart';

class UserState extends ChangeNotifier {
  TechnicianModel User = TechnicianModel("1", 'null', '', 'null', 'null');
  bool isTechnician = false;
  bool termsAccepted = true;
  bool NotificationsEnabled = true;
  Address ChosenAddress = Address();
  bool checkedValueForOrder = false;

  UserState() {
    update();
  }

  void update(){
    fillUserInfo();
    fetchtermsState();
    fetchNotificationsState();
    fetchAddress();
    notifyListeners();
  }

  void fillUserInfo() async {
    User = await UserService().GetUserInfo();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isTechnician = prefs.getString("isTechnician") == "true" ? true : false;
  }

  void updateUserInfo(
      String firstName, String lastName, String PhoneNumber) async {
    bool flag =
        await UserService().EditUserInfo(firstName, lastName, PhoneNumber);
    if (flag) {
      User.username = firstName + " " + lastName;
      User.phoneNumber = PhoneNumber;
    }
    notifyListeners();
  }

  Future<void> setcheckedValueForOrder(bool value) async {
    checkedValueForOrder = value;
    notifyListeners();
  }

  Future<void> addAddress(String address, String city) async {
    Address newAddress = Address(address1: address, city: city);
    ChosenAddress = newAddress;
    await CustomerService().addShippingAddress(newAddress);
    notifyListeners();
  }

  Future<void> fetchAddress() async {
    ChosenAddress =
        await CustomerService().GetShippingAddresseForLoggedInUser();
    notifyListeners();
  }

  Future<void> fetchNotificationsState() async {
    NotificationsEnabled = await CustomerService().getNotificationsState();
    notifyListeners();
  }

  Future<void> setNotificationsState(bool state) async {
    NotificationsEnabled = await CustomerService().setNotificationsState(state);
    notifyListeners();
  }

  Future<void> fetchtermsState() async {
    termsAccepted = await CustomerService().getTermsState();
    notifyListeners();
  }

  Future<void> setTermsState(bool state) async {
    termsAccepted = await CustomerService().setTermsState(state);
    notifyListeners();
  }

  bool get getTermsState => termsAccepted;

  Future<void> sendContactUsRequest(
      String name, String email, String message) async {
    await CustomerService().postContactUsRequest(name, email, message);
    notifyListeners();
  }

  TechnicianModel get getUser => User;
}
