<?php
// Test all endpoints to ensure they work

echo "Testing Grocery API Endpoints\n";
echo "================================\n\n";

$base_url = "http://localhost/grocery_api";

function testEndpoint($name, $url) {
    echo "Testing: $name\n";
    echo "URL: $url\n";
    
    $response = @file_get_contents($url);
    
    if ($response === false) {
        echo "❌ FAILED - Could not connect\n\n";
        return false;
    }
    
    $json = json_decode($response, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        echo "❌ FAILED - Invalid JSON\n";
        echo "Response: " . substr($response, 0, 200) . "...\n\n";
        return false;
    }
    
    echo "✓ SUCCESS\n";
    echo "Status: " . ($json['status'] ?? 'N/A') . "\n\n";
    return true;
}

// Test endpoints
testEndpoint("Get Products", "$base_url/products/get_products.php");
testEndpoint("Get Categories", "$base_url/products/get_categories.php");
testEndpoint("Get Customers", "$base_url/customers/get_customers.php");
testEndpoint("Get Orders", "$base_url/orders/get_orders.php");
testEndpoint("Get Employees", "$base_url/staff/get_employee.php");
testEndpoint("Sales Summary", "$base_url/reports/sales_summary.php");
testEndpoint("Inventory Report", "$base_url/reports/inventory_report.php");
testEndpoint("Get Suppliers", "$base_url/suppliers/get_suppliers.php");

echo "\nTest Complete!\n";
?>
