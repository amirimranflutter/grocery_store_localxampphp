<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once __DIR__ . '/../config/db_connection.php';

$conn = getDBConnection();

$data = json_decode(file_get_contents("php://input"), true);

$customer_id = isset($data['customer_id']) ? intval($data['customer_id']) : 0;
$p_id = isset($data['p_id']) ? intval($data['p_id']) : 0;
$quantity = isset($data['quantity']) ? intval($data['quantity']) : 1;

if ($customer_id == 0 || $p_id == 0) {
    echo json_encode(["status" => "error", "message" => "Customer ID and Product ID are required"]);
    exit;
}

// Check if cart exists for customer, if not create one
$cart_check = $conn->query("SELECT cart_id FROM cart WHERE customer_id = $customer_id");
if ($cart_check->num_rows == 0) {
    $conn->query("INSERT INTO cart (customer_id) VALUES ($customer_id)");
    $cart_id = $conn->insert_id;
} else {
    $cart_row = $cart_check->fetch_assoc();
    $cart_id = $cart_row['cart_id'];
}

// Check if product already in cart
$item_check = $conn->query("SELECT cart_item_id, quantity FROM cart_items WHERE cart_id = $cart_id AND p_id = $p_id");

if ($item_check->num_rows > 0) {
    // Update quantity
    $item_row = $item_check->fetch_assoc();
    $new_quantity = $item_row['quantity'] + $quantity;
    $sql = "UPDATE cart_items SET quantity = $new_quantity WHERE cart_id = $cart_id AND p_id = $p_id";
} else {
    // Insert new item
    $sql = "INSERT INTO cart_items (cart_id, p_id, quantity) VALUES ($cart_id, $p_id, $quantity)";
}

if ($conn->query($sql) === TRUE) {
    echo json_encode([
        "status" => "success",
        "message" => "Product added to cart successfully"
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to add to cart: " . $conn->error
    ]);
}

$conn->close();
?>
