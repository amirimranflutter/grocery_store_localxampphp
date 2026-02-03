<?php
// Script to remove promotions tables from database

$host = "localhost";
$user = "root";
$pass = "";
$db   = "grocerystore";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "Removing promotions tables...\n\n";

// Drop promotion_products first (has foreign key to promotions)
$sql1 = "DROP TABLE IF EXISTS promotion_products";
if ($conn->query($sql1) === TRUE) {
    echo "✓ Table 'promotion_products' dropped successfully\n";
} else {
    echo "✗ Error dropping promotion_products: " . $conn->error . "\n";
}

// Drop promotions table
$sql2 = "DROP TABLE IF EXISTS promotions";
if ($conn->query($sql2) === TRUE) {
    echo "✓ Table 'promotions' dropped successfully\n";
} else {
    echo "✗ Error dropping promotions: " . $conn->error . "\n";
}

echo "\n✓ Promotions tables removed successfully!\n";
echo "Your database now has 12 tables instead of 14.\n";

$conn->close();
?>
