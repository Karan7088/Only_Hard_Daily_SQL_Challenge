INSERT INTO inventory_events VALUES
-- ---------------------------------------
-- PRODUCT 101 – Warehouse 1
-- ---------------------------------------

-- Day 1 purchase
(1, 101, 1, '2026-02-10 09:00:00', 'PURCHASE', 100, NULL),

-- Sale
(2, 101, 1, '2026-02-10 11:00:00', 'SALE', 30, NULL),

-- Adjustment negative
(3, 101, 1, '2026-02-10 12:00:00', 'ADJUSTMENT', -10, NULL),

-- Same timestamp tie case (order by event_id must matter)
(4, 101, 1, '2026-02-10 12:00:00', 'SALE', 20, NULL),

-- Negative dip intraday
(5, 101, 1, '2026-02-10 13:00:00', 'SALE', 50, NULL),

-- ---------------------------------------
-- Late arriving backdated event (inserted later but older time)
-- ---------------------------------------
(6, 101, 1, '2026-02-10 10:00:00', 'SALE', 15, NULL),

-- ---------------------------------------
-- Day 2 continues running balance
-- ---------------------------------------
(7, 101, 1, '2026-02-11 09:00:00', 'PURCHASE', 40, NULL),

(8, 101, 1, '2026-02-11 10:00:00', 'SALE', 20, NULL),

-- Adjustment positive
(9, 101, 1, '2026-02-11 12:00:00', 'ADJUSTMENT', 5, NULL),

-- ---------------------------------------
-- TRANSFER OUT from warehouse 1
-- ---------------------------------------
(10, 101, 1, '2026-02-11 15:00:00', 'TRANSFER_OUT', 25, 9001),

-- ---------------------------------------
-- PRODUCT 101 – Warehouse 2
-- ---------------------------------------

-- Transfer IN must match reference_id
(11, 101, 2, '2026-02-11 15:05:00', 'TRANSFER_IN', 25, 9001),

-- Warehouse 2 starts from zero but receives transfer
(12, 101, 2, '2026-02-11 16:00:00', 'SALE', 5, NULL),

-- Negative dip same day in WH2
(13, 101, 2, '2026-02-11 17:00:00', 'SALE', 30, NULL),

-- ---------------------------------------
-- PRODUCT 202 – Multiple warehouses
-- ---------------------------------------

-- Warehouse 1 purchase
(14, 202, 1, '2026-02-10 08:00:00', 'PURCHASE', 200, NULL),

-- Big sale
(15, 202, 1, '2026-02-10 09:00:00', 'SALE', 180, NULL),

-- Transfer OUT
(16, 202, 1, '2026-02-10 10:00:00', 'TRANSFER_OUT', 10, 9002),

-- Transfer IN to warehouse 2
(17, 202, 2, '2026-02-10 10:05:00', 'TRANSFER_IN', 10, 9002),

-- Warehouse 2 sale
(18, 202, 2, '2026-02-10 11:00:00', 'SALE', 15, NULL),

-- ---------------------------------------
-- Multiple events exact same timestamp different event_id
-- ---------------------------------------
(19, 202, 2, '2026-02-12 09:00:00', 'PURCHASE', 50, NULL),
(20, 202, 2, '2026-02-12 09:00:00', 'SALE', 20, NULL),
(21, 202, 2, '2026-02-12 09:00:00', 'SALE', 40, NULL),

-- ---------------------------------------
-- Large negative adjustment
-- ---------------------------------------
(22, 202, 1, '2026-02-12 14:00:00', 'ADJUSTMENT', -50, NULL),

-- ---------------------------------------
-- Event out of chronological insert order
-- ---------------------------------------
(23, 101, 1, '2026-02-09 23:00:00', 'PURCHASE', 60, NULL),

-- ---------------------------------------
-- Zero quantity edge case
-- ---------------------------------------
(24, 101, 1, '2026-02-12 08:00:00', 'ADJUSTMENT', 0, NULL),

-- ---------------------------------------
-- Multiple transfers same day same product
-- ---------------------------------------
(25, 101, 1, '2026-02-12 09:00:00', 'TRANSFER_OUT', 10, 9003),
(26, 101, 2, '2026-02-12 09:05:00', 'TRANSFER_IN', 10, 9003),

-- ---------------------------------------
-- Extreme edge: sale before any purchase (should go negative immediately)
-- ---------------------------------------
(27, 303, 1, '2026-02-10 09:00:00', 'SALE', 10, NULL);

