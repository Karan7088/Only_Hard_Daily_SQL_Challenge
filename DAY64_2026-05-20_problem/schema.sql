INSERT INTO payment_attempts VALUES
-- user 101: failed payment recovered within 30 mins
(1, 101, 'M1', 500.00, '2024-01-01 09:00:00', 'FAILED', 'INSUFFICIENT_FUNDS'),
(2, 101, 'M1', 500.00, '2024-01-01 09:10:00', 'SUCCESS', NULL),

-- user 102: failed payment recovered exactly at 30 mins
(3, 102, 'M2', 1200.00, '2024-01-01 10:00:00', 'FAILED', 'CARD_DECLINED'),
(4, 102, 'M2', 1200.00, '2024-01-01 10:30:00', 'SUCCESS', NULL),

-- user 103: success after 30 mins, not recovered
(5, 103, 'M3', 750.00, '2024-01-01 11:00:00', 'FAILED', 'NETWORK_ERROR'),
(6, 103, 'M3', 750.00, '2024-01-01 11:45:00', 'SUCCESS', NULL),

-- user 104: same user and merchant, different amount, not recovered
(7, 104, 'M4', 999.00, '2024-01-01 12:00:00', 'FAILED', 'INSUFFICIENT_FUNDS'),
(8, 104, 'M4', 1000.00, '2024-01-01 12:10:00', 'SUCCESS', NULL),

-- user 105: multiple failures, one success should recover nearest valid failure
(9, 105, 'M5', 300.00, '2024-01-01 13:00:00', 'FAILED', 'OTP_FAILED'),
(10, 105, 'M5', 300.00, '2024-01-01 13:05:00', 'FAILED', 'OTP_FAILED'),
(11, 105, 'M5', 300.00, '2024-01-01 13:08:00', 'SUCCESS', NULL),

-- user 106: multiple successes, pick nearest success after failure
(12, 106, 'M6', 450.00, '2024-01-01 14:00:00', 'FAILED', 'BANK_TIMEOUT'),
(13, 106, 'M6', 450.00, '2024-01-01 14:12:00', 'SUCCESS', NULL),
(14, 106, 'M6', 450.00, '2024-01-01 14:25:00', 'SUCCESS', NULL),

-- user 107: success before failure should not count
(15, 107, 'M7', 600.00, '2024-01-01 15:00:00', 'SUCCESS', NULL),
(16, 107, 'M7', 600.00, '2024-01-01 15:05:00', 'FAILED', 'CARD_DECLINED'),

-- user 108: different merchant should not match
(17, 108, 'M8', 800.00, '2024-01-01 16:00:00', 'FAILED', 'NETWORK_ERROR'),
(18, 108, 'M9', 800.00, '2024-01-01 16:10:00', 'SUCCESS', NULL),

-- user 109: recovered after retry
(19, 109, 'M10', 1500.00, '2024-01-01 17:00:00', 'FAILED', 'INSUFFICIENT_FUNDS'),
(20, 109, 'M10', 1500.00, '2024-01-01 17:20:00', 'FAILED', 'INSUFFICIENT_FUNDS'),
(21, 109, 'M10', 1500.00, '2024-01-01 17:25:00', 'SUCCESS', NULL),

-- user 110: standalone failed payment
(22, 110, 'M11', 250.00, '2024-01-01 18:00:00', 'FAILED', 'BANK_TIMEOUT');
