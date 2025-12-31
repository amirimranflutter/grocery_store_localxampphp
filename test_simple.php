<?php
header("Content-Type: application/json; charset=UTF-8");

// Test basic PHP functionality
echo json_encode([
    "status" => "success",
    "message" => "PHP is working",
    "timestamp" => date('Y-m-d H:i:s')
]);
?>