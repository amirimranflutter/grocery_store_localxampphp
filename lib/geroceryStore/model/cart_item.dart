class CartItem {
  final int cartItemId;
  final int cartId;
  final int productId;
  final String productName;
  final String? productDescription;
  final double price;
  int quantity;
  final int stock;
  final String? categoryName;
  final String? barcode;

  CartItem({
    required this.cartItemId,
    required this.cartId,
    required this.productId,
    required this.productName,
    this.productDescription,
    required this.price,
    required this.quantity,
    required this.stock,
    this.categoryName,
    this.barcode,
  });

  double get subtotal => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: int.parse(json['cart_item_id'].toString()),
      cartId: int.parse(json['cart_id'].toString()),
      productId: int.parse(json['p_id'].toString()),
      productName: json['p_name'] ?? '',
      productDescription: json['p_description'],
      price: double.parse(json['price'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      stock: int.parse(json['stock'].toString()),
      categoryName: json['cat_name'],
      barcode: json['barcode'],
    );
  }
}
