<?php
// Simple database setup script
// Run this once to create the database and tables

$host = "localhost";
$user = "root";
$pass = "";

// Connect without database first
$conn = new mysqli($host, $user, $pass);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Read the SQL file
$sql_file = __DIR__ . '/grocery_store_schema.sql';
$sql = file_get_contents($sql_file);

if ($sql === false) {
    die("Error reading SQL file");
}

// Execute multi-query
if ($conn->multi_query($sql)) {
    echo "Database setup started...\n";
    
    // Process all results
    do {
        if ($result = $conn->store_result()) {
            $result->free();
        }
    } while ($conn->next_result());
    
    echo "✓ Database 'grocerystore' created successfully!\n";
    echo "✓ All tables created successfully!\n";
    echo "✓ Sample data inserted successfully!\n";
    echo "\nYou can now use the API. Close this window and restart your Flutter app.";
} else {
    echo "Error executing SQL: " . $conn->error;
}

$conn->close();
?>
