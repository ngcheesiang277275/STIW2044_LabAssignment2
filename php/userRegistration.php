<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['email'];
$name = $_POST['name'];
$phoneNumber = $_POST['phoneNum'];
$password = sha1($_POST['password']);
$address = $_POST['address'];
$base64image = $_POST['image'];

$sqlinsert = "INSERT INTO `tbl_users`(`user_email`, `user_name`, `user_phoneNumber`, `user_password`, `user_homeAddress`)
VALUES ('$email','$name ','$phoneNumber','$password ','$address')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../images/' . $filename . '.jpg';
    $is_written = file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


?>