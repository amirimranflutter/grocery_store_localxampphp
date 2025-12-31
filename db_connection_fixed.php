<?php
// Database configuration
$servername = "localhost";
$username = "root";  // Your MySQL username
$password = "";      // Your MySQL password
$dbname = "grocery_store";  // Your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    // Log the error but don't expose it to the client
    error_log("Database connection failed: " . $conn->connect_error);
    
    // For API responses, we'll handle this in the calling script
    // Don't die() here as it will output HTML
}

// Set charset to prevent encoding issues
if ($conn && !$conn->connect_error) {
    $conn->set_charset("utf8");
}
?>