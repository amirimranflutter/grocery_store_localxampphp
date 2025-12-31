<?php
// Suppress all error output to prevent HTML contamination
error_reporting(0);
ini_set('display_errors', 0);

// Set proper headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

try {
    // Database connection parameters - UPDATE THESE TO MATCH YOUR SETUP
    $servername = "localhost";
    $username = "root";
    $password = "";  // Your MySQL password
    $dbname = "grocery_store";  // Your actual database name
    
    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    
    // Check connection
    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => "Database connection failed"
        ]);
        exit;
    }
    
    // Set charset
    $conn->set_charset("utf8");
    
    // Execute query
    $sql = "SELECT cat_id, cat_name FROM categories";
    $result = $conn->query($sql);
    
    if (!$result) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => "Query failed"
        ]);
        exit;
    }
    
    // Fetch results
    $categories = [];
    while($row = $result->fetch_assoc()) {
        $categories[] = [
            "cat_id" => (int)$row['cat_id'],
            "cat_name" => $row['cat_name']
        ];
    }
    
    // Return success response
    echo json_encode([
        "status" => "success",
        "data" => $categories
    ]);
    
    $conn->close();
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Server error"
    ]);
}
?>