import 'package:flutter/material.dart';
import '../../services/report_service.dart';
import '../../core/appColors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  final ReportService _reportService = ReportService();
  late TabController _tabController;
  
  Map<String, dynamic> _salesData = {};
  Map<String, dynamic> _inventoryData = {};
  bool _isLoadingSales = true;
  bool _isLoadingInventory = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _loadSalesData();
    _loadInventoryData();
  }

  Future<void> _loadSalesData() async {
    setState(() => _isLoadingSales = true);
    final data = await _reportService.getSalesSummary();
    setState(() {
      _salesData = data;
      _isLoadingSales = false;
    });
  }

  Future<void> _loadInventoryData() async {
    setState(() => _isLoadingInventory = true);
    final data = await _reportService.getInventoryReport();
    setState(() {
      _inventoryData = data;
      _isLoadingInventory = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.trending_up), text: 'Sales'),
            Tab(icon: Icon(Icons.inventory), text: 'Inventory'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSalesTab(),
          _buildInventoryTab(),
        ],
      ),
    );
  }

  Widget _buildSalesTab() {
    if (_isLoadingSales) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_salesData.isEmpty) {
      return const Center(child: Text('No sales data available'));
    }

    final summary = _salesData['summary'] ?? {};
    final topProducts = _salesData['top_products'] ?? [];
    final categories = _salesData['sales_by_category'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Orders',
                  summary['total_orders']?.toString() ?? '0',
                  Icons.shopping_cart,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Revenue',
                  '\$${_formatNumber(summary['total_revenue'])}',
                  Icons.attach_money,
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Avg Order',
                  '\$${_formatNumber(summary['average_order_value'])}',
                  Icons.receipt,
                  AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Items Sold',
                  summary['total_items_sold']?.toString() ?? '0',
                  Icons.inventory_2,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Top Products
          const Text(
            'Top Selling Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            topProducts.length > 5 ? 5 : topProducts.length,
            (index) {
              final product = topProducts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  title: Text(product['p_name'] ?? ''),
                  subtitle: Text(
                    '${product['cat_name'] ?? ''} • Sold: ${product['total_quantity']}',
                  ),
                  trailing: Text(
                    '\$${_formatNumber(product['total_revenue'])}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Sales by Category
          const Text(
            'Sales by Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            categories.length,
            (index) {
              final category = categories[index];
              final revenue = double.parse(category['total_revenue']?.toString() ?? '0');
              final maxRevenue = categories.isNotEmpty
                  ? double.parse(categories[0]['total_revenue']?.toString() ?? '1')
                  : 1;
              final percentage = (revenue / maxRevenue * 100).clamp(0, 100);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category['cat_name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\$${_formatNumber(category['total_revenue'])}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category['total_quantity']} items sold',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    if (_isLoadingInventory) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_inventoryData.isEmpty) {
      return const Center(child: Text('No inventory data available'));
    }

    final stats = _inventoryData['overall_stats'] ?? {};
    final lowStock = _inventoryData['low_stock_products'] ?? [];
    final byCategory = _inventoryData['inventory_by_category'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inventory Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Products',
                  stats['total_products']?.toString() ?? '0',
                  Icons.inventory,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Units',
                  stats['total_units']?.toString() ?? '0',
                  Icons.inventory_2,
                  AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Inventory Cost',
                  '\$${_formatNumber(stats['total_cost'])}',
                  Icons.money_off,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Inventory Value',
                  '\$${_formatNumber(stats['total_value'])}',
                  Icons.attach_money,
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Low Stock Alert
          if (lowStock.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.warning, color: AppColors.error),
                const SizedBox(width: 8),
                Text(
                  'Low Stock Alert (${lowStock.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(
              lowStock.length,
              (index) {
                final product = lowStock[index];
                final stock = int.parse(product['stock']?.toString() ?? '0');
                final minLevel = int.parse(product['min_stock_level']?.toString() ?? '0');
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: AppColors.error.withOpacity(0.1),
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber, color: AppColors.error),
                    title: Text(product['p_name'] ?? ''),
                    subtitle: Text(
                      '${product['cat_name'] ?? ''} • Supplier: ${product['supplier_name'] ?? 'N/A'}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Stock: $stock',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        Text(
                          'Min: $minLevel',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],

          // Inventory by Category
          const Text(
            'Inventory by Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            byCategory.length,
            (index) {
              final category = byCategory[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['cat_name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${category['product_count']} Products',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                '${category['total_units']} Units',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Cost: \$${_formatNumber(category['inventory_cost'])}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Value: \$${_formatNumber(category['inventory_value'])}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    final num = double.tryParse(value.toString()) ?? 0;
    return num.toStringAsFixed(2);
  }
}
