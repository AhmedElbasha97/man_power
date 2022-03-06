// To parse this JSON data, do
//
//     final rating = ratingFromJson(jsonString);

import 'dart:convert';

StatisticsModel ratingFromJson(String str) => StatisticsModel.fromJson(json.decode(str));

String ratingToJson(StatisticsModel data) => json.encode(data.toJson());

class StatisticsModel {
  StatisticsModel({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory StatisticsModel.fromJson(Map<String, dynamic> json) => StatisticsModel(
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "data": data == null ? null : data?.toJson(),
  };
}

class Data {
  Data({
    this.facebook,
    this.twitter,
    this.youtube,
    this.instagram,
    this.chat,
    this.mobile,
    this.whatsapp,
  });

  String? facebook;
  String? twitter;
  String? youtube;
  String? instagram;
  String? chat;
  String? mobile;
  String? whatsapp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    facebook: json["facebook"] == null ? null : json["facebook"],
    twitter: json["twitter"] == null ? null : json["twitter"],
    youtube: json["youtube"] == null ? null : json["youtube"],
    instagram: json["instagram"] == null ? null : json["instagram"],
    chat: json["chat"]== null ? null : json["chat"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
  );

  Map<String, dynamic> toJson() => {
    "facebook": facebook == null ? null : facebook,
    "twitter": twitter == null ? null : twitter,
    "youtube": youtube == null ? null : youtube,
    "instagram": instagram == null ? null : instagram,
    "chat": chat,
    "mobile": mobile == null ? null : mobile,
    "whatsapp": whatsapp == null ? null : whatsapp,
  };
}
