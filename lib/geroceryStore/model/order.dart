class Order {
  final int orderId;
  final int? customerId;
  final int? empId;
  final double totalAmount;
  final double discountAmount;
  final double taxAmount;
  final double finalAmount;
  final String paymentMethod;
  final String orderStatus;
  final String orderDate;
  final String? customerName;
  final String? cashierName;
  final int? totalItems;
  final String? notes;

  Order({
    required this.orderId,
    this.customerId,
    this.empId,
    required this.totalAmount,
    this.discountAmount = 0.0,
    this.taxAmount = 0.0,
    required this.finalAmount,
    this.paymentMethod = 'cash',
    this.orderStatus = 'completed',
    required this.orderDate,
    this.customerName,
    this.cashierName,
    this.totalItems,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: int.parse(json['order_id'].toString()),
      customerId: json['customer_id'] != null ? int.parse(json['customer_id'].toString()) : null,
      empId: json['emp_id'] != null ? int.parse(json['emp_id'].toString()) : null,
      totalAmount: double.parse(json['total_amount'].toString()),
      discountAmount: double.parse(json['discount_amount']?.toString() ?? '0.0'),
      taxAmount: double.parse(json['tax_amount']?.toString() ?? '0.0'),
      finalAmount: double.parse(json['final_amount'].toString()),
      paymentMethod: json['payment_method'] ?? 'cash',
      orderStatus: json['order_status'] ?? 'completed',
      orderDate: json['order_date'] ?? '',
      customerName: json['customer_name'],
      cashierName: json['cashier_name'],
      totalItems: json['total_items'] != null ? int.parse(json['total_items'].toString()) : null,
      notes: json['notes'],
    );
  }
}
