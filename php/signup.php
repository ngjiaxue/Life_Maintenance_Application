<?php
error_reporting(0);
include_once ("dbconnect.php");

$name = $_POST['name'];
$dob = $_POST['dob'];
$gender = $_POST['gender'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sql = "INSERT INTO USER(NAME,DOB,GENDER,EMAIL,PHONE,PASSWORD) VALUES ('$name','$dob','$gender','$email','$phone','$password')";

if ($conn->query($sql)){
    sendEmail($email);
    echo "success";
}else{
    echo "failed";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = "Verification for Life Maintenance Application";
    $message = "http://lifemaintenanceapplication.000webhostapp.com/php/verify.php?email=.'$email'."; 
    $headers = "From: noreply@life_maintenance_application.com"; 
    
    mail($to, $subject, $message, $headers); 
}
?>