<?php
$servername = "localhost";
$username = "admin";
$password = "098iop";
$dbname = "test1"; 

$conn_string = "host={$servername} port=5432 dbname={$dbname} user={$username} password={$password}";
print("{$conn_string}<br>");
$conn = pg_connect($conn_string);

if ($conn) {
    print("Connected successfully<br>");
}else{
    $error = error_get_last();
    die("Connection failed " . $error['message']);
}

?>