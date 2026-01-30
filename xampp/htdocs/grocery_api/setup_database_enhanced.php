<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$user = "root";
$pass = "";

// Connect without database first
$conn = new mysqli($host, $user, $pass);

if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit;
}

// Create database
$sql = "CREATE DATABASE IF NOT EXISTS grocerystore";
if ($conn->query($sql) !== TRUE) {
    echo json_encode(["error" => "Error creating database: " . $conn->error]);
    exit;
}

// Select the database
$conn->select_db("grocerystore");

$tables_created = [];
$errors = [];

// 1. Create categories table
$sql_categories = "CREATE TABLE IF NOT EXISTS categories (
    cat_id INT AUTO_INCREMENT PRIMARY KEY,
    cat_name VARCHAR(100) NOT NULL UNIQUE,
    cat_description TEXT,
    cat_image VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";

if ($conn->query($sql_categories) === TRUE) {
    $tables_created[] = "categories";
} else {
    $errors[] = "Categories: " . $conn->error;
}

// 2. Create suppliers table
$sql_suppliers = "CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";

if ($conn->query($sql_suppliers) === TRUE) {
    $tables_created[] = "suppliers";
} else {
    $errors[] = "Suppliers: " . $conn->error;
}

// 3. Create products table with supplier relationship
$sql_products = "CREATE TABLE IF NOT EXISTS products (
    p_id INT AUTO_INCREMENT PRIMARY KEY,
    p_name VARCHAR(255) NOT NULL,
    p_description TEXT,
    price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2),
    stock INT DEFAULT 0,
    min_stock_level INT DEFAULT 10,
    barcode VARCHAR(100) UNIQUE,
    sku VARCHAR(100) UNIQUE,
    unit VARCHAR(50) DEFAULT 'piece',
    weight DECIMAL(10,2),
    cat_id INT,
    supplier_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cat_id) REFERENCES categories(cat_id) ON DELETE SET NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL
)";

if ($conn->query($sql_products) === TRUE) {
    $tables_created[] = "products";
} else {
    $errors[] = "Products: " . $conn->error;
}

// 4. Create employees table with enhanced fields
$sql_employees = "CREATE TABLE IF NOT EXISTS employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(255) NOT NULL,
    emp_role VARCHAR(100),
    emp_phone VARCHAR(20),
    emp_email VARCHAR(100) UNIQUE,
    emp_salary DECIMAL(10,2),
    hire_date DATE,
    address TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";

if ($conn->query($sql_employees) === TRUE) {
    $tables_created[] = "employees";
} else {
    $errors[] = "Employees: " . $conn->error;
}

// 5. Create customers table
$sql_customers = "CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    postal_code VARCHAR(20),
    loyalty_points INT DEFAULT 0,
    total_purchases DECIMAL(10,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    registered_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_purchase_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";

if ($conn->query($sql_customers) === TRUE) {
    $tables_created[] = "customers";
} else {
    $errors[] = "Customers: " . $conn->error;
}

// 6. Create orders table with customer and employee relationship
$sql_orders = "CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    emp_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    final_amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('cash', 'card', 'mobile', 'online') DEFAULT 'cash',
    order_status ENUM('pending', 'completed', 'cancelled', 'refunded') DEFAULT 'completed',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE SET NULL
)";

if ($conn->query($sql_orders) === TRUE) {
    $tables_created[] = "orders";
} else {
    $errors[] = "Orders: " . $conn->error;
}

// 7. Create order_items table (junction table for orders and products)
$sql_order_items = "CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    p_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (p_id) REFERENCES products(p_id) ON DELETE RESTRICT
)";

if ($conn->query($sql_order_items) === TRUE) {
    $tables_created[] = "order_items";
} else {
    $errors[] = "Order Items: " . $conn->error;
}

// 8. Create cart table
$sql_cart = "CREATE TABLE IF NOT EXISTS cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
)";

if ($conn->query($sql_cart) === TRUE) {
    $tables_created[] = "cart";
} else {
    $errors[] = "Cart: " . $conn->error;
}

// 9. Create cart_items table
$sql_cart_items = "CREATE TABLE IF NOT EXISTS cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    p_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (p_id) REFERENCES products(p_id) ON DELETE CASCADE,
    UNIQUE KEY unique_cart_product (cart_id, p_id)
)";

