class Categories {
  Categories({
    this.categoryId,
    this.categoryName,
    this.categoryNameEn,
  });

  String? categoryId;
  String? categoryName;
  String? categoryNameEn;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        categoryNameEn:
            json["category_name_en"] == null ? null : json["category_name_en"],
      );
}
