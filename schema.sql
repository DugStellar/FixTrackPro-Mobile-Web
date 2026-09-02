-- FixTrack Pro Database Schema
-- Client: Cape IT Assist
-- Developed by Cybertech Solutions

CREATE DATABASE IF NOT EXISTS fixtrack_db;
USE fixtrack_db;

-- Table 1: System Users (Admins and Guests)
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    role ENUM('Admin', 'Guest') DEFAULT 'Guest',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: Event RSVPs
CREATE TABLE IF NOT EXISTS rsvps (
    rsvp_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    attending_status ENUM('Yes', 'No') NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table 3: Announcement / Notification Feed
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    broadcast_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 4: Raffle Entries & Winners
CREATE TABLE IF NOT EXISTS raffle_entries (
    raffle_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    is_winner BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table 5: Admin Event Trackers (Beer Counter / Repair Tracker)
CREATE TABLE IF NOT EXISTS event_counters (
    counter_id INT AUTO_INCREMENT PRIMARY KEY,
    counter_name VARCHAR(50) NOT NULL,
    current_count INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert Initial Seed Data for Testing
INSERT INTO users (full_name, email, phone_number, role) VALUES 
('Admin User', 'admin@capeitassist.co.za', '0820000000', 'Admin'),
('John Doe', 'john@example.com', '0821234567', 'Guest');

INSERT INTO event_counters (counter_name, current_count) VALUES 
('Beer Counter', 0),
('Repairs Completed', 0);
