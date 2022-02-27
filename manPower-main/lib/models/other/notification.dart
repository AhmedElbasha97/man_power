import 'dart:convert';

NotificationData notificationFromJson(String str) => NotificationData.fromJson(json.decode(str));

String notificationToJson(NotificationData data) => json.encode(data.toJson());

class NotificationData {
  NotificationData({
    this.date,
    this.route,
    this.notificationId,
    this.title,
    this.body,
    this.chatId,
  });

  String? date;
  String? route;
  String? notificationId;
  String? title;
  String? body;
  String? chatId;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    date: json["date"] == null ? null : json["date"],
    route: json["route"] == null ? null : json["route"],
    notificationId: json["notification_id"],
    title: json["title"] == null ? null : json["title"],
    body: json["body"] == null ? null : json["body"],
    chatId: json["chat_id"] == null ? null : json["chat_id"],
  );

  Map<String, dynamic> toJson() => {
    "date": date == null ? null : date,
    "route": route == null ? null : route,
    "notification_id": notificationId,
    "title": title == null ? null : title,
    "body": body == null ? null : body,
    "chat_id": chatId == null ? null : chatId,
  };
}
