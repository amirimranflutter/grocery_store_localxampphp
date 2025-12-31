import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/appConstant.dart';
import '../model/sales_record.dart';

class SalesService {
  Future<List<SalesRecord>> fetchSalesReport() async {
    try {
      final response = await http.get(Uri.parse("${AppConstants.baseUrl}/orders/get_sales_report.php"));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => SalesRecord.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  Future<bool> createOrder(List<Map<String, dynamic>> cart, double total) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/orders/create_order.php"),
        headers: {"Content-Type": "application/json"}, // Tell PHP we are sending JSON
        body: json.encode({
          "cart": cart,
          "total": total,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error creating order: $e");
      return false;
    }
  }
}