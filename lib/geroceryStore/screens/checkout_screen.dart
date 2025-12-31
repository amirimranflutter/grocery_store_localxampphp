import 'package:flutter/material.dart';
import '../core/appColors.dart';
import '../model/product.dart';
import '../services/sale_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final List<Map<String, dynamic>> _cart = [];
  double _total = 0;

  void _addToCart(Product product) {
    setState(() {
      _cart.add({
        "id": product.id,
        "name": product.name,
        "price": product.price,
        "qty": 1,
      });
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _total = _cart.fold(0, (sum, item) => sum + (item['price'] * item['qty']));
  }

  Future<void> _processSale() async {
    if (_cart.isEmpty) return;

    // We send the entire cart to our service
    bool success = await SalesService().createOrder(_cart, _total);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sale Completed!")),
      );
      setState(() => _cart.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Sale')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_cart[index]['name']),
                subtitle: Text("Qty: ${_cart[index]['qty']}"),
                trailing: Text("\$${_cart[index]['price']}"),
              ),
            ),
          ),
          _buildCheckoutBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () => _showProductPicker(), // Method to select product
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: \$${_total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: _processSale,
            child: const Text("Confirm Sale", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // Logic to show a dialog and pick a product from DB
  void _showProductPicker() async {
    // You can use a SimpleDialog or a Search Delegate here
  }
}