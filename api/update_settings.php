<?php
require_once 'db.php';
$data = json_decode(file_get_contents("php://input"), true);

if (!empty($data['user_id']) && !empty($data['full_name']) && !empty($data['email'])) {
    $userId = $data['user_id'];
    $fullName = $data['full_name'];
    $email = $data['email'];

    if (!empty($data['new_password'])) {
        $newPasswordHash = password_hash($data['new_password'], PASSWORD_BCRYPT);
        $stmt = $conn->prepare("UPDATE users SET full_name = :name, email = :email, password_hash = :pass WHERE user_id = :id");
        $stmt->execute([':name' => $fullName, ':email' => $email, ':pass' => $newPasswordHash, ':id' => $userId]);
    } else {
        $stmt = $conn->prepare("UPDATE users SET full_name = :name, email = :email WHERE user_id = :id");
        $stmt->execute([':name' => $fullName, ':email' => $email, ':id' => $userId]);
    }

    echo json_encode(["status" => "success", "message" => "Settings updated successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
}
?>
