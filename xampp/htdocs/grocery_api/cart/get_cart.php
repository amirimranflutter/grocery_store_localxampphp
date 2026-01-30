<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once '../config/db_connection.php';

$conn = getDBConnection();

$customer_id = isset($_GET['customer_id']) ? intval($_GET['customer_id']) : 0;

if ($customer_id == 0) {
    echo json_encode(["status" => "error", "message" => "Customer ID is required"]);
    exit;
}

$sql = "SELECT 
    ci.cart_item_id,
    ci.cart_id,
    ci.quantity,
    p.p_id,
    p.p_name,
    p.p_description,
    p.price,
    p.stock,
    p.barcode,
    c.cat_name,
    (ci.quantity * p.price) as subtotal
FROM cart_items ci
INNER JOIN cart ct ON ci.cart_id = ct.cart_id
INNER JOIN products p ON ci.p_id = p.p_id
LEFT JOIN categories c ON p.cat_id = c.cat_id
WHERE ct.customer_id = $customer_id
ORDER BY ci.added_at DESC";

$result = $conn->query($sql);

$cart_items = array();
$total = 0;

if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $cart_items[] = $row;
        $total += $row['subtotal'];
    }
}

echo json_encode([
    "status" => "success",
    "data" => $cart_items,
    "count" => count($cart_items),
    "total_amount" => round($total, 2)
]);

$conn->close();
?>
