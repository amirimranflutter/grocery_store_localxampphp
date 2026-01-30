class AppConstants {
  // API Configuration
  static const String ipAddress = "192.168.1.128"; // Update this per your ipconfig
  static const String baseUrl = "http://$ipAddress/grocery_api";

  // Product Endpoints
  static const String getProducts = "$baseUrl/products/get_products.php";
  static const String addProduct = "$baseUrl/products/add_product.php";
  static const String updateProduct = "$baseUrl/products/update_product.php";
  static const String deleteProduct = "$baseUrl/products/delete_product.php";
  static const String getCategories = "$baseUrl/products/get_categories.php";

  // Customer Endpoints
  static const String getCustomers = "$baseUrl/customers/get_customers.php";
  static const String addCustomer = "$baseUrl/customers/add_customer.php";

  // Cart Endpoints
  static const String getCart = "$baseUrl/cart/get_cart.php";
  static const String addToCart = "$baseUrl/cart/add_to_cart.php";
  static const String removeFromCart = "$baseUrl/cart/remove_from_cart.php";

  // Order Endpoints
  static const String getOrders = "$baseUrl/orders/get_orders.php";
  static const String getOrderDetails = "$baseUrl/orders/get_order_details.php";
  static const String createOrder = "$baseUrl/orders/create_order.php";

  // Staff Endpoints
  static const String getEmployees = "$baseUrl/staff/get_employee.php";
  static const String addEmployee = "$baseUrl/staff/add_employee.php";
  static const String deleteEmployee = "$baseUrl/staff/delete_employee.php";

  // Supplier Endpoints
  static const String getSuppliers = "$baseUrl/suppliers/get_suppliers.php";

  // Report Endpoints
  static const String inventoryReport = "$baseUrl/reports/inventory_report.php";
  static const String salesSummary = "$baseUrl/reports/sales_summary.php";

  // Design Constants
  static const double borderRadius = 16.0;
  static const double defaultPadding = 20.0;
  static const double cardElevation = 4.0;
}