<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_GET['email'];

$sql = "UPDATE USER SET VERIFIED = '1' WHERE EMAIL = '$email'";

if ($conn->query($sql)) {
    echo '<html>
            <style>
            body {
                background-image: url("https://parceldaddy2020.000webhostapp.com/images/background.jpg");
                background-repeat: no-repeat;
                background-attachment: fixed;
                background-size: cover;
            }
            </style>
            <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
            <h1 style="text-align:center;
                color:white;
                font-family:verdana;
                font-size:500%;
                -webkit-text-stroke-width: 2px;
                -webkit-text-stroke-color: black;">
                Verification success, you may now login to the app</h1>
        </html>';
} else {
    echo "Verify error, please contact the admin for futher information https://api.whatsapp.com/send?phone=60178441087";
}

$conn->close();
?>