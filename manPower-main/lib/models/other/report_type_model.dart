import 'dart:convert';

List<ReportType> reportTypeFromJson(String str) => List<ReportType>.from(json.decode(str).map((x) => ReportType.fromJson(x)));

String reportTypeToJson(List<ReportType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportType {
  ReportType({
    this.id,
    this.titleen,
    this.titlear,
    this.oid,
    this.publish,
    this.created,
  });

  String? id;
  String? titleen;
  String? titlear;
  String? oid;
  String? publish;
  String? created;

  factory ReportType.fromJson(Map<String, dynamic> json) => ReportType(
    id: json["id"] == null ? null : json["id"],
    titleen: json["titleen"] == null ? null : json["titleen"],
    titlear: json["titlear"] == null ? null : json["titlear"],
    oid: json["oid"] == null ? null : json["oid"],
    publish: json["publish"] == null ? null : json["publish"],
    created: json["created"] == null ? null : json["created"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "titleen": titleen == null ? null : titleen,
    "titlear": titlear == null ? null : titlear,
    "oid": oid == null ? null : oid,
    "publish": publish == null ? null : publish,
    "created": created == null ? null : created,
  };
}
