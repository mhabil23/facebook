<?php
// 1. Sesuaikan koneksi DB-mu:
$host = 'localhost';
$db   = 'facebook';    // ganti sesuai nama database
$user = 'root';
$pass = '';

// 2. Buat koneksi mysqli
$mysqli = new mysqli($host, $user, $pass, $db);
if ($mysqli->connect_errno) {
    die("Koneksi gagal: " . $mysqli->connect_error);
}

// 3. Tentukan folder 'image' satu level di atas lib/
$dir   = dirname(__DIR__) . '/image';
$files = glob($dir . '/*.{jpg,jpeg,png,gif}', GLOB_BRACE);

if (!$files) {
    die("Folder image kosong atau tidak ditemukan di: $dir\n");
}

// 4. Prepare statement
$stmt = $mysqli->prepare(
    "INSERT INTO gambar (filename, mime_type, data) VALUES (?, ?, ?)"
);
if (!$stmt) {
    die("Prepare failed: " . $mysqli->error);
}

// 5. Bind parameter (dua string + satu BLOB)
$name = $mime = null;
$null = null;  // placeholder untuk blob
$stmt->bind_param("ssb", $name, $mime, $null);

// 6. Loop dan kirim data
foreach ($files as $path) {
    $name = basename($path);
    $mime = mime_content_type($path) ?: 'application/octet-stream';

    // baca seluruh file sebagai binary
    $data = file_get_contents($path);
    if ($data === false) {
        echo "Gagal baca file $name, lewati.\n";
        continue;
    }

    // kirim data BLOB ke parameter ke-3
    $stmt->send_long_data(2, $data);

    // eksekusi
    if (! $stmt->execute()) {
        die("Execute failed ({$name}): " . $stmt->error . "\n");
    } else {
        echo "Imported: $name\n";
    }
}

echo "Selesai import " . count($files) . " file.\n";

// 7. Tutup statement & koneksi
$stmt->close();
$mysqli->close();
