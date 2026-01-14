import 'package:flutter/material.dart';
import 'package:grocerystore_local/geroceryStore/core/appColors.dart';
import 'package:grocerystore_local/geroceryStore/model/product.dart';
import 'package:grocerystore_local/geroceryStore/screens/inventory/addProductScreen.dart';
import 'package:grocerystore_local/geroceryStore/services/product_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = ProductService().fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        // Inside InventoryScreen.dart
        // Inside InventoryScreen.dart
        onPressed: () async {
          // 1. Wait for the user to finish adding a product
          final refreshNeeded = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );

          // 2. If the user saved a product (returned true), refresh the list
          if (refreshNeeded == true) {
            setState(() {
              // Re-run the fetch function to get the latest data from PHP
              _products = ProductService().fetchAllProducts();
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found in inventory.'));
          }

          // 1. Get the list of products from snapshot
          final productList = snapshot.data!;

          // 2. Return a ListView to actually SHOW the cards
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              // 3. Call your custom _buildProductCard widget here
              return _buildProductCard(productList[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    // Professional touch: Stock warning color
    Color stockColor = product.stock < 10 ? AppColors.error : AppColors.success;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Placeholder for Product Image
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_basket,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Category Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.catId.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${product.stock}',
                  style: TextStyle(
                    color: stockColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
