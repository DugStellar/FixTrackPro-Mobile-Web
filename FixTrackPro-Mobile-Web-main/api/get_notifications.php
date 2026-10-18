
<?php

require_once __DIR__ . '/db.php';

try {
    $stmt = $conn->query(
        "SELECT notification_id, title, message, broadcast_date
         FROM notifications
         ORDER BY broadcast_date DESC
         LIMIT 50"
    );

    $notifications = $stmt->fetchAll();

    echo json_encode([
        "status" => "success",
        "count" => count($notifications),
        "notifications" => $notifications
    ]);

} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);

    echo json_encode([
        "status" => "error",
        "message" => "Could not retrieve notifications."
    ]);
}
