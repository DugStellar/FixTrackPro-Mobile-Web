<?php
require_once 'db.php';

// Select random eligible guest entry from raffle table
$stmt = $conn->prepare("SELECT r.raffle_id, r.ticket_number, u.full_name, u.email 
                        FROM raffle_entries r 
                        JOIN users u ON r.user_id = u.user_id 
                        WHERE r.is_winner = FALSE 
                        ORDER BY RAND() LIMIT 1");
$stmt->execute();
$winner = $stmt->fetch(PDO::FETCH_ASSOC);

if ($winner) {
    // Flag entry as winner
    $update = $conn->prepare("UPDATE raffle_entries SET is_winner = TRUE WHERE raffle_id = :id");
    $update->execute([':id' => $winner['raffle_id']]);

    echo json_encode(["status" => "success", "winner" => $winner]);
} else {
    echo json_encode(["status" => "error", "message" => "No eligible tickets found."]);
}
?>
