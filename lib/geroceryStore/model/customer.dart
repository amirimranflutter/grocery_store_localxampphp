class Customer {
  final int customerId;
  final String customerName;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? postalCode;
  final int loyaltyPoints;
  final double totalPurchases;
  final int? totalOrders;
  final double? lifetimeValue;

  Customer({
    required this.customerId,
    required this.customerName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.postalCode,
    this.loyaltyPoints = 0,
    this.totalPurchases = 0.0,
    this.totalOrders,
    this.lifetimeValue,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: int.parse(json['customer_id'].toString()),
      customerName: json['customer_name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postal_code'],
      loyaltyPoints: int.parse(json['loyalty_points']?.toString() ?? '0'),
      totalPurchases: double.parse(json['total_purchases']?.toString() ?? '0.0'),
      totalOrders: json['total_orders'] != null ? int.parse(json['total_orders'].toString()) : null,
      lifetimeValue: json['lifetime_value'] != null ? double.parse(json['lifetime_value'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'customer_name': customerName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'loyalty_points': loyaltyPoints,
      'total_purchases': totalPurchases,
    };
  }
}
