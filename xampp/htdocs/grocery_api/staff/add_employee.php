<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$user = "root";
$pass = "";
$db   = "grocerystore";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Connection failed"]);
    exit;
}

$name   = $_POST['empName'];
$salary = $_POST['empSalary'];

$stmt = $conn->prepare("INSERT INTO employees (emp_name, emp_salary) VALUES (?, ?)");
$stmt->bind_param("sd", $name, $salary);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Added successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}

$conn->close();
?>