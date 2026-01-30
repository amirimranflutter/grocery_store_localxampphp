import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/appConstant.dart';

class OrderService {
  Future<bool> createOrder({
    int? customerId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required double discountAmount,
    required double taxAmount,
    required double finalAmount,
    required String paymentMethod,
    int? empId,
  }) async {
    try {
      // Prepare order items
      final orderItems = items.map((item) {
        return {
          'p_id': item['id'],
          'quantity': item['qty'],
          'unit_price': item['price'],
          'subtotal': item['price'] * item['qty'],
        };
      }).toList();

      // Prepare order data
      final orderData = {
        'customer_id': customerId,
        'emp_id': empId ?? 1, // Default employee ID
        'total_amount': totalAmount,
        'discount_amount': discountAmount,
        'tax_amount': taxAmount,
        'final_amount': finalAmount,
        'payment_method': paymentMethod,
        'order_status': 'completed',
        'items': orderItems,
      };

      final response = await http.post(
        Uri.parse(AppConstants.createOrder),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }
}
