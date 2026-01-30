import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/appConstant.dart';

class ReportService {
  Future<Map<String, dynamic>> getInventoryReport() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.inventoryReport));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data;
        }
      }
      return {};
    } catch (e) {
      print('Error fetching inventory report: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getSalesSummary({String? startDate, String? endDate}) async {
    try {
      String url = AppConstants.salesSummary;
      if (startDate != null && endDate != null) {
        url += '?start_date=$startDate&end_date=$endDate';
      }
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data;
        }
      }
      return {};
    } catch (e) {
      print('Error fetching sales summary: $e');
      return {};
    }
  }
}
