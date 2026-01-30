import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/order.dart';
import '../core/appConstant.dart';

class OrderServiceEnhanced {
  Future<List<Order>> getOrders({int? customerId, int limit = 50}) async {
    try {
      String url = AppConstants.getOrders;
      if (customerId != null) {
        url += '?customer_id=$customerId';
      }
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> ordersJson = data['data'];
          return ordersJson.map((json) => Order.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getOrderDetails(int orderId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.getOrderDetails}?order_id=$orderId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      print('Error fetching order details: $e');
      return null;
    }
  }
}
