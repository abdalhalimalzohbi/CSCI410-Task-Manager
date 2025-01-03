<?php
require_once('connection.php');

$id = $_POST['id'];

if ($id) {
    $sql = "DELETE FROM tasks WHERE id = '$id'";
    $result = mysqli_query($conn, $sql);
    if ($result) {
        echo "Task Deleted Successfully";
    } else {
        echo "Error Deleting Task: " . mysqli_error($conn);
    }
    exit();
}

$conn->close();
?>