<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
error_reporting(0);

$host = "localhost";
$user = "root";
$pass = "";
$db   = "grocerystore";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

if (isset($_POST['empid'])) {
    $id = $_POST['empid'];

    $stmt = $conn->prepare("DELETE FROM employees WHERE emp_id = ?");
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "No ID provided"]);
}

$conn->close();
?>