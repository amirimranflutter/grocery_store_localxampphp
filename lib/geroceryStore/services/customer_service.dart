import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/customer.dart';
import '../core/appConstant.dart';

class CustomerService {
  Future<List<Customer>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.getCustomers));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> customersJson = data['data'];
          return customersJson.map((json) => Customer.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching customers: $e');
      return [];
    }
  }

  Future<bool> addCustomer(Customer customer) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.addCustomer),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'customer_name': customer.customerName,
          'email': customer.email,
          'phone': customer.phone,
          'address': customer.address,
          'city': customer.city,
          'postal_code': customer.postalCode,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error adding customer: $e');
      return false;
    }
  }
}
