<?php
// Suppress all error output to prevent HTML contamination
error_reporting(0);
ini_set('display_errors', 0);

// Set proper headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

try {
    // Database connection parameters
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "grocery_store";
    
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
    
    // Execute query - adjust table/column names to match your database
    $sql = "SELECT empid, empName, empSalary FROM employees";
    $result = $conn->query($sql);
    
    if (!$result) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => "Query failed: " . $conn->error
        ]);
        exit;
    }
    
    // Fetch results
    $employees = [];
    while($row = $result->fetch_assoc()) {
        $employees[] = [
            "empid" => $row['empid'],
            "empName" => $row['empName'],
            "empSalary" => $row['empSalary']
        ];
    }
    
    // Return as JSON array (not wrapped in status object since your Flutter code expects a direct array)
    echo json_encode($employees);
    
    $conn->close();
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Server error"
    ]);
}
?>
