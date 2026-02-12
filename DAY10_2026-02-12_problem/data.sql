truncate table trans;
INSERT INTO trans (tx_id, sender_id, receiver_id, amount, status, tx_date) VALUES

-- Normal successful transactions
(1, 101, 102, 500.00, 'success', '2026-02-10'),
(2, 102, 103, 300.00, 'success', '2026-02-10'),
(3, 103, 104, 200.00, 'success', '2026-02-10'),

-- Failed transactions
(4, 101, 103, 100.00, 'failed', '2026-02-10'),
(5, 104, 101, 50.00,  'failed', '2026-02-10'),

-- Edge cases: NULL, zero, negative, self-transfer
(6, 105, 105, 0.00,        'success', '2026-02-11'),   -- self-transfer
(7, 106, 107, NULL,        'success', '2026-02-11'),   -- NULL amount
(8, 107, 106, -50.00,      'success', '2026-02-11'),   -- negative amount
(9, 108, 109, 1000000.00,  'success', '2026-02-11'),   -- extremely high
(10, 101, 104, 200.00,     'success', '2026-02-11'),

-- Circular transactions (loop of 3)
(11, 201, 202, 100.00, 'success', '2026-02-12'),
(12, 202, 203, 100.00, 'success', '2026-02-12'),
(13, 203, 201, 100.00, 'success', '2026-02-12'),

-- More normal transactions
(14, 104, 105, 300.00, 'success', '2026-02-12'),
(15, 105, 106, 400.00, 'success', '2026-02-12'),

-- Duplicate-like same-day same-pair transactions
(16, 101, 102, 500.00, 'success', '2026-02-10'),
(17, 101, 102, 500.00, 'success', '2026-02-10'),

-- Broken chain (no continuation)
(18, 110, 111, 250.00, 'success', '2026-02-12'),

-- Multi-day chain continuation
(19, 111, 112, 250.00, 'success', '2026-02-13'),
(20, 112, 113, 250.00, 'success', '2026-02-14'),

-- Micro transactions
(21, 120, 121, 0.01, 'success', '2026-02-12'),
(22, 121, 122, 0.01, 'success', '2026-02-12'),

-- Whale transaction (anomaly candidate)
(23, 999, 888, 99999999.99, 'success', '2026-02-12'),

-- Multiple circular loops (same user in more than one loop)
(24, 301, 302, 100.00, 'success', '2026-02-12'),
(25, 302, 303, 100.00, 'success', '2026-02-12'),
(26, 303, 301, 100.00, 'success', '2026-02-12'),

(27, 301, 304, 50.00,  'success', '2026-02-12'),
(28, 304, 301, 50.00,  'success', '2026-02-12');

