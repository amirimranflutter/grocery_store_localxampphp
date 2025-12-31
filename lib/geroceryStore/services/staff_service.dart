import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/appConstant.dart';
import '../model/employee.dart';

class StaffService {
  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse("${AppConstants.baseUrl}/staff/get_employee.php"));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Employee.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load staff');
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