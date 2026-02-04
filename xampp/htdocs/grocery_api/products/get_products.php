<?php
error_reporting(0);
ini_set('display_errors', 0);

// Handle CORS for web browsers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/../config/db_connection.php';

$sql = "SELECT p.p_id, p.p_name, p.price, p.stock, p.date, p.cat_id, c.cat_name 
        FROM products p 
        LEFT JOIN categories c ON p.cat_id = c.cat_id
        WHERE p.is_active = TRUE
        ORDER BY p.p_id DESC";

$result = $conn->query($sql);

$products = array();

if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $products[] = array(
            "p_id"     => (int)$row['p_id'],
            "p_name"   => $row['p_name'],
            "price"    => (float)$row['price'],
            "stock"    => (int)$row['stock'],
            "date"     => $row['date'],
            "cat_id"   => (int)$row['cat_id'],
            "cat_name" => $row['cat_name'] ?? "Uncategorized"
        );
    }
}

echo json_encode($products);
$conn->close();
?>