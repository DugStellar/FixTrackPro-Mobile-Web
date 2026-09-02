<?php
require_once 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!empty($data['full_name']) && !empty($data['email'])) {
    // 1. Check or Insert User
    $stmt = $conn->prepare("SELECT user_id FROM users WHERE email = :email");
    $stmt->execute([':email' => $data['email']]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        $stmt = $conn->prepare("INSERT INTO users (full_name, email, phone_number, role) VALUES (:name, :email, :phone, 'Guest')");
        $stmt->execute([
            ':name' => $data['full_name'],
            ':email' => $data['email'],
            ':phone' => $data['phone_number'] ?? null
        ]);
        $user_id = $conn->lastInsertId();
    } else {
        $user_id = $user['user_id'];
    }

    // 2. Record RSVP if attending status provided
    if (isset($data['attending_status'])) {
        $stmt = $conn->prepare("INSERT INTO rsvps (user_id, attending_status) VALUES (:user_id, :status)");
        $stmt->execute([
            ':user_id' => $user_id,
            ':status' => $data['attending_status']
        ]);
    }

    echo json_encode(["status" => "success", "message" => "Record processed successfully."]);
} else {
    echo json_encode(["status" => "error", "message" => "Incomplete data provided."]);
}
?>
