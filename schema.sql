CREATE DATABASE IF NOT EXISTS fixtrack_db;
USE fixtrack_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Guest') DEFAULT 'Guest',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. RSVPs Table
CREATE TABLE IF NOT EXISTS rsvps (
    rsvp_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    attending_status ENUM('Yes', 'No') NOT NULL,
    dietary_notes VARCHAR(255) DEFAULT 'None',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    broadcast_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Raffle Entries Table
CREATE TABLE IF NOT EXISTS raffle_entries (
    raffle_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    is_winner BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- SEED DATA (Minimum 10 records per table)

-- Seed Users (Passwords hashed using bcrypt for 'Password123!')
INSERT INTO users (full_name, email, password_hash, role) VALUES
('Devon Adams', 'devon@capeit.co.za', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Admin'),
('Keeyan Bowman', 'keeyan@capeit.co.za', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Admin'),
('Tristan Booysen', 'tristan@capeit.co.za', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Admin'),
('John Doe', 'john.doe@gmail.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Guest'),
('Jane Smith', 'jane.smith@yahoo.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Guest'),
('Michael Brown', 'mbrown@outlook.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Guest'),
('Sarah Connor', 'sconnor@cyberdyne.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Guest'),
('Bruce Wayne', 'bruce@wayneent.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Guest'),
('Clark Kent', 'ckent@dailyplanet.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Guest'),
('Peter Parker', 'pparker@dailybugle.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe11yR4N32f3A881g9N13d2S15tP6u57a', 'Guest');

-- Seed RSVPs (10 Records)
INSERT INTO rsvps (user_id, attending_status, dietary_notes) VALUES
(1, 'Yes', 'None'), (2, 'Yes', 'Vegetarian'), (3, 'Yes', 'None'),
(4, 'Yes', 'Halal'), (5, 'No', 'N/A'), (6, 'Yes', 'Gluten Free'),
(7, 'Yes', 'None'), (8, 'No', 'N/A'), (9, 'Yes', 'None'), (10, 'Yes', 'None');

-- Seed Notifications (10 Records)
INSERT INTO notifications (title, message) VALUES
('Welcome to FixTrack Pro', 'Event repair tracking portal is now live.'),
('Session 1 Scheduled', 'Hardware diagnostic overview starts at 10:00 AM.'),
('Keynote Address', 'Cape IT Assist Director welcome address at 11:00 AM.'),
('Lunch Break', 'Catering available in the main hall.'),
('Software Patching Workshop', 'Hands-on malware recovery session starting at 01:30 PM.'),
('Raffle Drawing Notice', 'Live raffle draw scheduled for 03:00 PM on stage.'),
('Network Security Q&A', 'Join our cybersecurity team at Booth B.'),
('Component Replacement Update', 'GPU repair station open for inquiries.'),
('Closing Ceremony', 'Wrap-up and prize distributions at 04:30 PM.'),
('Event Feedback Form', 'Please complete the feedback survey in the mobile app.');

-- Seed Raffle Entries (10 Records)
INSERT INTO raffle_entries (user_id, ticket_number, is_winner) VALUES
(1, 'TICK-1001', FALSE), (2, 'TICK-1002', FALSE), (3, 'TICK-1003', FALSE),
(4, 'TICK-1004', FALSE), (5, 'TICK-1005', FALSE), (6, 'TICK-1006', FALSE),
(7, 'TICK-1007', FALSE), (8, 'TICK-1008', FALSE), (9, 'TICK-1009', FALSE),
(10, 'TICK-1010', FALSE);
