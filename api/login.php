<?php
require_once 'db.php';
$data = json_decode(file_get_contents("php://input"), true);

if (!empty($data['email']) && !empty($data['password'])) {
    $email = $data['email'];
    $password = $data['password'];

    $stmt = $conn->prepare("SELECT user_id, full_name, email, password_hash, role FROM users WHERE email = :email");
    $stmt->execute([':email' => $email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($password, $user['password_hash'])) {
        unset($user['password_hash']); // Do not expose password hash in API response
        echo json_encode([
            "status" => "success",
            "message" => "Login successful",
            "user" => $user
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Invalid email or password"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Email and password are required"
    ]);
}
?>
