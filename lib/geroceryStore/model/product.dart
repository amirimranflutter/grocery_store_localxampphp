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
      name: json['p_name'],
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      categoryName: json['cat_name'],
    );
  }
}