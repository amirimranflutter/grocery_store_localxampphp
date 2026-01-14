import 'dart:convert';

import 'package:grocerystore_local/geroceryStore/model/category.dart';
import 'package:grocerystore_local/geroceryStore/model/product.dart';
import 'package:http/http.dart' as http;

import '../core/appConstant.dart';

class ProductService {
  // 1. Changed return type to List<Product>
  Future<List<Product>> fetchAllProducts() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.getProducts));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error at fetching product: $e");
      return []; // Return empty list on error
    }
  }

  Future<List<StoreCategory>> fetchAllCategories() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.getCategories));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => StoreCategory.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("CATCH ERROR: $e");
      return [];
    }
  }

  // POST new product to PHP
  // POST new product to PHP
  // Future<bool> addProduct(
  //     String name,
  //     String price,
  //     String stock,
  //     String quantity,
  //     String catId,
  //     String date,
  //     ) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse("${addProduct}"),
  //       body: {
  //         "p_name": name,
  //         "price": price,
  //         "stock": stock,
  //         "quantity": quantity, // This matches the $quantity = $_POST['quantity'] in PHP
  //         "cat_id": catId,
  //         "date": date,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       print("Server Error: ${response.body}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Connection Error: $e");
  //     return false;
  //   }
  // }

  Future<bool> addProduct(String name, String price, String stock, String quantity, String catId, String date) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.addProduct),
        body: {
          "p_name": name,
          "price": price,
          "stock": stock,
          "quantity": quantity,
          "cat_id": catId,
          "date": date,
        },
      );

      print("Server Response Code: ${response.statusCode}");
      print("Server Response Body: ${response.body}"); // THIS WILL SHOW THE REAL ERROR

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body);
        print('result->>> $result');
        return result['status'] == 'success';
      }
      return true;
    } catch (e) {
      print("Network Exception: $e"); // Check if this prints 'Connection Refused'
      return false;
    }
  }

  // Update existing product stock or price
  Future<bool> updateProduct(String id, String price, String stock) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/products/update_product.php"),
        body: {"p_id": id, "price": price, "stock": stock},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Delete a product by ID
  Future<bool> deleteProduct(int productId) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/products/delete_product.php"),
        body: {"p_id": productId.toString()},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print("Error deleting product: $e");
      return false;
    }
  }
}
