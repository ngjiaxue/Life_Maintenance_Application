<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqladmin = "SELECT * FROM USER WHERE EMAIL = '$email' AND PASSWORD = '$password' AND ADMIN = '1' AND VERIFY = '1'";
$sqluser = "SELECT * FROM USER WHERE EMAIL = '$email' AND PASSWORD = '$password' AND ADMIN = '0' AND VERIFY = '1'";
$sqluserwrongpasswordonly = "SELECT * FROM USER WHERE EMAIL = '$email' AND ADMIN = '0' AND VERIFY = '1'";
$sqlnoverify = "SELECT * FROM USER WHERE EMAIL = '$email' AND PASSWORD = '$password' AND ADMIN = '0' AND VERIFY = '0'";

$resultadmin = $conn->query($sqladmin);
$resultuser = $conn->query($sqluser);
$resultuserwrongpasswordonly = $conn->query($sqluserwrongpasswordonly);
$resultnoverify = $conn->query($sqlnoverify);

if ($resultadmin->num_rows === 1) {
    while ($row = $resultadmin ->fetch_assoc()){
        echo "success admin&".$row["NAME"]."&".$row["DOB"]."&".$row["GENDER"]."&".$row["EMAIL"]."&".$row["PHONE"]."&".$row["HEIGHT"]."&".$row["WEIGHT"];
    }
}else if($resultuser->num_rows === 1){
    while ($row = $resultuser ->fetch_assoc()){
        echo "success&".$row["NAME"]."&".$row["DOB"]."&".$row["GENDER"]."&".$row["EMAIL"]."&".$row["PHONE"]."&".$row["HEIGHT"]."&".$row["WEIGHT"];
    }
}else if($resultuserwrongpasswordonly->num_rows === 1){
    echo "incorrect password";
}else if($resultnoverify->num_rows === 1){
    echo "no verify success";
}else{
    echo "failed";
}
?>