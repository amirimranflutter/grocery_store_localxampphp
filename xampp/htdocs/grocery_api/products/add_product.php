<?php
include '../config/db_connection.php';

$name = $_POST['p_name'];
$price = $_POST['price'];
$stock = $_POST['stock'];
$quantity = $_POST['quantity'];
$cat_id = $_POST['cat_id'];
$date = $_POST['date_added'];

// Professional Tip: Use Prepared Statements to prevent SQL Injection
$stmt = $conn->prepare("INSERT INTO products (p_name, price, stock, cat_id,date_added) VALUES (?, ?, ?, ?)");
$stmt->bind_param("sddi", $name, $price, $stock, $cat_id,$date);

if($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>