<?php
require_once('connection.php');
$searchQuery = isset($_GET['searchQuery']) ? $_GET['searchQuery'] : '';

$sql = "SELECT * FROM tasks";
if (!empty($searchQuery)) {
    $sql .= " WHERE title LIKE '%" . $conn->real_escape_string($searchQuery) . "%'";
}
$result = $conn->query($sql);

$tasks = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }
}

echo json_encode($tasks);

$conn->close();
?>


<?php

