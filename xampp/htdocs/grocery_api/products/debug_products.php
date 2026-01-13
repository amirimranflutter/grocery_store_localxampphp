<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$user = "root";
$pass = "";
$db   = "grocerystore";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit;
}

// Check if products table exists and get its structure
$result = $conn->query("DESCRIBE products");

if ($result) {
    $columns = [];
    while ($row = $result->fetch_assoc()) {
        $columns[] = $row;
    }
    echo json_encode([
        "status" => "success",
        "table" => "products",
        "columns" => $columns
    ]);
} else {
    // Table doesn't exist - let's check what tables exist
    $tables_result = $conn->query("SHOW TABLES");
    $tables = [];
    while ($row = $tables_result->fetch_array()) {
        $tables[] = $row[0];
    }
    echo json_encode([
        "status" => "table_not_found",
        "available_tables" => $tables,
        "error" => $conn->error
    ]);
}

$conn->close();
?>
