<?php
$conn = new mysqli('localhost', 'root', '', 'grocerystore');

if ($conn->connect_error) {
    echo "Failed: " . $conn->connect_error . "\n";
} else {
    echo "Success! Database connected.\n";
    $result = $conn->query('SELECT COUNT(*) as count FROM products');
    $row = $result->fetch_assoc();
    echo "Products in database: " . $row['count'] . "\n";
}

$conn->close();
?>
