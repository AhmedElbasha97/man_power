import 'dart:convert';

UserList uesrListFromJson(String str) => UserList.fromJson(json.decode(str));

String uesrListToJson(UserList data) => json.encode(data.toJson());

class UserList {
  UserList({
    this.status,
    this.data,
  });

  String? status;
  List<Datum>? data;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
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
    this.companyId,
    this.name,
    this.namear,
    this.chatId,
    this.lastMessage,
    this.lastMessageDate,
    this.lastMessageTime,
    this.isRead,
    this.picpath,
  });

  String? companyId;
  String? name;
  String? namear;
  String? chatId;
  String? lastMessage;
  String? lastMessageDate;
  String? lastMessageTime;
  String? isRead;
  String? picpath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    companyId: json["company_id"] == null ? null : json["company_id"],
    name: json["name"] == null ? null : json["name"],
    namear: json["namear"] == null ? null : json["namear"],
    chatId: json["chat_id"] == null ? null : json["chat_id"],
    lastMessage: json["last_message"] == null ? null : json["last_message"],
    lastMessageDate: json["last_message_date"] == null ? null : json["last_message_date"],
    lastMessageTime: json["last_message_time"] == null ? null : json["last_message_time"],
    isRead: json["is_read"] == null ? null : json["is_read"],
    picpath: json["picpath"] == null ? null : json["picpath"],
  );

  Map<String, dynamic> toJson() => {
    "company_id": companyId == null ? null : companyId,
    "name": name == null ? null : name,
    "namear": namear == null ? null : namear,
    "chat_id": chatId == null ? null : chatId,
    "last_message": lastMessage == null ? null : lastMessage,
    "last_message_date": lastMessageDate == null ? null : lastMessageDate,
    "last_message_time": lastMessageTime == null ? null : lastMessageTime,
    "is_read": isRead == null ? null : isRead,
    "picpath": picpath == null ? null : picpath,
  };
}
