import 'package:flutter/material.dart';
import '../../core/appColors.dart';
import '../../model/sales_record.dart';
import '../../services/sale_service.dart';

class SalesSummaryScreen extends StatefulWidget {
  const SalesSummaryScreen({super.key});

  @override
  State<SalesSummaryScreen> createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends State<SalesSummaryScreen> {
  late Future<List<SalesRecord>> _salesHistory;

  @override
  void initState() {
    super.initState();
    _salesHistory = SalesService().fetchSalesReport();
  }

  // Helper to calculate total revenue from the list
  double _calculateTotal(List<SalesRecord> records) {
    return records.fold(0, (sum, item) => sum + (item.price * item.qty));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Report')),
      body: FutureBuilder<List<SalesRecord>>(
        future: _salesHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sales = snapshot.data ?? [];
          final totalRevenue = _calculateTotal(sales);

          return Column(
            children: [
              _buildSummaryHeader(totalRevenue, sales.length),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final record = sales[index];
                    return _buildSalesRow(record);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryHeader(double total, int count) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.primary.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _headerItem("Total Revenue", "\$${total.toStringAsFixed(2)}", AppColors.primary),
          _headerItem("Orders", count.toString(), Colors.blue),
        ],
      ),
    );
  }

  Widget _headerItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildSalesRow(SalesRecord record) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(record.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(record.date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Text("${record.qty}x", style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 20),
          Text("\$${(record.price * record.qty).toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}