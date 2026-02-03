<?php
error_reporting(E_ALL);
ini_set('display_errors', 0); // Don't display errors in output

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$diagnostics = [];

// Test 1: Database connection
try {
    $conn = new mysqli("localhost", "root", "", "grocerystore");
    if ($conn->connect_error) {
        $diagnostics['database'] = "FAILED: " . $conn->connect_error;
    } else {
        $diagnostics['database'] = "OK";
        
        // Test 2: Check tables
        $tables = ['products', 'customers', 'employees', 'orders', 'categories'];
        foreach ($tables as $table) {
            $result = $conn->query("SELECT COUNT(*) as count FROM $table");
            if ($result) {
                $row = $result->fetch_assoc();
                $diagnostics['tables'][$table] = $row['count'] . " records";
            } else {
                $diagnostics['tables'][$table] = "ERROR: " . $conn->error;
            }
        }
        $conn->close();
    }
} catch (Exception $e) {
    $diagnostics['database'] = "EXCEPTION: " . $e->getMessage();
}

// Test 3: PHP version
$diagnostics['php_version'] = phpversion();

// Test 4: Required extensions
$diagnostics['mysqli_loaded'] = extension_loaded('mysqli') ? 'YES' : 'NO';
$diagnostics['json_loaded'] = extension_loaded('json') ? 'YES' : 'NO';

echo json_encode([
    'status' => 'success',
    'diagnostics' => $diagnostics
], JSON_PRETTY_PRINT);
?>
