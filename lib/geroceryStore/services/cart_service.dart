import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cart_item.dart';
import '../core/appConstant.dart';

class CartService {
  Future<Map<String, dynamic>> getCart(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.getCart}?customer_id=$customerId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> itemsJson = data['data'];
          List<CartItem> items = itemsJson.map((json) => CartItem.fromJson(json)).toList();
          double totalAmount = double.parse(data['total_amount']?.toString() ?? '0.0');
          
          return {
            'items': items,
            'total': totalAmount,
            'count': data['count'] ?? 0,
          };
        }
      }
      return {'items': [], 'total': 0.0, 'count': 0};
    } catch (e) {
      print('Error fetching cart: $e');
      return {'items': [], 'total': 0.0, 'count': 0};
    }
  }

  Future<bool> addToCart(int customerId, int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.addToCart),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'customer_id': customerId,
          'p_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  Future<bool> removeFromCart(int cartItemId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.removeFromCart),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'cart_item_id': cartItemId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }
}
