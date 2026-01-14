<?php
// Clear everything to ensure a clean JSON response
ob_start();
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
error_reporting(0); 
ini_set('display_errors', 0);

// 1. Connection settings (Hardcoded here to fix the "No ID" ghost)
$host = "localhost";
$user = "root";
$pass = "";
$db   = "grocerystore";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

// 2. The Query
$sql = "SELECT cat_id, cat_name FROM categories";
$result = $conn->query($sql);

$categories = array();

if ($result) {
    while($row = $result->fetch_assoc()) {
        $categories[] = array(
            "cat_id" => (int)$row['cat_id'],
            "cat_name" => $row['cat_name']
        );
    }
    ob_clean(); // Kill any "No ID" text that might have leaked in
    echo json_encode($categories);
} else {
    echo json_encode([]);
}

$conn->close();
exit();
?>