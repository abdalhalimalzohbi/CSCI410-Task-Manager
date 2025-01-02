<?php
$conn = mysqli_connect("localhost","root","","tasks_db");
if($conn->connect_error){ die("Error in connection". $conn->connect_error);}
