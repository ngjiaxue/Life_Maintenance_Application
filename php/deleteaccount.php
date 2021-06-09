<?php
error_reporting(0);
include_once ("dbconnect.php");

$email = $_POST['email'];

$sql = "DELETE FROM USER WHERE EMAIL = '$email'";

if ($conn->query($sql) && unlink('../images/'.$email.'.jpg')){
    echo "success";
}else{
    echo "failed";
}
?>