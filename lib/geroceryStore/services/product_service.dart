import 'dart:convert';

import 'package:flutter/foundation.dart';
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
      print("Error: $e");
      return []; // Return empty list on error
    }
  }
  Future<List<StoreCategory>> fetchAllCategories() async {
    try {
      final response = await http.get(
          Uri.parse("${AppConstants.baseUrl}/products/get_categories.php")
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => StoreCategory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print("Error: $e");
      return []; // Return empty list on error
    }
  }

  /// Gets user-friendly HTTP error messages
  String _getHttpErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please try again.';
      case 401:
        return 'Authentication required. Please log in.';
      case 403:
        return 'Access denied. You do not have permission to access this resource.';
      case 404:
        return 'Categories not found. Please contact support.';
      case 500:
        return 'Server error occurred. Please try again later.';
      case 502:
        return 'Server temporarily unavailable. Please try again.';
      case 503:
        return 'Service temporarily unavailable. Please try again later.';
      case 504:
        return 'Request timed out. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  // POST new product to PHP
  Future<bool> addProduct(
    String name,
    String price,
    String stock,
    String catId,
    String date,
  ) async {
    final response = await http.post(
      Uri.parse("${AppConstants.baseUrl}/products/add_product.php"),
      body: {
        "p_name": name,
        "price": price,
        "stock": stock,
        "cat_id": catId,
        "date": date,
      },
    );
    return response.statusCode == 200;
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
}
