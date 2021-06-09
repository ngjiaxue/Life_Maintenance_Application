<?php
error_reporting(0);
include_once("dbconnect.php");

$option = $_POST['option'];
$amount = $_POST['amount'];
$date = $_POST['date'];
$email = $_POST['email'];

$sql;

if($option == "food"){
    $sql = "UPDATE USERFOODLIST SET AMOUNT = '$amount' WHERE EMAIL = '$email' AND DATE = '$date'";
}else{
    $sql = "UPDATE USEREXERCISELIST SET AMOUNT = '$amount' WHERE EMAIL = '$email' AND DATE = '$date'";
}

if($conn->query($sql)){
    echo "success";
}else{
    echo "failed"; 
}
?>