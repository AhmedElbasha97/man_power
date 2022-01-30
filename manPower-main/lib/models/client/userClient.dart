class UserClientMOdel {
  UserClientMOdel({
    this.clientId,
    this.nameAr,
    this.nameEn,
    this.mobile,
    this.username,
    this.email,
    this.balance,
    this.tel,
    this.whatsapp,
    this.detailsAr,
    this.detailsEn,
  });

  String? clientId;
  String? nameAr;
  String? nameEn;
  String? mobile;
  String? username;
  String? email;
  String? balance;
  String? tel;
  String? whatsapp;
  String? detailsAr;
  String? detailsEn;

  factory UserClientMOdel.fromJson(Map<String, dynamic> json) =>
      UserClientMOdel(
        clientId: json["client_id"] == null ? "" : json["client_id"],
        nameAr: json["name_ar"] == null ? "" : json["name_ar"],
        nameEn: json["name_en"] == null ? "" : json["name_en"],
        mobile: json["mobile"] == null ? "" : json["mobile"],
        username: json["username"] == null ? "" : json["username"],
        email: json["email"] == null ? "" : json["email"],
        balance: json["balance"] == null ? "" : json["balance"],
        tel: json["tel"] == null ? "" : json["tel"],
        whatsapp: json["whatsapp"] == null ? "" : json["whatsapp"],
        detailsAr: json["details_ar"] == null ? "" : json["details_ar"],
        detailsEn: json["details_en"] == null ? "" : json["details_en"],
      );
}
