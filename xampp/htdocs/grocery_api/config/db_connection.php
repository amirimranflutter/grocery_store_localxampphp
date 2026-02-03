<?php
// C:\xampp\htdocs\grocery_api\config\db_connection.php

function getDBConnection() {
    $host = "localhost";
    $user = "root";
    $pass = "";
    $db   = "grocerystore";

    $conn = new mysqli($host, $user, $pass, $db);

    if ($conn->connect_error) {
        http_response_code(500);
        die(json_encode(["status" => "error", "message" => "Database connection failed"]));
    }
    
    return $conn;
}

// For backward compatibility - create global connection
$host = "localhost";
$user = "root";
$pass = "";
$db   = "grocerystore";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    http_response_code(500);
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}
?>