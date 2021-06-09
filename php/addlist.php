<?php
error_reporting(0);
include_once("dbconnect.php");

$option = $_POST['option'];
$name = $_POST['name'];
$calories = $_POST['calories'];
$imagesource = $_POST['imagesource'];
$verify = $_POST['verify'];

$sql;

if($option == "food"){
    $sql = "INSERT INTO FOODLIST(NAME,CALORIES,IMAGE_SOURCE,VERIFY) VALUES ('$name','$calories','$imagesource','$verify')";
}else if($option == "exercise"){
    $sql = "INSERT INTO EXERCISELIST(NAME,CALORIES,IMAGE_SOURCE,VERIFY) VALUES ('$name','$calories','$imagesource','$verify')";
}

if ($conn->query($sql)){
    echo "success";
}else{
    echo "failed";
    echo $sql;
}
?>