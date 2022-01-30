class CompanyInfo {
  CompanyInfo({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
        status: json["status"] == null ? "" : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.companyId,
    this.nameAr,
    this.nameEn,
    this.balance,
    this.username,
    this.email,
    this.mobile,
    this.tel,
    this.whatsapp,
    this.address,
    this.map,
    this.twitter,
    this.facebook,
    this.youtube,
    this.instagram,
    this.categoryId,
    this.categoryNameEn,
    this.categoryNameAr,
    this.detailsAr,
    this.detailsEn,
    this.image1,
    this.image2,
    this.image3,
    this.workers,
    this.orders,
    this.expiration,
  });

  String? companyId;
  String? nameAr;
  String? nameEn;
  String? balance;
  String? username;
  String? email;
  String? mobile;
  String? tel;
  String? whatsapp;
  String? address;
  String? map;
  String? twitter;
  String? facebook;
  String? youtube;
  String? instagram;
  String? categoryId;
  String? categoryNameEn;
  String? categoryNameAr;
  String? detailsAr;
  String? detailsEn;
  String? image1;
  String? image2;
  String? image3;
  int? workers;
  int? orders;
  String? expiration;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        companyId: json["company_id"] == null ? "" : json["company_id"],
        nameAr: json["name_ar"] == null ? "" : json["name_ar"],
        nameEn: json["name_en"] == null ? "" : json["name_en"],
        balance: json["balance"] == null ? "" : json["balance"],
        username: json["username"] == null ? "" : json["username"],
        email: json["email"] == null ? "" : json["email"],
        mobile: json["mobile"] == null ? "" : json["mobile"],
        tel: json["tel"] == null ? "" : json["tel"],
        whatsapp: json["whatsapp"] == null ? "" : json["whatsapp"],
        address: json["address"] == null ? "" : json["address"],
        map: json["map"] == null ? "" : json["map"],
        twitter: json["twitter"] == null ? "" : json["twitter"],
        facebook: json["facebook"] == null ? "" : json["facebook"],
        youtube: json["youtube"] == null ? "" : json["youtube"],
        instagram: json["instagram"] == null ? "" : json["instagram"],
        categoryId: json["category_id"] == null ? "" : json["category_id"],
        categoryNameEn:
            json["category_name_en"] == null ? "" : json["category_name_en"],
        categoryNameAr:
            json["category_name_ar"] == null ? "" : json["category_name_ar"],
        detailsAr: json["details_ar"] == null ? "" : json["details_ar"],
        detailsEn: json["details_en"] == null ? "" : json["details_en"],
        image1: json["image1"] == null ? "" : json["image1"],
        image2: json["image2"] == null ? "" : json["image2"],
        image3: json["image3"] == null ? "" : json["image3"],
        workers: json["workers"] == null ? "" as int? : json["workers"],
        orders: json["orders"] == null ? "" as int? : json["orders"],
        expiration: json["expiration"] == null
            ? ""
            : DateTime.parse(json["expiration"]) as String?,
      );
}
