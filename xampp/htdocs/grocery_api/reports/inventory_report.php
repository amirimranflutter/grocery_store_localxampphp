<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once __DIR__ . '/../config/db_connection.php';

$conn = getDBConnection();

// Low stock products
$low_stock_sql = "SELECT 
    p.p_id,
    p.p_name,
    p.stock,
    p.min_stock_level,
    c.cat_name,
    s.supplier_name,
    s.phone as supplier_phone
FROM products p
LEFT JOIN categories c ON p.cat_id = c.cat_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.stock <= p.min_stock_level
AND p.is_active = TRUE
ORDER BY (p.stock - p.min_stock_level)";

$low_stock_result = $conn->query($low_stock_sql);
$low_stock = array();

if ($low_stock_result->num_rows > 0) {
    while($row = $low_stock_result->fetch_assoc()) {
        $low_stock[] = $row;
    }
}

// Inventory value by category
$value_sql = "SELECT 
    c.cat_name,
    COUNT(p.p_id) as product_count,
    SUM(p.stock) as total_units,
    SUM(p.stock * p.cost_price) as inventory_cost,
    SUM(p.stock * p.price) as inventory_value
FROM products p
LEFT JOIN categories c ON p.cat_id = c.cat_id
WHERE p.is_active = TRUE
GROUP BY c.cat_id
ORDER BY inventory_value DESC";

$value_result = $conn->query($value_sql);
$inventory_value = array();

if ($value_result->num_rows > 0) {
    while($row = $value_result->fetch_assoc()) {
        $inventory_value[] = $row;
    }
}

// Overall inventory stats
$stats_sql = "SELECT 
    COUNT(p_id) as total_products,
    SUM(stock) as total_units,
    SUM(stock * cost_price) as total_cost,
    SUM(stock * price) as total_value
FROM products
WHERE is_active = TRUE";

$stats_result = $conn->query($stats_sql);
$stats = $stats_result->fetch_assoc();

echo json_encode([
    "status" => "success",
    "overall_stats" => $stats,
    "low_stock_products" => $low_stock,
    "low_stock_count" => count($low_stock),
    "inventory_by_category" => $inventory_value
]);

$conn->close();
?>
