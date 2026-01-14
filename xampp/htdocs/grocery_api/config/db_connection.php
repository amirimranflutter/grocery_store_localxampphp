<?php
// C:\xampp\htdocs\grocery_api\config\db_connection.php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$user = "root";
$pass = "";
$db   = "grocerystore";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed"]));
}
// NOTHING ELSE GOES HERE. NO IF STATEMENTS, NO ECHOS.
?>