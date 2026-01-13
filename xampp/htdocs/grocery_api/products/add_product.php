<?php
include '../config/db_connection.php';

$name = $_POST['p_name'];
$price = $_POST['price'];
$stock = $_POST['stock'];
$cat_id = $_POST['cat_id'];
$date = $_POST['date'];

$stmt = $conn->prepare("INSERT INTO products (p_name, price, stock, cat_id, date) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("sdsis", $name, $price, $stock, $cat_id, $date);

if($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>