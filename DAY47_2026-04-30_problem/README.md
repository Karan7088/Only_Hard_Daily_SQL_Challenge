🔥 Day 46 — Extreme Hard SQL Challenge
Sessionization + Funnel Analysis
🧠 Problem Statement

You are given an event log capturing user interactions with a product.

Each record represents a user action performed at a specific timestamp.

Your task is to:

Identify user sessions using time gaps
Track funnel progression within each session
Classify each session based on funnel completion
📦 Table Schema
DROP TABLE IF EXISTS events;

CREATE TABLE events (
    user_id INT,
    event_time TIMESTAMP,
    event_type VARCHAR(50)
);
💣 Test Data
INSERT INTO events VALUES
-- User 1 (perfect funnel)
(1, '2024-01-01 10:00:00', 'login'),
(1, '2024-01-01 10:05:00', 'view_product'),
(1, '2024-01-01 10:07:00', 'add_to_cart'),
(1, '2024-01-01 10:10:00', 'purchase'),

-- User 1 (new session fail)
(1, '2024-01-01 11:00:00', 'login'),
(1, '2024-01-01 11:10:00', 'view_product'),

-- User 2 (valid ordered funnel)
(2, '2024-01-01 09:00:00', 'login'),
(2, '2024-01-01 09:05:00', 'view_product'),
(2, '2024-01-01 09:10:00', 'add_to_cart'),
(2, '2024-01-01 09:40:00', 'purchase'),

-- User 3 (skipped steps)
(3, '2024-01-01 12:00:00', 'login'),
(3, '2024-01-01 12:02:00', 'purchase'),

-- User 4 (multiple sessions)
(4, '2024-01-01 08:00:00', 'login'),
(4, '2024-01-01 08:05:00', 'view_product'),
(4, '2024-01-01 08:06:00', 'add_to_cart'),
(4, '2024-01-01 08:10:00', 'purchase'),

(4, '2024-01-01 09:00:00', 'login'),
(4, '2024-01-01 09:50:00', 'view_product'),

-- User 5 (noise + duplicates)
(5, '2024-01-01 07:00:00', 'login'),
(5, '2024-01-01 07:01:00', 'login'),
(5, '2024-01-01 07:05:00', 'view_product'),
(5, '2024-01-01 07:06:00', 'view_product'),
(5, '2024-01-01 07:10:00', 'add_to_cart'),
(5, '2024-01-01 07:20:00', 'purchase');
⚙️ Requirements
1. Sessionization
Assign session_id per user

A new session starts when:

time difference between consecutive events > 30 minutes
2. Funnel Definition

Track funnel steps in order:

login → view_product → add_to_cart → purchase
3. Rules to Follow
Events must follow strict order
Ignore duplicate / repeated events
Only consider first valid occurrence of each step
Steps must occur sequentially (no skipping allowed)
4. Funnel Classification

For each (user_id, session_id):

Status	Condition
FULL_CONVERSION	All steps completed in correct order
PARTIAL	Funnel started (login exists) but not completed
NO_CONVERSION	Funnel not properly started or invalid order
✅ Expected Output
user_id | session_id | funnel_status
------------------------------------
1       | 1          | FULL_CONVERSION
1       | 2          | PARTIAL

2       | 1          | FULL_CONVERSION

3       | 1          | NO_CONVERSION

4       | 1          | FULL_CONVERSION
4       | 2          | PARTIAL
4       | 3          | NO_CONVERSION

5       | 1          | FULL_CONVERSION
🧠 Key Concepts Tested
Gap-based sessionization
Window functions (LAG, ROW_NUMBER)
Event sequencing
Funnel analytics
Handling noisy / duplicate logs
💀 Why This Problem is Hard
Requires combining time-based logic + sequence validation
Needs careful handling of duplicates and missing steps
Tests real-world user behavior modeling 
