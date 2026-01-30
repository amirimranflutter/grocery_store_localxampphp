<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once '../config/db_connection.php';

$conn = getDBConnection();

$active_only = isset($_GET['active_only']) ? $_GET['active_only'] == 'true' : false;

$where = "";
if ($active_only) {
    $where = "WHERE pr.is_active = TRUE AND CURDATE() BETWEEN pr.start_date AND pr.end_date";
}

$sql = "SELECT 
    pr.*,
    COUNT(pp.p_id) as product_count
FROM promotions pr
LEFT JOIN promotion_products pp ON pr.promotion_id = pp.promotion_id
$where
GROUP BY pr.promotion_id
ORDER BY pr.start_date DESC";

$result = $conn->query($sql);

$promotions = array();

if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        // Get products for this promotion
        $promo_id = $row['promotion_id'];
        $products_sql = "SELECT 
            p.p_id,
            p.p_name,
            p.price,
            c.cat_name
        FROM promotion_products pp
        INNER JOIN products p ON pp.p_id = p.p_id
        LEFT JOIN categories c ON p.cat_id = c.cat_id
        WHERE pp.promotion_id = $promo_id";
        
        $products_result = $conn->query($products_sql);
        $products = array();
        
        if ($products_result->num_rows > 0) {
            while($prod = $products_result->fetch_assoc()) {
                $products[] = $prod;
            }
        }
        
        $row['products'] = $products;
        $promotions[] = $row;
    }
}

echo json_encode([
    "status" => "success",
    "data" => $promotions,
    "count" => count($promotions)
]);

$conn->close();
?>
