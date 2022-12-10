<?php
$servername = "localhost";
$username = "admin";
$password = "098iop";

print("Connect to server {$servername}, user {$username}, password {$password}\n<br>");
$conn = new mysqli($servername, $username, $password);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

print("Connected successfully\n<br>");
?>