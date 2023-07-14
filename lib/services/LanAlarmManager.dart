
import 'package:mymikano_app/models/WlanNotificationModel.dart';

class AlarmManager {
  static final AlarmManager _instance = AlarmManager._internal();

  factory AlarmManager() {
    return _instance;
  }

  AlarmManager._internal();

  List<WlanNotificationModel> previousVariables = [];
}
