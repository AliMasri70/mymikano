class WlanNotificationModel {
  final int level;
  final bool active;
  final bool confirmed;
  final String text;
  final String dateTime;

  WlanNotificationModel({
    required this.level,
    required this.active,
    required this.confirmed,
    required this.text,
    required this.dateTime,
  });

  factory WlanNotificationModel.fromJson(
      Map<String, dynamic> json, String dateTime) {
    return WlanNotificationModel(
      level: json['level'] as int,
      active: json['active'] as bool,
      confirmed: json['confirmed'] as bool? ?? false,
      text: json['text'] as String,
      dateTime: dateTime, // Set the current date and time
    );
  }
}
