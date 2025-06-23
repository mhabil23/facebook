<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');

// Serve satu gambar berdasarkan ID via ?id=123
$mysqli = new mysqli('localhost', 'root', '', 'facebook');
if ($mysqli->connect_errno) {
    http_response_code(500);
    exit('DB connection failed');
}

$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
if ($id < 1) {
    http_response_code(400);
    exit('Invalid ID');
}

$stmt = $mysqli->prepare("SELECT mime_type, data FROM gambar WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->bind_result($mime, $data);

if ($stmt->fetch()) {
    header("Content-Type: $mime");
    echo $data;
} else {
    http_response_code(404);
    echo "Not found";
}

$stmt->close();
$mysqli->close();
