<?php
error_reporting(0);
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

// Create categories table
$sql_categories = "CREATE TABLE IF NOT EXISTS categories (
    cat_id INT AUTO_INCREMENT PRIMARY KEY,
    cat_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($sql_categories) !== TRUE) {
    echo json_encode(["error" => "Error creating categories table: " . $conn->error]);
    exit;
}

// Create products table
$sql_products = "CREATE TABLE IF NOT EXISTS products (
    p_id INT AUTO_INCREMENT PRIMARY KEY,
    p_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    date DATE,
    cat_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cat_id) REFERENCES categories(cat_id)
)";

if ($conn->query($sql_products) !== TRUE) {
    echo json_encode(["error" => "Error creating products table: " . $conn->error]);
    exit;
}

// Create employees table
$sql_employees = "CREATE TABLE IF NOT EXISTS employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(255) NOT NULL,
    emp_role VARCHAR(100),
    emp_phone VARCHAR(20),
    emp_salary DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($sql_employees) !== TRUE) {
    echo json_encode(["error" => "Error creating employees table: " . $conn->error]);
    exit;
}

// Create orders table
$sql_orders = "CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($sql_orders) !== TRUE) {
    echo json_encode(["error" => "Error creating orders table: " . $conn->error]);
    exit;
}

// Insert sample categories
$conn->query("INSERT IGNORE INTO categories (cat_id, cat_name) VALUES 
    (1, 'Fruits'),
    (2, 'Vegetables'),
    (3, 'Dairy'),
    (4, 'Beverages'),
    (5, 'Snacks')
");

// Insert sample products
$conn->query("INSERT IGNORE INTO products (p_id, p_name, price, stock, date, cat_id) VALUES 
    (1, 'Apple', 2.99, 50, CURDATE(), 1),
    (2, 'Banana', 1.49, 75, CURDATE(), 1),
    (3, 'Milk', 3.99, 30, CURDATE(), 3),
    (4, 'Orange Juice', 4.99, 25, CURDATE(), 4),
    (5, 'Potato Chips', 2.49, 40, CURDATE(), 5)
");

echo json_encode([
    "status" => "success",
    "message" => "Database and tables created successfully!",
    "tables_created" => ["categories", "products", "employees", "orders"],
    "sample_data" => "Added 5 categories and 5 products"
]);

$conn->close();
?>
