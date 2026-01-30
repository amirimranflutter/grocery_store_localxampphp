import 'package:flutter/material.dart';
import 'package:grocerystore_local/geroceryStore/screens/staff/staff_management.dart';
import '../core/appColors.dart';
import 'inventory/inventory.dart';
import 'customers/customers_screen.dart';
import 'orders/orders_screen.dart';
import 'analytics/analytics_screen.dart';
import 'checkout_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final isTablet = screenWidth > 600 && screenWidth <= 900;
    
    // Responsive grid columns
    int crossAxisCount = 2;
    if (isDesktop) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
    }
    
    // Responsive max width for content
    final maxContentWidth = isDesktop ? 1200.0 : double.infinity;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: CustomScrollView(
              slivers: [
                // Custom Header
                SliverToBoxAdapter(
                  child: _buildHeader(context, isDesktop),
                ),
                // Menu Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? 32 : 20, 
                      24, 
                      isDesktop ? 32 : 20, 
                      12
                    ),
                    child: const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                // Menu Grid
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 20,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 1.2 : 1.1,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildMenuCard(
                        context,
                        'Inventory',
                        Icons.inventory_2_rounded,
                        AppColors.primary,
                        AppColors.primaryLight,
                        InventoryScreen(),
                      ),
                      _buildMenuCard(
                        context,
                        'Customers',
                        Icons.people_rounded,
                        const Color(0xFF9C27B0),
                        const Color(0xFFCE93D8),
                        CustomersScreen(),
                      ),
                      _buildMenuCard(
                        context,
                        'Orders',
                        Icons.receipt_long_rounded,
                        const Color(0xFF2196F3),
                        const Color(0xFF64B5F6),
                        OrdersScreen(),
                      ),
                      _buildMenuCard(
                        context,
                        'New Sale',
                        Icons.point_of_sale_rounded,
                        AppColors.success,
                        const Color(0xFF69F0AE),
                        CheckoutScreen(),
                      ),
                      _buildMenuCard(
                        context,
                        'Analytics',
                        Icons.bar_chart_rounded,
                        AppColors.accent,
                        const Color(0xFFFFD54F),
                        AnalyticsScreen(),
                      ),
                      _buildMenuCard(
                        context,
                        'Staff',
                        Icons.badge_rounded,
                        AppColors.secondary,
                        AppColors.secondaryLight,
                        StaffManagementScreen(),
                      ),
                    ]),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 20),
      margin: isDesktop 
          ? const EdgeInsets.fromLTRB(32, 16, 32, 0) 
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: isDesktop
            ? BorderRadius.circular(24)
            : const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey, Umar 👋',
                style: TextStyle(
                  fontSize: isDesktop ? 32 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back to your store',
                style: TextStyle(
                  fontSize: isDesktop ? 16 : 14,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(isDesktop ? 16 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.store_rounded,
              color: Colors.white,
              size: isDesktop ? 36 : 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Color lightColor,
    Widget nextScreen,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, lightColor],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decoration
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  icon,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: Colors.white, size: 28),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Open',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}