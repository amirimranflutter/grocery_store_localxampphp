class SalesRecord {
  final String orderId;
  final String productName;
  final int qty;
  final double price;
  final String date;

  SalesRecord({
    required this.orderId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.date,
  });

  factory SalesRecord.fromJson(Map<String, dynamic> json) {
    return SalesRecord(
      orderId: json['order_id'].toString(),
      productName: json['p_name'],
      qty: int.parse(json['quantity'].toString()),
      price: double.parse(json['unit_price'].toString()),
      date: json['order_date'],
    );
  }
}