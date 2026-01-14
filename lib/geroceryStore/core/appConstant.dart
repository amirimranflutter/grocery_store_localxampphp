class AppConstants {
  // API Configuration
  static const String ipAddress = "192.168.1.20"; // Update this per your ipconfig
  static const String baseUrl = "http://$ipAddress/grocery_api";

  // Endpoints
  static const String getProducts = "$baseUrl/products/get_products.php";
  static const String addOrder = "$baseUrl/orders/create_order.php";
  static const String getEmployees = "$baseUrl/staff/get_employees.php";
  static const String getCategories = "$baseUrl/products/get_categories.php";

  // Design Constants
  static const double borderRadius = 16.0;
  static const double defaultPadding = 20.0;
}