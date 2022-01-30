class PackagesModel {
  PackagesModel({
    this.packageId,
    this.titleAr,
    this.titleEn,
    this.value,
  });

  String? packageId;
  String? titleAr;
  String? titleEn;
  String? value;

  factory PackagesModel.fromJson(Map<String, dynamic> json) => PackagesModel(
        packageId: json["package_id"] == null ? null : json["package_id"],
        titleAr: json["title_ar"] == null ? null : json["title_ar"],
        titleEn: json["title_en"] == null ? null : json["title_en"],
        value: json["value"] == null ? null : json["value"],
      );
}
