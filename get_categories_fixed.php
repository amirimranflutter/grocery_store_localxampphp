<?php
// Suppress error output to prevent HTML in JSON responses
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

try {
    require_once '../config/db_connection.php';
    
    // Check if database connection exists
    if (!isset($conn) || $conn->connect_error) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => "Database connection failed"
        ]);
        exit;
    }
    
    $sql = "SELECT cat_id, cat_name FROM categories";
    $result = $conn->query($sql);
    
    if (!$result) {
        http_response_code(500);
        echo json_encode([
            "status" => "error", 
            "message" => "Query execution failed"
        ]);
        exit;
    }
    
    $categories = [];
    while($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }
    
    // Return success response
    echo json_encode([
        "status" => "success",
        "data" => $categories
    ]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Server error occurred"
    ]);
}
?>