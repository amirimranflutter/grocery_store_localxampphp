<?php
require_once '../config/db_connection.php';
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $p_id = $_POST['p_id'] ?? null;

    if (!$p_id) {
        http_response_code(400);
        echo json_encode(["error" => "Product ID is required"]);
        exit;
    }

    $stmt = $conn->prepare("DELETE FROM products WHERE p_id = ?");
    $stmt->bind_param("i", $p_id);

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            echo json_encode(["success" => true, "message" => "Product deleted"]);
        } else {
            http_response_code(404);
            echo json_encode(["error" => "Product not found"]);
        }
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to delete product: " . $stmt->error]);
    }

    $stmt->close();
} else {
    http_response_code(405);
    echo json_encode(["error" => "Method not allowed"]);
}

$conn->close();
?>
