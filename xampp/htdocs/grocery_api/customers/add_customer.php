<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once '../config/db_connection.php';

$conn = getDBConnection();

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['customer_name']) || empty($data['customer_name'])) {
    echo json_encode(["status" => "error", "message" => "Customer name is required"]);
    exit;
}

$customer_name = $conn->real_escape_string($data['customer_name']);
$email = isset($data['email']) ? $conn->real_escape_string($data['email']) : null;
$phone = isset($data['phone']) ? $conn->real_escape_string($data['phone']) : null;
$address = isset($data['address']) ? $conn->real_escape_string($data['address']) : null;
$city = isset($data['city']) ? $conn->real_escape_string($data['city']) : null;
$postal_code = isset($data['postal_code']) ? $conn->real_escape_string($data['postal_code']) : null;

$sql = "INSERT INTO customers (customer_name, email, phone, address, city, postal_code) 
        VALUES ('$customer_name', " . ($email ? "'$email'" : "NULL") . ", " . 
        ($phone ? "'$phone'" : "NULL") . ", " . ($address ? "'$address'" : "NULL") . ", " . 
        ($city ? "'$city'" : "NULL") . ", " . ($postal_code ? "'$postal_code'" : "NULL") . ")";

if ($conn->query($sql) === TRUE) {
    echo json_encode([
        "status" => "success",
        "message" => "Customer added successfully",
        "customer_id" => $conn->insert_id
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to add customer: " . $conn->error
    ]);
}

$conn->close();
?>
