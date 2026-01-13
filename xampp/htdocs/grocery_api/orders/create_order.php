<?php
include '../config/db_connection.php';

// Get JSON data from Flutter
$data = json_decode(file_get_contents('php://input'), true);
$cart = $data['cart'];
$total = $data['total'];

// 1. Insert into 'orders' table
$stmt = $conn->prepare("INSERT INTO orders (total_price) VALUES (?)");
$stmt->bind_param("d", $total);
$stmt->execute();
$order_id = $conn->insert_id;

// 2. Loop through cart and insert items
foreach ($cart as $item) {
    $p_id = $item['id'];
    $qty = $item['qty'];
    $price = $item['price'];

    // Insert Order Detail
    $stmtDetail = $conn->prepare("INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)");
    $stmtDetail->bind_param("iiid", $order_id, $p_id, $qty, $price);
    $stmtDetail->execute();

    // 3. Subtract Stock from 'products' table
    $stmtUpdate = $conn->prepare("UPDATE products SET stock = stock - ? WHERE p_id = ?");
    $stmtUpdate->bind_param("ii", $qty, $p_id);
    $stmtUpdate->execute();
}

echo json_encode(["status" => "success"]);
?>