class AppConstants {
  // API Configuration
  static const String ipAddress = "192.168.1.72";

  // Base URL should point to the main project folder
  static const String baseUrl = "http://$ipAddress/grocery_api";

  // Endpoints: Point specifically to the 'products' subfolder
  static const String getProducts = "$baseUrl/products/get_products.php";
  static const String addProduct = "$baseUrl/products/add_product.php";
  static const String addOrder = "$baseUrl/create_order.php";
  static const String getEmployees = "$baseUrl/get_employees.php";
  static const String getCategories = "$baseUrl/products/get_categories.php";

  // Design Constants
  static const double borderRadius = 16.0;
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusLarge = 15.0;
  static const double defaultPadding = 20.0;
  static const double gridSpacing = 16.0;
  static const double cardElevation = 2.0;

  // Responsive Layout Constants - Updated to match requirements
  static const double mobileBreakpoint = 600.0; // Mobile <600px
  static const double tabletBreakpoint = 1024.0; // Tablet 600-1024px
  static const double desktopBreakpoint = 1024.0; // Desktop 1024px+

  // Responsive Padding Range (16-48px)
  static const double minPadding = 16.0;
  static const double maxPadding = 48.0;

  // Responsive Icon Sizes (20-56px)
  static const double minIconSize = 20.0;
  static const double maxIconSize = 56.0;

  // Content Max Width (1200-1400px)
  static const double minContentWidth = 1200.0;
  static const double maxContentWidth = 1400.0;
}
