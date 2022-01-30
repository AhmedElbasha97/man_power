class CompanyWalletItem {
  CompanyWalletItem({
    this.id,
    this.amount,
    this.notes,
    this.expiration,
    this.created,
  });

  String? id;
  String? amount;
  String? notes;
  String? expiration;
  String? created;

  factory CompanyWalletItem.fromJson(Map<String, dynamic> json) =>
      CompanyWalletItem(
        id: json["id"] == null ? null : json["id"],
        amount: json["amount"] == null ? null : json["amount"],
        notes: json["notes"] == null ? null : json["notes"],
        expiration: json["expiration"] == null ? null : json["expiration"],
        created: json["created"] == null ? null : json["created"],
      );
}
