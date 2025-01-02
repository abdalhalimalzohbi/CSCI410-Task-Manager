<?php
include 'connection.php';

$id = $_POST['id'];
$status = $_POST['status'];

$sql = "UPDATE tasks SET status='$status' WHERE id='$id'";

if ($conn->query($sql) === TRUE) {
    echo "Task status updated successfully";
} else {
    echo "Error updating task status: " . $conn->error;
}

$conn->close();
?>