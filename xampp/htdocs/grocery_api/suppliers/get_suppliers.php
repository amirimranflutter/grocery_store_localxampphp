<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once '../config/db_connection.php';

$conn = getDBConnection();

$sql = "SELECT 
    s.*,
    COUNT(p.p_id) as total_products
FROM suppliers s
LEFT JOIN products p ON s.supplier_id = p.supplier_id
WHERE s.is_active = TRUE
GROUP BY s.supplier_id
ORDER BY s.supplier_name";

$result = $conn->query($sql);

$suppliers = array();

if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $suppliers[] = $row;
    }
}

echo json_encode([
    "status" => "success",
    "data" => $suppliers,
    "count" => count($suppliers)
]);

$conn->close();
?>
