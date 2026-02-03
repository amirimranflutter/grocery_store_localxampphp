<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once __DIR__ . '/../config/db_connection.php';

$conn = getDBConnection();

$order_id = isset($_GET['order_id']) ? intval($_GET['order_id']) : 0;

if ($order_id == 0) {
    echo json_encode(["status" => "error", "message" => "Order ID is required"]);
    exit;
}

// Get order header
$order_sql = "SELECT 
    o.*,
    c.customer_name,
    c.email as customer_email,
    c.phone as customer_phone,
    e.emp_name as cashier_name
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN employees e ON o.emp_id = e.emp_id
WHERE o.order_id = $order_id";

$order_result = $conn->query($order_sql);

if ($order_result->num_rows == 0) {
    echo json_encode(["status" => "error", "message" => "Order not found"]);
    exit;
}

$order = $order_result->fetch_assoc();

// Get order items
$items_sql = "SELECT 
    oi.*,
    p.p_name,
    p.barcode,
    p.sku,
    c.cat_name
FROM order_items oi
INNER JOIN products p ON oi.p_id = p.p_id
LEFT JOIN categories c ON p.cat_id = c.cat_id
WHERE oi.order_id = $order_id";

$items_result = $conn->query($items_sql);
$items = array();

if ($items_result->num_rows > 0) {
    while($row = $items_result->fetch_assoc()) {
        $items[] = $row;
    }
}

$order['items'] = $items;

echo json_encode([
    "status" => "success",
    "data" => $order
]);

$conn->close();
?>
