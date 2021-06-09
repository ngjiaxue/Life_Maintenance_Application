<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$id = $_POST['id'];
$amount = $_POST['amount'];
$option = $_POST['option'];
$date = date("Y-m-d H:i:s");

$sql;

if($option == "food"){
    $sql = "INSERT INTO USERFOODLIST(EMAIL,ID,AMOUNT,DATE) VALUES ('$email','$id','$amount','$date')";
}else if($option == "exercise"){
    $sql = "INSERT INTO USEREXERCISELIST(EMAIL,ID,AMOUNT,DATE) VALUES ('$email','$id','$amount','$date')";
}

if ($conn->query($sql)){
    echo "success";
}else{
    echo "failed";
}
?>