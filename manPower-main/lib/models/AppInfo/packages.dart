class PackagesModel {
  PackagesModel({
    this.packageId,
    this.titleAr,
    this.titleEn,
    this.value,
    this.featuresAr,
    this.featuresEn,
  });

  String? packageId;
  String? titleAr;
  String? titleEn;
  String? value;
  String? featuresAr;
  String? featuresEn;

  factory PackagesModel.fromJson(Map<String, dynamic> json) => PackagesModel(
        packageId: json["package_id"] == null ? null : json["package_id"],
        titleAr: json["title_ar"] == null ? null : json["title_ar"],
        titleEn: json["title_en"] == null ? null : json["title_en"],
        value: json["value"] == null ? null : json["value"],
    featuresAr: json["features_ar"] == null ? null : json["features_ar"],
    featuresEn: json["features_en"] == null ? null : json["features_en"],

      );
}
