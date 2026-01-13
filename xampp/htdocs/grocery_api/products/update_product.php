<?php
include '../config/db_connection.php';

$id = $_POST['p_id'];
$price = $_POST['price'];
$stock = $_POST['stock'];

$sql = "UPDATE products SET price = ?, stock = ? WHERE p_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ddi", $price, $stock, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>