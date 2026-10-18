
<?php

require_once __DIR__ . '/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        "status" => "error",
        "message" => "Use POST to submit information."
    ]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);

if (!is_array($data)) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "Invalid JSON data."
    ]);
    exit;
}

$name = trim($data['full_name'] ?? '');
$email = trim($data['email'] ?? '');
$phone = trim($data['phone_number'] ?? '');
$attending = $data['attending_status'] ?? null;

if ($name === '' || strlen($name) > 100 ||
    !filter_var($email, FILTER_VALIDATE_EMAIL) ||
    strlen($email) > 100) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "Enter a valid name and email address."
    ]);
    exit;
}

if (strlen($phone) > 20) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "Phone number is too long."
    ]);
    exit;
}

if ($attending !== null &&
    !in_array($attending, ['Yes', 'No'], true)) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "Attendance must be Yes or No."
    ]);
    exit;
}

try {
    $conn->beginTransaction();

    $stmt = $conn->prepare(
        "SELECT user_id FROM users WHERE email = :email"
    );
    $stmt->execute(['email' => $email]);
    $user = $stmt->fetch();

    if ($user) {
        $userId = $user['user_id'];

        if ($phone !== '') {
            $stmt = $conn->prepare(
                "UPDATE users
                 SET full_name = :name, phone_number = :phone
                 WHERE user_id = :id"
            );
            $stmt->execute([
                'name' => $name,
                'phone' => $phone,
                'id' => $userId
            ]);
        }
    } else {
        $stmt = $conn->prepare(
            "INSERT INTO users
                (full_name, email, phone_number, role)
             VALUES (:name, :email, :phone, 'Guest')"
        );
        $stmt->execute([
            'name' => $name,
            'email' => $email,
            'phone' => $phone !== '' ? $phone : null
        ]);

        $userId = $conn->lastInsertId();
    }

    if ($attending !== null) {
        $stmt = $conn->prepare(
            "INSERT INTO rsvps (user_id, attending_status)
             VALUES (:user_id, :status)"
        );
        $stmt->execute([
            'user_id' => $userId,
            'status' => $attending
        ]);
    }

    $conn->commit();

    echo json_encode([
        "status" => "success",
        "message" => $attending !== null
            ? "RSVP submitted successfully."
            : "Registration completed successfully."
    ]);

} catch (Throwable $e) {
    if ($conn->inTransaction()) {
        $conn->rollBack();
    }

    error_log($e->getMessage());
    http_response_code(500);

    echo json_encode([
        "status" => "error",
        "message" => "Could not process the submission."
    ]);
}
