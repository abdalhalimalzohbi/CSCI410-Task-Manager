<?php
require_once('connection.php');

$title = $_POST['title'];
$description = $_POST['description'];
$status = $_POST['status'];

if ($title && $description && $status) {
    $sql = "INSERT INTO tasks (title, description, status) VALUES ('$title', '$description', '$status')";
    $result = mysqli_query($conn, $sql);
    if ($result) {
        echo "Data Inserted Successfully";
    }
    exit();
}

$conn->close();
