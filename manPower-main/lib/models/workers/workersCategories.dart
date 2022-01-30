class WorkersCategory {
  WorkersCategory({
    this.categoryWorkerId,
    this.categoryWorkerName,
    this.categoryWorkerNameEn,
  });

  String? categoryWorkerId;
  String? categoryWorkerName;
  String? categoryWorkerNameEn;

  factory WorkersCategory.fromJson(Map<String, dynamic> json) =>
      WorkersCategory(
        categoryWorkerId: json["category_worker_id"] == null
            ? null
            : json["category_worker_id"],
        categoryWorkerName: json["category_worker_name"] == null
            ? ""
            : json["category_worker_name"],
        categoryWorkerNameEn: json["category_worker_name_en"] == null
            ? ""
            : json["category_worker_name_en"],
      );
}
