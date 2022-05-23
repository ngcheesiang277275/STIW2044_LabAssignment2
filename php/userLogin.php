<?php 
  // $con=mysqli_connect('localhost','root','','mytutor_db');
  // $json = file_get_contents('php://input');
  // $obj = json_decode($json,true);
  // if(isset($obj["user_email"]) || isset($obj["user_password"])){
    
  //   $email = mysqli_real_escape_string($con,$obj['user_email']);
  //   $pwd = mysqli_real_escape_string($con,$obj['user_password']);
    
  //   $result=[];
    
  //   $sql="SELECT * FROM tbl_userinfo WHERE user_email='{$email}' and user_email='{$pwd}'";
  //   $res=$con->query($sql);
    
  //   if($res->num_rows>0){
  //     $row=$res->fetch_assoc();
  //     $result['loginStatus']=true;
  //     $result['message']="Login Successfully";
  //     $result["userInfo"]=$row;
  //   }else{
  //     $result['loginStatus']=false;
  //     $result['message']="Invalid Login Details";
  //   }
  //   $json_data=json_encode($result);
  //   echo $json_data;
  // }


if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM `tbl_users` WHERE user_email = '$email' AND user_password = '$password'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;

if ($numrow > 0) {
    while ($row = $result->fetch_assoc()) {
        $user['email'] = $row['user_email'];
        $user['password'] = $row['user_password'];
        $user['name'] = $row['user_name'];
        $user['phoneNum'] = $row['user_phoneNumber'];
        $user['address'] = $row['user_homeAddress'];
    }
    $response = array('status' => 'success', 'data' => $user);
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


