import 'package:flutter/material.dart';
import 'package:grocerystore_local/geroceryStore/screens/dashBoard.dart';
import 'geroceryStore/core/appTheme.dart';

void main() {
  // Ensure Flutter bindings are initialized before any async code
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const GroceryManagerApp());
}

class GroceryManagerApp extends StatelessWidget {
  const GroceryManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the "Debug" banner for a professional look
      debugShowCheckedModeBanner: false,

      title: 'GroceryStore Pro',

      // Applying the custom professional theme we built in core/app_theme.dart
      theme: AppTheme.lightTheme,

      // The first screen the manager sees
      home: const DashboardScreen(),

      // Optional: Logic for handling global navigation or routes
      // routes: {
      //   '/inventory': (context) => const InventoryScreen(),
      //   '/staff': (context) => const StaffScreen(),
      // },
    );
  }
}