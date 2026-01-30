<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once '../config/db_connection.php';

$conn = getDBConnection();

$data = json_decode(file_get_contents("php://input"), true);

$cart_item_id = isset($data['cart_item_id']) ? intval($data['cart_item_id']) : 0;

if ($cart_item_id == 0) {
    echo json_encode(["status" => "error", "message" => "Cart item ID is required"]);
    exit;
}

$sql = "DELETE FROM cart_items WHERE cart_item_id = $cart_item_id";

if ($conn->query($sql) === TRUE) {
    echo json_encode([
        "status" => "success",
        "message" => "Item removed from cart successfully"
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to remove item: " . $conn->error
    ]);
}

$conn->close();
?>
