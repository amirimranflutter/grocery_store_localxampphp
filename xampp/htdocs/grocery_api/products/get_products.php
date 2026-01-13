<?php
require_once '../config/db_connection.php';
ob_clean();

// 1. Updated SQL to include 'stock' and 'date' which you used below
// Also used 'p_id' and 'p_name' assuming those are your actual DB column names
$sql = "SELECT p.p_id, p.p_name, p.price, p.stock, p.date, p.cat_id, c.cat_name 
        FROM products p 
        LEFT JOIN categories c ON p.cat_id = c.cat_id
        ORDER BY p.p_id DESC";
$result = $conn->query($sql);

$products = array();

if ($result) {
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
    echo json_encode($products);
} else {
    echo json_encode(["error" => $conn->error]); 
}

$conn->close();
?>