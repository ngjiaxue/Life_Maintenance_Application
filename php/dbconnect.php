<?php
$servername = "localhost";
$username 	= "id15869591_lifemaintenanceapplication";
$password 	= "kADQH#6Nj*i-h8u%";
$dbname 	= "id15869591_life_maintenance_application";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>