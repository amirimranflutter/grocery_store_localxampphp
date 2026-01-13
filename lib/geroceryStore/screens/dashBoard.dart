import 'package:flutter/material.dart';
import 'package:grocerystore_local/geroceryStore/screens/sales/sale_summary.dart';
import 'package:grocerystore_local/geroceryStore/screens/staff/staff_management.dart';
import '../core/appColors.dart';
import '../core/appConstant.dart';
import 'checkout_screen.dart';
import 'inventory/inventory.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Pro Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(context, 'Inventory', Icons.inventory_2, AppColors.primary, const InventoryScreen()),
                  _buildMenuCard(context, 'Staff', Icons.people, AppColors.primary, const StaffManagementScreen()),
                  _buildMenuCard(context, 'New Sale', Icons.point_of_sale, AppColors.primary, const CheckoutScreen()),
                  _buildMenuCard(context, 'Sales Report', Icons.bar_chart, AppColors.primary, const SalesSummaryScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey, User 👋',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        Text(
          'Keep your store running smoothly today.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Update this function in your DashboardScreen
  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, Widget nextScreen) {
    return Card(
      child: InkWell(
        onTap: () {
          // This is the "Magic" that changes the screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

}