<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once __DIR__ . '/../config/db_connection.php';

$conn = getDBConnection();

$customer_id = isset($_GET['customer_id']) ? intval($_GET['customer_id']) : 0;
$limit = isset($_GET['limit']) ? intval($_GET['limit']) : 50;

$where = "";
if ($customer_id > 0) {
    $where = "WHERE o.customer_id = $customer_id";
}

$sql = "SELECT 
    o.*,
    c.customer_name,
    e.emp_name as cashier_name,
    COUNT(oi.order_item_id) as total_items
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN employees e ON o.emp_id = e.emp_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
$where
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT $limit";

$result = $conn->query($sql);

$orders = array();

if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $orders[] = $row;
    }
}

echo json_encode([
    "status" => "success",
    "data" => $orders,
    "count" => count($orders)
]);

$conn->close();
?>
