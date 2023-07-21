class WlanNotificationModel {
  final String level;
  final String active;
  final String confirmed;
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
      level: json['level'] as String,
      active: json['active'] as String,
      confirmed: json['confirmed'] as String? ?? '',
      text: json['text'] as String,
      dateTime: dateTime, // Set the current date and time
    );
  }
}
