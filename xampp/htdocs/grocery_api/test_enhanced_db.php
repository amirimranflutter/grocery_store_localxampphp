<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once 'config/db_connection.php';

$conn = getDBConnection();

// Test all tables exist
$tables = [
    'categories', 'suppliers', 'products', 'employees', 'customers',
    'orders', 'order_items', 'cart', 'cart_items', 'inventory_transactions',
    'promotions', 'promotion_products', 'reviews', 'payment_transactions'
];

$results = [];

foreach ($tables as $table) {
    $sql = "SELECT COUNT(*) as count FROM $table";
    $result = $conn->query($sql);
    if ($result) {
        $row = $result->fetch_assoc();
        $results[$table] = [
            'exists' => true,
            'record_count' => $row['count']
        ];
    } else {
        $results[$table] = [
            'exists' => false,
            'error' => $conn->error
        ];
    }
}

// Test a complex join query
$complex_query = "SELECT 
    o.order_id,
    c.customer_name,
    e.emp_name as cashier,
    COUNT(oi.order_item_id) as items,
    o.final_amount
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN employees e ON o.emp_id = e.emp_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
LIMIT 5";

$complex_result = $conn->query($complex_query);
$sample_orders = [];

if ($complex_result && $complex_result->num_rows > 0) {
    while($row = $complex_result->fetch_assoc()) {
        $sample_orders[] = $row;
    }
}

// Get relationship info
$relationships_query = "SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'grocerystore'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME";

$rel_result = $conn->query($relationships_query);
$relationships = [];

if ($rel_result && $rel_result->num_rows > 0) {
    while($row = $rel_result->fetch_assoc()) {
        $relationships[] = $row;
    }
}

echo json_encode([
    "status" => "success",
    "message" => "Enhanced database test completed",
    "tables" => $results,
    "total_tables" => count($tables),
    "total_relationships" => count($relationships),
    "relationships" => $relationships,
    "sample_orders" => $sample_orders,
    "test_timestamp" => date('Y-m-d H:i:s')
], JSON_PRETTY_PRINT);

$conn->close();
?>
