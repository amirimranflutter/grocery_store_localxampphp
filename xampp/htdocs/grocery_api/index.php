<?php
header('Content-Type: application/json');

$response = [
    'status' => 'success',
    'message' => 'Grocery API is running',
    'version' => '1.0',
    'endpoints' => [
        'products' => '/grocery_api/products/',
        'orders' => '/grocery_api/orders/',
        'staff' => '/grocery_api/staff/',
        'config' => '/grocery_api/config/'
    ]
];

echo json_encode($response, JSON_PRETTY_PRINT);
?>
