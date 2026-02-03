<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once __DIR__ . '/../config/db_connection.php';

$conn = getDBConnection();

$sql = "SELECT 
    c.*,
    COUNT(DISTINCT o.order_id) as total_orders,
    COALESCE(SUM(o.final_amount), 0) as lifetime_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.is_active = TRUE
GROUP BY c.customer_id
ORDER BY c.customer_name";

$result = $conn->query($sql);

$customers = array();

if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $customers[] = $row;
    }
    echo json_encode([
        "status" => "success",
        "data" => $customers,
        "count" => count($customers)
    ]);
} else {
    echo json_encode([
        "status" => "success",
        "data" => [],
        "count" => 0,
        "message" => "No customers found"
    ]);
}

$conn->close();
?>
