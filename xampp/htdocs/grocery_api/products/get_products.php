<?php
require_once '../config/db_connection.php';
ob_clean();

// 1. Updated SQL to include 'stock' and 'date' which you used below
// Also used 'p_id' and 'p_name' assuming those are your actual DB column names
$sql = "SELECT p_id, p_name, price, stock, date, cat_id FROM products";
$result = $conn->query($sql);

$products = array();

if ($result) {
    while($row = $result->fetch_assoc()) {
        $products[] = array(
            "p_id"   => (int)$row['p_id'],
            "p_name" => $row['p_name'],
            "price"  => (int)$row['price'],
            "stock"  => (int)$row['stock'],
            "date"   => $row['date'],
            "cat_id" => (int)$row['cat_id']
        );
    }
    header("Content-Type: application/json");
    echo json_encode($products);
} else {
    header("Content-Type: application/json");
    echo json_encode(["error" => $conn->error]); 
}

$conn->close();
?>