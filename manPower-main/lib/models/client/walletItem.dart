class WalletItem {
  WalletItem({
    this.id,
    this.amount,
    this.notes,
    this.workerId,
    this.created,
  });

  String? id;
  String? amount;
  String? notes;
  String? workerId;
  String? created;

  factory WalletItem.fromJson(Map<String, dynamic> json) => WalletItem(
        id: json["id"] == null ? null : json["id"],
        amount: json["amount"] == null ? null : json["amount"],
        notes: json["notes"] == null ? null : json["notes"],
        workerId: json["worker_id"] == null ? null : json["worker_id"],
        created: json["created"] == null ? null : json["created"],
      );
}
