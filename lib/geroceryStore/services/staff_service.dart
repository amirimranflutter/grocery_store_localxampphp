import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/appConstant.dart';
import '../model/employee.dart';

class StaffService {
  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse("${AppConstants.baseUrl}/staff/get_employee.php"));

      print("Staff API Status: ${response.statusCode}");
      print("Staff API Body: ${response.body}");

      if (response.statusCode == 200) {
        // Check if response is valid JSON (not HTML error)
        if (response.body.trim().startsWith('<')) {
          throw Exception('Server returned HTML error instead of JSON. Check PHP logs.');
        }
        List data = json.decode(response.body);
        return data.map((item) => Employee.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load staff: ${response.statusCode}');
      }
    } catch (e) {
      print("Staff fetch error: $e");
      rethrow;
    }
  }

  Future<bool> deleteEmployee(String id) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/staff/delete_employee.php"),
        body: {"empid": id},
      );
      print("Delete Status: ${response.statusCode}");
      print("Delete Body: ${response.body}"); // Check if it says {"status":"success"}
      return response.statusCode == 200;
    } catch (e) {
      print("Network Error: $e");
      return false;
    }
  }

  Future<bool> addEmployee(String name, String salary) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/staff/add_employee.php"),
        body: {
          "empName": name,
          "empSalary": salary,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}