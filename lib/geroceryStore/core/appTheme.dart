import 'package:flutter/material.dart';
import 'package:grocerystore_local/geroceryStore/core/appConstant.dart';
import 'appColors.dart';
import 'package:flutter/material.dart';
import 'package:grocerystore_local/geroceryStore/core/appConstant.dart';
import 'appColors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      // FIX: Assign cardTheme directly as a property of ThemeData
      // cardTheme: CardTheme(
      //   color: AppColors.surface,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      //     side: BorderSide(color: Colors.grey.shade200),
      //   ),
      // ),
cardTheme: CardThemeData(
  color: AppColors.surface,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(AppConstants.borderRadius),
    side: BorderSide(color: Colors.grey.shade200)
  )
),

      // AppBar Design
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.textPrimary,
        ),
      ),

      // Input Decoration (Text fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}