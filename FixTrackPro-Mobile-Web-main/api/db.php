
<?php

header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$db_name = "fixtrack_db";
$username = "root";
$password = "";

try {
    $conn = new PDO(
        "mysql:host=$host;dbname=$db_name;charset=utf8mb4",
        $username,
        $password,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false
        ]
    );
} catch (PDOException $e) {
    error_log($e->getMessage());
    http_response_code(500);

    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed."
    ]);
    exit;
}