if ($conn->query($sql_cart_items) === TRUE) {
    $tables_created[] = "cart_items";
} else {
    $errors[] = "Cart Items: " . $conn->error;
}

// 10. Create inventory_transactions table
$sql_inventory = "CREATE TABLE IF NOT EXISTS inventory_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    transaction_type ENUM('purchase', 'sale', 'adjustment', 'return') NOT NULL,
    quantity INT NOT NULL,
    previous_stock INT NOT NULL,
    new_stock INT NOT NULL,
    emp_id INT,
    reference_id INT,
    notes TEXT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (p_id) REFERENCES products(p_id) ON DELETE CASCADE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE SET NULL
)";

if ($conn->query($sql_inventory) === TRUE) {
    $tables_created[] = "inventory_transactions";
} else {
    $errors[] = "Inventory Transactions: " . $conn->error;
}

// 11. Create promotions table
$sql_promotions = "CREATE TABLE IF NOT EXISTS promotions (
    promotion_id INT AUTO_INCREMENT PRIMARY KEY,
    promotion_name VARCHAR(255) NOT NULL,
    description TEXT,
    discount_type ENUM('percentage', 'fixed') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($sql_promotions) === TRUE) {
    $tables_created[] = "promotions";
} else {
    $errors[] = "Promotions: " . $conn->error;
}

// 12. Create promotion_products table (junction table)
$sql_promotion_products = "CREATE TABLE IF NOT EXISTS promotion_products (
    promotion_product_id INT AUTO_INCREMENT PRIMARY KEY,
    promotion_id INT NOT NULL,
    p_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id) ON DELETE CASCADE,
    FOREIGN KEY (p_id) REFERENCES products(p_id) ON DELETE CASCADE,
    UNIQUE KEY unique_promotion_product (promotion_id, p_id)
)";

if ($conn->query($sql_promotion_products) === TRUE) {
    $tables_created[] = "promotion_products";
} else {
    $errors[] = "Promotion Products: " . $conn->error;
}

// 13. Create reviews table
$sql_reviews = "CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (p_id) REFERENCES products(p_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
)";

if ($conn->query($sql_reviews) === TRUE) {
    $tables_created[] = "reviews";
} else {
    $errors[] = "Reviews: " . $conn->error;
}

// 14. Create payment_transactions table
$sql_payments = "CREATE TABLE IF NOT EXISTS payment_transactions (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM('cash', 'card', 'mobile', 'online') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'completed',
    transaction_reference VARCHAR(255),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
)";

if ($conn->query($sql_payments) === TRUE) {
    $tables_created[] = "payment_transactions";
} else {
    $errors[] = "Payment Transactions: " . $conn->error;
}

// Insert sample data
$sample_data = [];

