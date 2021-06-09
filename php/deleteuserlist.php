<?php
error_reporting(0);
include_once("dbconnect.php");

$option = $_POST['option'];
$amount = $_POST['amount'];
$date = $_POST['date'];
$email = $_POST['email'];

$sql;

if($option == "food"){
    $sql = "DELETE FROM USERFOODLIST WHERE AMOUNT = '$amount' AND EMAIL = '$email' AND DATE = '$date'";
}else{
    $sql = "DELETE FROM USEREXERCISELIST WHERE AMOUNT = '$amount' AND EMAIL = '$email' AND DATE = '$date'";
}

if($conn->query($sql)){
    echo "success";
}else{
    echo "failed"; 
}
?>