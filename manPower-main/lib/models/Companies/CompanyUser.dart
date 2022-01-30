class CompanyUserModel {
  CompanyUserModel({
    this.companyid,
    this.membership,
    this.userstats,
    this.password,
    this.name,
    this.namear,
    this.expiration,
    this.email,
    this.username,
    this.mobile,
    this.tel,
    this.whatsapp,
    this.address,
    this.map,
    this.detailsAr,
    this.detailsEn,
    this.country,
    this.specialtyid,
    this.specialty,
    this.subscriptionid,
    this.subscriptions,
    this.picpath,
  });

  String? companyid;
  String? membership;
  String? userstats;
  String? password;
  String? name;
  String? namear;
  dynamic expiration;
  String? email;
  String? username;
  String? mobile;
  String? tel;
  String? whatsapp;
  dynamic address;
  String? map;
  dynamic detailsAr;
  dynamic detailsEn;
  String? country;
  String? specialtyid;
  String? specialty;
  String? subscriptionid;
  String? subscriptions;
  String? picpath;

  factory CompanyUserModel.fromJson(Map<String, dynamic> json) =>
      CompanyUserModel(
        companyid: json["companyid"] == null ? null : json["companyid"],
        membership: json["membership"] == null ? null : json["membership"],
        userstats: json["userstats"] == null ? null : json["userstats"],
        password: json["password"] == null ? null : json["password"],
        name: json["name"] == null ? null : json["name"],
        namear: json["namear"] == null ? null : json["namear"],
        expiration: json["expiration"],
        email: json["email"] == null ? null : json["email"],
        username: json["username"] == null ? null : json["username"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        tel: json["tel"] == null ? null : json["tel"],
        whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
        address: json["address"],
        map: json["map"] == null ? null : json["map"],
        detailsAr: json["details_ar"],
        detailsEn: json["details_en"],
        country: json["country"] == null ? null : json["country"],
        specialtyid: json["specialtyid"] == null ? null : json["specialtyid"],
        specialty: json["specialty"] == null ? null : json["specialty"],
        subscriptionid:
            json["subscriptionid"] == null ? null : json["subscriptionid"],
        subscriptions:
            json["subscriptions"] == null ? null : json["subscriptions"],
        picpath: json["picpath"] == null ? null : json["picpath"],
      );
}
