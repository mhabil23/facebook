<?php
header('Content-Type: application/json');

$mysqli = new mysqli('localhost', 'root', '', 'facebook');
if ($mysqli->connect_errno) {
    http_response_code(500);
    echo json_encode(['error' => 'DB connection failed']);
    exit;
}

$sql = "SELECT id, filename FROM gambar ORDER BY uploaded_at DESC";
if (!($res = $mysqli->query($sql))) {
    http_response_code(500);
    echo json_encode(['error' => 'Query failed']);
    exit;
}

$out = [];
while ($row = $res->fetch_assoc()) {
    $out[] = [
        'id'       => (int)$row['id'],
        'filename' => $row['filename'],
    ];
}

echo json_encode($out);
$mysqli->close();
