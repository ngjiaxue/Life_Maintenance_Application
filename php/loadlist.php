<?php
error_reporting(0);
include_once("dbconnect.php");

$option = $_POST['option'];

$sql;

if($option == "food"){
    $sql = "SELECT ID, NAME FROM FOODLIST WHERE VERIFY = 1 ORDER BY NAME ASC";
}else if($option == "exercise"){
    $sql = "SELECT ID, NAME FROM EXERCISELIST WHERE VERIFY = 1 ORDER BY NAME ASC";
}

$result = $conn->query($sql);

if ($result->num_rows > 0) {
     $response = array();
    while($row = $result -> fetch_assoc()){
        $list = array();
        $list[id] = $row["ID"]; 
        $list[name] = $row["NAME"];
        array_push($response, $list);  
    }
    echo json_encode($response);
}else{
    echo "no data";
}
?>