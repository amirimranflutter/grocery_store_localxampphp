class Supplier {
  final int supplierId;
  final String supplierName;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? country;
  final int? totalProducts;

  Supplier({
    required this.supplierId,
    required this.supplierName,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.country,
    this.totalProducts,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      supplierId: int.parse(json['supplier_id'].toString()),
      supplierName: json['supplier_name'] ?? '',
      contactPerson: json['contact_person'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      totalProducts: json['total_products'] != null ? int.parse(json['total_products'].toString()) : null,
    );
  }
}
