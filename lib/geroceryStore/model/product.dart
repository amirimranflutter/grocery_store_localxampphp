class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final int quantity;
  final String date;
  final int catId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.quantity,
    required this.date,
    required this.catId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // .toString() and int.parse() is the safest way to handle JSON from PHP
      id: int.parse(json['p_id'].toString()),
      name: json['p_name'] as String,
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      date: json['date'] as String,
      catId: int.parse(json['cat_id'].toString()),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "p_id": id,
      "p_name": name,
      "price": price,
      "stock": stock,
      "quantity": quantity,
      "date": date,
      "cat_id": catId,
    };
  }
}