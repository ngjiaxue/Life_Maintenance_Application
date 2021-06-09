<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$weight = $_POST['weight'];
$option = $_POST['option'];

$sql;

if($option == "food"){
    $sql = "SELECT FOODLIST.NAME,FOODLIST.CALORIES,FOODLIST.IMAGE_SOURCE,USERFOODLIST.AMOUNT,USERFOODLIST.DATE FROM USERFOODLIST LEFT JOIN FOODLIST ON USERFOODLIST.ID = FOODLIST.ID WHERE USERFOODLIST.EMAIL = '$email' ORDER BY USERFOODLIST.DATE DESC";
}else if($option == "exercise"){
    $sql = "SELECT EXERCISELIST.NAME,EXERCISELIST.CALORIES,EXERCISELIST.IMAGE_SOURCE,USEREXERCISELIST.AMOUNT,USEREXERCISELIST.DATE FROM USEREXERCISELIST LEFT JOIN EXERCISELIST ON USEREXERCISELIST.ID = EXERCISELIST.ID WHERE USEREXERCISELIST.EMAIL = '$email' ORDER BY USEREXERCISELIST.DATE DESC";
}

$result = $conn->query($sql);

if ($result->num_rows > 0) {
     $response = array();
    while($row = $result -> fetch_assoc()){
        $list = array();
        $list[name] = $row["NAME"]; 
        $list[calories] = $row["CALORIES"];
        $list[imagesource] = $row["IMAGE_SOURCE"];
        $list[amount] = $row["AMOUNT"];
        $list[date] = $row["DATE"];
        if($option == "food"){
            $list[totalcalories] = number_format((float)$row["CALORIES"] / 100 * $row["AMOUNT"], 1, '.', '');
        }else{
            $list[totalcalories] = number_format((float)$row["CALORIES"] / 30 / 125 * $weight * 2.2046 * $row["AMOUNT"], 1, '.', '');
        }
        array_push($response, $list);  
    }
    echo json_encode($response);
}else if($result->num_rows === 0){
    echo "connected but no data";
}else{
    echo "no data";
}
?>