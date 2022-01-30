// To parse this JSON data, do
//
//     final paymentData = paymentDataFromJson(jsonString);

class PaymentData {
  PaymentData({
    this.subscriptionRenewal,
    this.viewConatcts,
    this.addJob,
  });

  String? subscriptionRenewal;
  String? viewConatcts;
  String? addJob;

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        subscriptionRenewal: json["subscription_renewal"] == null
            ? null
            : json["subscription_renewal"],
        viewConatcts:
            json["view_conatcts"] == null ? null : json["view_conatcts"],
        addJob: json["add_job"] == null ? null : json["add_job"],
      );
}
