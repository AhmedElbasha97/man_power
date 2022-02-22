import 'dart:convert';

NotificationList notificationListFromJson(String str) => NotificationList.fromJson(json.decode(str));

String notificationListToJson(NotificationList data) => json.encode(data.toJson());

class NotificationList {
  NotificationList({
    this.status,
    this.data,
  });

  String? status;
  List<Datum>? data;

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.notificationId,
    this.message,
    this.type,
    this.created,
  });

  String? notificationId;
  String? message;
  String? type;
  String? created;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    notificationId: json["notification_id"] == null ? null : json["notification_id"],
    message: json["message"] == null ? null : json["message"],
    type: json["type"] == null ? null : json["type"],
    created: json["created"] == null ? null : json["created"],
  );

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId == null ? null : notificationId,
    "message": message == null ? null : message,
    "type": type == null ? null : type,
    "created": created == null ? null : created,
  };
}