// Sample categories
$conn->query("INSERT IGNORE INTO categories (cat_id, cat_name, cat_description) VALUES 
    (1, 'Fruits', 'Fresh fruits and berries'),
    (2, 'Vegetables', 'Fresh vegetables and greens'),
    (3, 'Dairy', 'Milk, cheese, and dairy products'),
    (4, 'Beverages', 'Drinks and juices'),
    (5, 'Snacks', 'Chips, cookies, and snacks'),
    (6, 'Bakery', 'Bread, cakes, and pastries'),
    (7, 'Meat', 'Fresh meat and poultry'),
    (8, 'Frozen Foods', 'Frozen meals and ice cream')
");
$sample_data[] = "8 categories";

// Sample suppliers
$conn->query("INSERT IGNORE INTO suppliers (supplier_id, supplier_name, contact_person, phone, email, city, country) VALUES 
    (1, 'Fresh Farm Supplies', 'John Smith', '+1-555-0101', 'john@freshfarm.com', 'New York', 'USA'),
    (2, 'Dairy Delights Co.', 'Sarah Johnson', '+1-555-0102', 'sarah@dairydelights.com', 'Chicago', 'USA'),
    (3, 'Global Beverages Inc.', 'Mike Brown', '+1-555-0103', 'mike@globalbev.com', 'Los Angeles', 'USA'),
    (4, 'Snack Masters Ltd.', 'Emily Davis', '+1-555-0104', 'emily@snackmasters.com', 'Miami', 'USA')
");
$sample_data[] = "4 suppliers";

// Sample products
$conn->query("INSERT IGNORE INTO products (p_id, p_name, p_description, price, cost_price, stock, cat_id, supplier_id, barcode, sku, unit) VALUES 
    (1, 'Red Apples', 'Fresh red apples from local farms', 2.99, 1.50, 150, 1, 1, '1234567890001', 'FRT-APL-001', 'kg'),
    (2, 'Bananas', 'Ripe yellow bananas', 1.49, 0.80, 200, 1, 1, '1234567890002', 'FRT-BAN-001', 'kg'),
    (3, 'Whole Milk', 'Fresh whole milk 1 gallon', 3.99, 2.50, 80, 3, 2, '1234567890003', 'DRY-MLK-001', 'gallon'),
    (4, 'Orange Juice', 'Freshly squeezed orange juice', 4.99, 3.00, 60, 4, 3, '1234567890004', 'BEV-OJ-001', 'liter'),
    (5, 'Potato Chips', 'Crispy salted potato chips', 2.49, 1.20, 120, 5, 4, '1234567890005', 'SNK-CHP-001', 'pack'),
    (6, 'Carrots', 'Fresh organic carrots', 1.99, 1.00, 100, 2, 1, '1234567890006', 'VEG-CAR-001', 'kg'),
    (7, 'Cheddar Cheese', 'Aged cheddar cheese', 5.99, 3.50, 50, 3, 2, '1234567890007', 'DRY-CHE-001', 'pack'),
    (8, 'White Bread', 'Fresh white bread loaf', 2.99, 1.50, 90, 6, 1, '1234567890008', 'BAK-BRD-001', 'loaf'),
    (9, 'Chicken Breast', 'Fresh chicken breast', 7.99, 5.00, 40, 7, 1, '1234567890009', 'MET-CHK-001', 'kg'),
    (10, 'Ice Cream', 'Vanilla ice cream', 4.49, 2.50, 70, 8, 2, '1234567890010', 'FRZ-ICE-001', 'tub')
");
$sample_data[] = "10 products";

// Sample employees
$conn->query("INSERT IGNORE INTO employees (emp_id, emp_name, emp_role, emp_phone, emp_email, emp_salary, hire_date) VALUES 
    (1, 'Alice Johnson', 'Manager', '+1-555-1001', 'alice@grocery.com', 4500.00, '2023-01-15'),
    (2, 'Bob Williams', 'Cashier', '+1-555-1002', 'bob@grocery.com', 2500.00, '2023-03-20'),
    (3, 'Carol Martinez', 'Stock Clerk', '+1-555-1003', 'carol@grocery.com', 2200.00, '2023-05-10'),
    (4, 'David Lee', 'Cashier', '+1-555-1004', 'david@grocery.com', 2500.00, '2023-06-01')
");
$sample_data[] = "4 employees";

// Sample customers
$conn->query("INSERT IGNORE INTO customers (customer_id, customer_name, email, phone, address, city, postal_code, loyalty_points) VALUES 
    (1, 'Emma Thompson', 'emma@email.com', '+1-555-2001', '123 Main St', 'Springfield', '12345', 150),
    (2, 'James Wilson', 'james@email.com', '+1-555-2002', '456 Oak Ave', 'Springfield', '12346', 200),
    (3, 'Olivia Brown', 'olivia@email.com', '+1-555-2003', '789 Pine Rd', 'Springfield', '12347', 75),
    (4, 'William Davis', 'william@email.com', '+1-555-2004', '321 Elm St', 'Springfield', '12348', 300),
    (5, 'Sophia Garcia', 'sophia@email.com', '+1-555-2005', '654 Maple Dr', 'Springfield', '12349', 120)
");
$sample_data[] = "5 customers";

// Sample orders
$conn->query("INSERT IGNORE INTO orders (order_id, customer_id, emp_id, total_amount, discount_amount, tax_amount, final_amount, payment_method, order_status) VALUES 
    (1, 1, 2, 25.45, 2.00, 2.35, 25.80, 'card', 'completed'),
    (2, 2, 2, 45.90, 0.00, 4.13, 50.03, 'cash', 'completed'),
    (3, 3, 4, 15.75, 1.50, 1.43, 15.68, 'mobile', 'completed'),
    (4, 1, 2, 32.50, 3.00, 2.95, 32.45, 'card', 'completed'),
    (5, 4, 4, 78.25, 5.00, 7.33, 80.58, 'online', 'completed')
");
$sample_data[] = "5 orders";

// Sample order items
$conn->query("INSERT IGNORE INTO order_items (order_item_id, order_id, p_id, quantity, unit_price, subtotal) VALUES 
    (1, 1, 1, 2, 2.99, 5.98),
    (2, 1, 3, 1, 3.99, 3.99),
    (3, 1, 5, 3, 2.49, 7.47),
    (4, 2, 2, 5, 1.49, 7.45),
    (5, 2, 4, 2, 4.99, 9.98),
    (6, 2, 7, 3, 5.99, 17.97),
    (7, 3, 5, 4, 2.49, 9.96),
    (8, 3, 6, 2, 1.99, 3.98),
    (9, 4, 8, 3, 2.99, 8.97),
    (10, 4, 9, 2, 7.99, 15.98),
    (11, 5, 1, 5, 2.99, 14.95),
    (12, 5, 3, 3, 3.99, 11.97),
    (13, 5, 10, 4, 4.49, 17.96)
");
$sample_data[] = "13 order items";

// Sample cart
$conn->query("INSERT IGNORE INTO cart (cart_id, customer_id) VALUES 
    (1, 1),
    (2, 3),
    (3, 5)
");
$sample_data[] = "3 carts";

// Sample cart items
$conn->query("INSERT IGNORE INTO cart_items (cart_item_id, cart_id, p_id, quantity) VALUES 
    (1, 1, 2, 3),
    (2, 1, 4, 1),
    (3, 2, 5, 2),
    (4, 2, 8, 1),
    (5, 3, 1, 4),
    (6, 3, 6, 2)
");
$sample_data[] = "6 cart items";

// Sample promotions
$conn->query("INSERT IGNORE INTO promotions (promotion_id, promotion_name, description, discount_type, discount_value, start_date, end_date) VALUES 
    (1, 'Summer Sale', '20% off on all fruits', 'percentage', 20.00, '2026-06-01', '2026-08-31'),
    (2, 'Dairy Discount', '$2 off on dairy products', 'fixed', 2.00, '2026-01-01', '2026-12-31')
");
$sample_data[] = "2 promotions";

// Sample promotion products
$conn->query("INSERT IGNORE INTO promotion_products (promotion_product_id, promotion_id, p_id) VALUES 
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 3),
    (4, 2, 7)
");
$sample_data[] = "4 promotion products";

// Sample reviews
$conn->query("INSERT IGNORE INTO reviews (review_id, p_id, customer_id, rating, review_text) VALUES 
    (1, 1, 1, 5, 'Fresh and delicious apples!'),
    (2, 3, 2, 4, 'Good quality milk'),
    (3, 5, 3, 5, 'Best chips ever!'),
    (4, 9, 4, 4, 'Fresh chicken, good quality')
");
$sample_data[] = "4 reviews";

// Sample payment transactions
$conn->query("INSERT IGNORE INTO payment_transactions (payment_id, order_id, payment_method, amount, payment_status, transaction_reference) VALUES 
    (1, 1, 'card', 25.80, 'completed', 'TXN-001-2026'),
    (2, 2, 'cash', 50.03, 'completed', 'TXN-002-2026'),
    (3, 3, 'mobile', 15.68, 'completed', 'TXN-003-2026'),
    (4, 4, 'card', 32.45, 'completed', 'TXN-004-2026'),
    (5, 5, 'online', 80.58, 'completed', 'TXN-005-2026')
");
$sample_data[] = "5 payment transactions";

echo json_encode([
    "status" => "success",
    "message" => "Enhanced database created successfully!",
    "tables_created" => $tables_created,
    "total_tables" => count($tables_created),
    "sample_data" => $sample_data,
    "errors" => $errors,
    "database_structure" => [
        "core_tables" => ["categories", "products", "suppliers"],
        "people_tables" => ["customers", "employees"],
        "transaction_tables" => ["orders", "order_items", "payment_transactions"],
        "cart_tables" => ["cart", "cart_items"],
        "additional_tables" => ["inventory_transactions", "promotions", "promotion_products", "reviews"]
    ]
]);

$conn->close();
?>
