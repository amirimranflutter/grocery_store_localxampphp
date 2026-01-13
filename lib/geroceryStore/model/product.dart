class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.categoryName,
  });

  // Convert JSON from PHP into a Flutter Object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['p_id'].toString(),
      name: json['p_name'] ?? 'Unknown',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      categoryName: json['cat_name'] ?? 'Uncategorized',
    );
  }
}