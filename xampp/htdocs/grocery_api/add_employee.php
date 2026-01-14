<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
echo json_encode($employees);
$host = "localhost";
$user = "root";
$pass = "";
$db   = "grocerystore";

$conn = new mysqli($host, $user, $pass, $db);

// Get the data sent from your Flutter app
// Note: We use the same keys you defined in Flutter: "empName" and "empSalary"
$name   = $_POST['empName'];
$salary = $_POST['empSalary'];

// We don't include empid here because it's Auto-Increment
$sql = "INSERT INTO employee (empName, empSalary) VALUES ('$name', '$salary')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "Added successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}

$conn->close();
?>