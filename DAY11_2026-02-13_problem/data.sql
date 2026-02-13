/* ===============================
   INSERT USERS
================================ */

INSERT INTO users VALUES
(1, '2024-12-10'),
(2, '2025-01-05'),
(3, '2025-02-01'),
(4, '2025-03-01'),
(5, '2025-01-15'),
(6, '2024-11-20'),
(7, '2025-02-10'),
(8, '2025-01-01'),
(9, '2025-03-15'),
(10,'2024-10-01');


/* ===============================
   INSERT SUBSCRIPTIONS
================================ */

INSERT INTO subscriptions VALUES

-- User 1: stable subscription
(101, 1, '2025-01-01', NULL, 100.00),

-- User 2: upgrade later
(102, 2, '2025-01-10', NULL, 100.00),

-- User 3: churn mid month
(103, 3, '2025-02-01', '2025-03-15', 200.00),

-- User 4: downgrade then upgrade same month
(104, 4, '2025-03-01', NULL, 300.00),

-- User 5: starts & churns same month
(105, 5, '2025-01-20', '2025-01-25', 250.00),

-- User 6: overlapping subscriptions
(106, 6, '2025-01-01', '2025-06-30', 120.00),
(107, 6, '2025-03-01', NULL, 180.00),

-- User 7: churn then rejoin
(108, 7, '2025-02-15', '2025-04-01', 220.00),
(109, 7, '2025-06-01', NULL, 300.00),

-- User 8: pause simulation (price becomes 0)
(110, 8, '2025-01-01', NULL, 500.00),

-- User 9: same day subscription
(111, 9, '2025-03-20', '2025-03-20', 400.00),

-- User 10: back-to-back subscriptions
(112, 10, '2025-01-01', '2025-02-28', 150.00),
(113, 10, '2025-03-01', NULL, 250.00);


/* ===============================
   INSERT PLAN CHANGES
================================ */

INSERT INTO plan_changes VALUES

-- User 2 upgrade
(1, 102, '2025-02-15', 150.00),

-- User 4 downgrade then upgrade
(2, 104, '2025-03-10', 200.00),
(3, 104, '2025-03-20', 400.00),

-- Duplicate same day change (dirty data)
(4, 104, '2025-03-20', 400.00),

-- Backdated change before subscription start (dirty)
(5, 102, '2024-12-01', 120.00),

-- Plan change after churn (invalid but realistic dirty data)
(6, 103, '2025-04-01', 300.00),

-- User 6 upgrade mid overlap
(7, 106, '2025-04-01', 200.00),

-- User 7 downgrade before churn
(8, 108, '2025-03-15', 100.00),

-- User 8 pause (price = 0)
(9, 110, '2025-02-01', 0.00),

-- User 8 resume
(10,110, '2025-03-01', 500.00),

-- User 10 upgrade second subscription
(11,113, '2025-04-15', 350.00);

