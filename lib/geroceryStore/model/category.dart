class StoreCategory {
  final int catId;
  final String catName;

  StoreCategory({
    required this.catId,
    required this.catName,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      catId: int.parse(json['cat_id'].toString()),
      catName: json['cat_name'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cat_id': catId,
      'cat_name': catName,
    };
  }
}