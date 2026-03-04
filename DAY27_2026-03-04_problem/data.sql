INSERT INTO orders VALUES
-- ----------------------------------------------------------
-- USER 1: Perfect retained (within 3 days)
(1,  1, 'T1001', '2026-01-01 10:00:00', 'completed', 100.00, 'ios', 'India'),
(2,  1, 'T1002', '2026-01-03 09:00:00', 'completed', 150.00, 'ios', 'India'),

-- ----------------------------------------------------------
-- USER 2: Second order exactly 7 days (edge valid)
(3,  2, 'T2001', '2026-01-05 12:00:00', 'completed', 200.00, 'android', 'USA'),
(4,  2, 'T2002', '2026-01-12 12:00:00', 'completed', 250.00, 'android', 'USA'),

-- ----------------------------------------------------------
-- USER 3: Second order after 8 days (not retained)
(5,  3, 'T3001', '2026-01-01 08:00:00', 'completed', 120.00, 'web', 'UK'),
(6,  3, 'T3002', '2026-01-09 08:01:00', 'completed', 130.00, 'web', 'UK'),

-- ----------------------------------------------------------
-- USER 4: Has cancelled first, real first is later
(7,  4, 'T4001', '2026-01-01 10:00:00', 'cancelled', 300.00, 'ios', 'India'),
(8,  4, 'T4002', '2026-01-02 10:00:00', 'completed', 350.00, 'ios', 'India'),
(9,  4, 'T4003', '2026-01-05 10:00:00', 'completed', 400.00, 'ios', 'India'),

-- ----------------------------------------------------------
-- USER 5: Second order refunded (should ignore)
(10, 5, 'T5001', '2026-01-01 11:00:00', 'completed', 500.00, 'web', 'Canada'),
(11, 5, 'T5002', '2026-01-03 11:00:00', 'refunded', 600.00, 'web', 'Canada'),
(12, 5, 'T5003', '2026-01-06 11:00:00', 'completed', 700.00, 'web', 'Canada'),

-- ----------------------------------------------------------
-- USER 6: Same timestamp duplicate transaction (trap)
(13, 6, 'T6001', '2026-01-01 09:00:00', 'completed', 100.00, 'ios', 'India'),
(14, 6, 'T6001_DUP', '2026-01-01 09:00:00', 'completed', 100.00, 'ios', 'India'),
(15, 6, 'T6002', '2026-01-04 09:00:00', 'completed', 200.00, 'ios', 'India'),

-- ----------------------------------------------------------
-- USER 7: Only one completed order
(16, 7, 'T7001', '2026-01-01 10:00:00', 'completed', 90.00, 'android', 'Germany'),

-- ----------------------------------------------------------
-- USER 8: Third order within 7 days but second outside (logic trap)
(17, 8, 'T8001', '2026-01-01 08:00:00', 'completed', 100.00, 'web', 'India'),
(18, 8, 'T8002', '2026-01-20 08:00:00', 'completed', 200.00, 'web', 'India'),
(19, 8, 'T8003', '2026-01-05 08:00:00', 'completed', 150.00, 'web', 'India'),

-- ----------------------------------------------------------
-- USER 9: Cross year boundary (valid retained)
(20, 9, 'T9001', '2025-12-29 10:00:00', 'completed', 100.00, 'ios', 'India'),
(21, 9, 'T9002', '2026-01-03 09:59:59', 'completed', 200.00, 'ios', 'India'),

-- ----------------------------------------------------------
-- USER 10: Pending before completed (must ignore pending)
(22,10, 'T10001', '2026-01-01 07:00:00', 'pending', 50.00, 'android', 'India'),
(23,10, 'T10002', '2026-01-02 07:00:00', 'completed', 80.00, 'android', 'India'),
(24,10, 'T10003', '2026-01-08 07:00:00', 'completed', 120.00, 'android', 'India'),

-- ----------------------------------------------------------
-- USER 11: Same day multiple orders different times
(25,11, 'T11001', '2026-01-01 08:00:00', 'completed', 60.00, 'web', 'UK'),
(26,11, 'T11002', '2026-01-01 18:00:00', 'completed', 70.00, 'web', 'UK'),

-- ----------------------------------------------------------
-- USER 12: First completed is later because earlier refunded
(27,12, 'T12001', '2026-01-01 10:00:00', 'refunded', 200.00, 'ios', 'USA'),
(28,12, 'T12002', '2026-01-02 10:00:00', 'completed', 300.00, 'ios', 'USA'),
(29,12, 'T12003', '2026-01-10 10:00:00', 'completed', 400.00, 'ios', 'USA');