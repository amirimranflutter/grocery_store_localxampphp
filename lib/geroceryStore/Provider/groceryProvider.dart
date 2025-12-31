import 'dart:convert';
import 'package:grocerystore_local/geroceryStore/model/employee.dart';
import 'package:http/http.dart' as http;

class GroceryProvider {
  Future<List<Employee>> fetchEmployees() async {
    final url = Uri.parse('http://192.168.1.20/grocery_api/get_employees.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}