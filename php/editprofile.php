<?php
error_reporting(0);
include_once("dbconnect.php");

$name = $_POST['name'];
$dob = $_POST['dob'];
$gender = $_POST['gender'];
$phone = $_POST['phone'];
$height = $_POST['height'];
$weight = $_POST['weight'];
$email = $_POST['email'];

$page1Edit = $_POST['page1Edit'];
$value = $_POST['value'];

$newEmail = $_POST['newEmail'];

$newPassword = sha1($_POST['newPassword']);

$sql;

if(isset($_POST['page1Edit'])){
    if($page1Edit == "0"){
        $sql = "UPDATE USER SET HEIGHT = '$value' WHERE EMAIL = '$email'"; 
    }else{
         $sql = "UPDATE USER SET WEIGHT = '$value' WHERE EMAIL = '$email'"; 
    }  
}else if(isset($_POST['newEmail'])){
    $sql = "UPDATE USER SET EMAIL = '$newEmail', VERIFY = '0' WHERE EMAIL = '$email'";    
}else if(isset($_POST['newPassword'])){
    $sql = "UPDATE USER SET PASSWORD = '$newPassword' WHERE EMAIL = '$email'";    
}else{
    $sql = "UPDATE USER SET NAME = COALESCE(NULLIF('$name', ''), NAME), DOB = COALESCE(NULLIF('$dob', ''), DOB), GENDER = COALESCE(NULLIF('$gender', ''), GENDER), PHONE = COALESCE(NULLIF('$phone', ''), PHONE), HEIGHT = COALESCE(NULLIF('$height', ''), HEIGHT), WEIGHT = COALESCE(NULLIF('$weight', ''), WEIGHT) WHERE EMAIL = '$email'";
}

if($conn->query($sql)){
    echo "success";
}else{
    echo "failed"; 
}
?>