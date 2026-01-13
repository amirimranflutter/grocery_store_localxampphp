<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

try {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "grocerystore";
    
    $conn = new mysqli($servername, $username, $password, $dbname);
    
    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => "Database connection failed"
        ]);
        exit;
    }
    
    $conn->set_charset("utf8");
    
    $sql = "SELECT emp_id, emp_name, emp_salary FROM employees ORDER BY emp_id DESC";
    $result = $conn->query($sql);
    
    if (!$result) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => "Query failed: " . $conn->error
        ]);
        exit;
    }
    
    $employees = [];
    while($row = $result->fetch_assoc()) {
        $employees[] = [
            "emp_id" => (int)$row['emp_id'],
            "emp_name" => $row['emp_name'],
            "emp_salary" => (float)$row['emp_salary']
        ];
    }
    
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
