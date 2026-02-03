<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once __DIR__ . '/../config/db_connection.php';

$conn = getDBConnection();

$start_date = isset($_GET['start_date']) ? $_GET['start_date'] : date('Y-m-01');
$end_date = isset($_GET['end_date']) ? $_GET['end_date'] : date('Y-m-d');

// Overall summary
$summary_sql = "SELECT 
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    SUM(o.final_amount) as total_revenue,
    AVG(o.final_amount) as average_order_value,
    SUM(oi.quantity) as total_items_sold
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE DATE(o.order_date) BETWEEN '$start_date' AND '$end_date'
AND o.order_status = 'completed'";

$summary_result = $conn->query($summary_sql);
$summary = $summary_result->fetch_assoc();

// Top selling products
$top_products_sql = "SELECT 
    p.p_id,
    p.p_name,
    c.cat_name,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.subtotal) as total_revenue
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.p_id = p.p_id
LEFT JOIN categories c ON p.cat_id = c.cat_id
WHERE DATE(o.order_date) BETWEEN '$start_date' AND '$end_date'
AND o.order_status = 'completed'
GROUP BY p.p_id
ORDER BY total_quantity DESC
LIMIT 10";

$top_products_result = $conn->query($top_products_sql);
$top_products = array();

if ($top_products_result->num_rows > 0) {
    while($row = $top_products_result->fetch_assoc()) {
        $top_products[] = $row;
    }
}

// Sales by category
$category_sql = "SELECT 
    c.cat_name,
    COUNT(DISTINCT oi.order_id) as orders_count,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.subtotal) as total_revenue
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.p_id = p.p_id
LEFT JOIN categories c ON p.cat_id = c.cat_id
WHERE DATE(o.order_date) BETWEEN '$start_date' AND '$end_date'
AND o.order_status = 'completed'
GROUP BY c.cat_id
ORDER BY total_revenue DESC";

$category_result = $conn->query($category_sql);
$categories = array();

if ($category_result->num_rows > 0) {
    while($row = $category_result->fetch_assoc()) {
        $categories[] = $row;
    }
}

// Daily sales trend
$daily_sql = "SELECT 
    DATE(order_date) as sale_date,
    COUNT(order_id) as orders_count,
    SUM(final_amount) as daily_revenue
FROM orders
WHERE DATE(order_date) BETWEEN '$start_date' AND '$end_date'
AND order_status = 'completed'
GROUP BY DATE(order_date)
ORDER BY sale_date";

$daily_result = $conn->query($daily_sql);
$daily_sales = array();

if ($daily_result->num_rows > 0) {
    while($row = $daily_result->fetch_assoc()) {
        $daily_sales[] = $row;
    }
}

echo json_encode([
    "status" => "success",
    "period" => [
        "start_date" => $start_date,
        "end_date" => $end_date
    ],
    "summary" => $summary,
    "top_products" => $top_products,
    "sales_by_category" => $categories,
    "daily_sales" => $daily_sales
]);

$conn->close();
?>
