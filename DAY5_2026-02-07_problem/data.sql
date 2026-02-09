INSERT INTO customers VALUES 
-- Original customers
(1, 'alice@example.com', 'USA', '2023-01-05', 'organic'),
(2, 'bob@example.com', 'UK', '2023-01-15', 'paid_ad'),
(3, 'carol@example.com', 'USA', '2023-02-01', 'referral'),
(4, 'dave@example.com', 'Canada', '2023-02-20', 'organic'),
(5, 'eve@example.com', 'USA', '2023-03-10', 'paid_ad'),
(6, 'frank@example.com', 'Germany', '2023-03-15', 'organic'),
(7, 'grace@example.com', 'UK', '2023-04-01', 'referral'),
(8, 'henry@example.com', 'USA', '2023-04-15', 'paid_ad'),
(9, 'ivy@example.com', 'France', '2023-05-01', 'organic'),
(10, 'jack@example.com', 'USA', '2023-05-20', 'referral'),
(11, 'kate@example.com', 'USA', '2023-01-01', 'organic'), -- no orders
(12, 'leo@example.com', 'UK', '2023-01-10', 'paid_ad'),
(13, 'mia@example.com', 'Canada', '2023-02-05', 'referral'),
(14, 'noah@example.com', 'USA', '2023-01-20', 'organic'),
(15, 'olivia@example.com', 'Germany', '2023-03-01', 'paid_ad'), -- only refunded
(16, 'peter@example.com', 'UK', '2023-04-05', 'organic'),
(17, 'quinn@example.com', 'USA', '2023-01-31', 'referral'),
(18, 'rachel@example.com', 'Canada', '2023-12-15', 'paid_ad'),
(19, 'sam@example.com', 'USA', '2023-06-01', 'organic'),
(20, 'tina@example.com', 'UK', '2023-07-01', 'referral'),

-- Edge case customers
(21, 'pending_only@example.com', 'USA', '2023-01-05', 'organic'),
(22, 'same_day@example.com', 'UK', '2023-01-10', 'paid_ad'),
(23, 'pending_first@example.com', 'Canada', '2023-02-01', 'referral'),
(24, 'year_boundary@example.com', 'Germany', '2023-12-01', 'organic'),
(25, 'refunded_then_done@example.com', 'USA', '2023-03-01', 'paid_ad'),
(26, 'mixed_status@example.com', 'UK', '2023-04-01', 'organic'),
(27, 'month_boundary@example.com', 'France', '2023-01-31', 'referral'),
(28, 'zero_dollar@example.com', 'USA', '2023-05-01', 'organic');

INSERT INTO order_items VALUES
(1, 101, 'Electronics', 1, 100.00),
(2, 102, 'Clothing', 2, 75.00),
(3, 103, 'Electronics', 1, 200.00),
(4, 104, 'Home', 3, 100.00),
(5, 105, 'Electronics', 1, 80.00),
(6, 106, 'Clothing', 3, 40.00),
(7, 107, 'Books', 1, 50.00),
(8, 108, 'Books', 1, 75.00),
(9, 109, 'Electronics', 1, 100.00),
(10, 110, 'Home', 5, 100.00),
(11, 111, 'Clothing', 2, 30.00),
(12, 112, 'Electronics', 1, 90.00),
(13, 113, 'Books', 2, 20.00),
(14, 114, 'Electronics', 2, 100.00),
(15, 115, 'Clothing', 2, 50.00),
(16, 116, 'Books', 5, 10.00),
(17, 117, 'Books', 1, 30.00),
(18, 118, 'Books', 1, 35.00),
(19, 119, 'Books', 1, 40.00),
(20, 120, 'Electronics', 1, 250.00),
(21, 121, 'Clothing', 3, 60.00),
(22, 122, 'Home', 1, 150.00),
(23, 123, 'Electronics', 1, 200.00),
(24, 124, 'Home', 1, 100.00),
(25, 125, 'Home', 1, 100.00),
(26, 126, 'Home', 1, 100.00),
(27, 127, 'Home', 1, 100.00),
(28, 128, 'Books', 3, 15.00),
(29, 129, 'Clothing', 2, 40.00),
(30, 130, 'Electronics', 1, 120.00),
(31, 131, 'Books', 5, 10.00),
(32, 132, 'Electronics', 1, 100.00),
(33, 133, 'Home', 2, 75.00),
(34, 134, 'Electronics', 2, 100.00),
(35, 135, 'Electronics', 1, 300.00),
(36, 136, 'Clothing', 5, 50.00),
(37, 137, 'Home', 1, 100.00),
(38, 138, 'Electronics', 1, 150.00),
(39, 139, 'Home', 2, 100.00),
(40, 140, 'Books', 3, 25.00),
(41, 141, 'Clothing', 2, 42.50),
(42, 142, 'Electronics', 1, 100.00),
(43, 143, 'Home', 1, 150.00),
(44, 144, 'Books', 1, 50.00),
(45, 145, 'Electronics', 1, 60.00),
(46, 146, 'Clothing', 1, 55.00),
(47, 147, 'Home', 1, 70.00),
(48, 148, 'Books', 1, 45.00),
(49, 149, 'Electronics', 1, 80.00),
(50, 150, 'Clothing', 1, 65.00),
(51, 151, 'Home', 1, 90.00),
(52, 152, 'Books', 1, 75.00),
(53, 153, 'Electronics', 1, 100.00),
(54, 154, 'Books', 1, 0.00),
(55, 155, 'Clothing', 2, 25.00);

-- ============================================
-- INSERT ALL ORDERS
-- ============================================
INSERT INTO orders VALUES 
-- Alice (customer 1)
(101, 1, '2023-01-10', 100.00, 0.00, 'completed', 'desktop'),
(102, 1, '2023-02-15', 150.00, 10.00, 'completed', 'mobile'),
(103, 1, '2023-04-20', 200.00, 0.00, 'completed', 'desktop'),
(104, 1, '2023-06-25', 300.00, 25.00, 'completed', 'mobile'),

-- Bob (customer 2) - refunded then completed
(105, 2, '2023-01-20', 80.00, 0.00, 'refunded', 'desktop'),
(106, 2, '2023-03-05', 120.00, 0.00, 'completed', 'mobile'),

-- Carol (customer 3) - cancelled then completed
(107, 3, '2023-02-10', 50.00, 0.00, 'cancelled', 'tablet'),
(108, 3, '2023-02-12', 75.00, 5.00, 'completed', 'desktop'),
(109, 3, '2023-05-15', 100.00, 0.00, 'completed', 'mobile'),

-- Dave (customer 4)
(110, 4, '2023-02-25', 500.00, 50.00, 'completed', 'desktop'),

-- Eve (customer 5)
(111, 5, '2023-03-12', 60.00, 0.00, 'completed', 'mobile'),
(112, 5, '2023-03-18', 90.00, 0.00, 'completed', 'desktop'),
(113, 5, '2023-03-25', 40.00, 0.00, 'completed', 'mobile'),

-- Frank (customer 6)
(114, 6, '2023-03-20', 200.00, 0.00, 'completed', 'desktop'),
(115, 6, '2023-04-22', 100.00, 0.00, 'completed', 'mobile'),
(116, 6, '2023-08-01', 50.00, 0.00, 'completed', 'tablet'),

-- Grace (customer 7)
(117, 7, '2023-04-05', 30.00, 0.00, 'completed', 'mobile'),
(118, 7, '2023-05-05', 35.00, 0.00, 'completed', 'mobile'),
(119, 7, '2023-06-05', 40.00, 0.00, 'completed', 'mobile'),

-- Henry (customer 8)
(120, 8, '2023-04-20', 250.00, 0.00, 'completed', 'desktop'),
(121, 8, '2023-09-10', 180.00, 20.00, 'completed', 'mobile'),

-- Ivy (customer 9) - pending then completed
(122, 9, '2023-05-05', 150.00, 0.00, 'pending', 'desktop'),
(123, 9, '2023-05-20', 200.00, 0.00, 'completed', 'mobile'),

-- Jack (customer 10)
(124, 10, '2023-05-31', 100.00, 0.00, 'completed', 'desktop'),
(125, 10, '2023-06-01', 100.00, 0.00, 'completed', 'mobile'),
(126, 10, '2023-06-30', 100.00, 0.00, 'completed', 'tablet'),
(127, 10, '2023-07-31', 100.00, 0.00, 'completed', 'desktop'),

-- Leo (customer 12) - single order
(128, 12, '2023-01-15', 45.00, 0.00, 'completed', 'mobile'),

-- Mia (customer 13) - same day multiple orders
(129, 13, '2023-02-10', 80.00, 0.00, 'completed', 'desktop'),
(130, 13, '2023-02-10', 120.00, 0.00, 'completed', 'mobile'),
(131, 13, '2023-02-10', 50.00, 0.00, 'completed', 'tablet'),

-- Noah (customer 14) - 90+ day gaps
(132, 14, '2023-01-25', 100.00, 0.00, 'completed', 'desktop'),
(133, 14, '2023-05-01', 150.00, 0.00, 'completed', 'mobile'),
(134, 14, '2023-08-15', 200.00, 0.00, 'completed', 'desktop'),

-- Olivia (customer 15) - all refunded
(135, 15, '2023-03-05', 300.00, 0.00, 'refunded', 'desktop'),
(136, 15, '2023-04-10', 250.00, 0.00, 'refunded', 'mobile'),

-- Peter (customer 16) - cancelled then completed
(137, 16, '2023-04-10', 100.00, 0.00, 'cancelled', 'desktop'),
(138, 16, '2023-04-15', 150.00, 0.00, 'completed', 'mobile'),
(139, 16, '2023-06-20', 200.00, 0.00, 'cancelled', 'tablet'),

-- Quinn (customer 17) - month boundaries
(140, 17, '2023-01-31', 75.00, 0.00, 'completed', 'desktop'),
(141, 17, '2023-02-28', 85.00, 0.00, 'completed', 'mobile'),

-- Rachel (customer 18) - year boundary
(142, 18, '2023-12-20', 100.00, 0.00, 'completed', 'desktop'),
(143, 18, '2024-01-05', 150.00, 0.00, 'completed', 'mobile'),

-- Sam (customer 19) - high frequency
(144, 19, '2023-06-01', 50.00, 0.00, 'completed', 'mobile'),
(145, 19, '2023-06-02', 60.00, 0.00, 'completed', 'desktop'),
(146, 19, '2023-06-03', 55.00, 0.00, 'completed', 'mobile'),
(147, 19, '2023-06-05', 70.00, 0.00, 'completed', 'desktop'),
(148, 19, '2023-06-08', 45.00, 0.00, 'completed', 'mobile'),
(149, 19, '2023-06-10', 80.00, 0.00, 'completed', 'desktop'),
(150, 19, '2023-06-12', 65.00, 0.00, 'completed', 'mobile'),
(151, 19, '2023-06-15', 90.00, 0.00, 'completed', 'desktop'),
(152, 19, '2023-06-18', 75.00, 0.00, 'completed', 'mobile'),
(153, 19, '2023-06-20', 100.00, 0.00, 'completed', 'desktop'),

-- Tina (customer 20) - $0 order
(154, 20, '2023-07-05', 0.00, 0.00, 'completed', 'mobile'),
(155, 20, '2023-07-10', 50.00, 0.00, 'completed', 'desktop'),

-- ============================================
-- EDGE CASE ORDERS
-- ============================================

-- #21: pending_only (never active)
(201, 21, '2023-01-15', 100.00, 0.00, 'pending', 'desktop'),
(202, 21, '2023-02-15', 150.00, 0.00, 'pending', 'mobile'),

-- #22: same_day (first cancelled, second completed same day)
(203, 22, '2023-01-20', 100.00, 0.00, 'cancelled', 'desktop'),
(204, 22, '2023-01-20', 200.00, 0.00, 'completed', 'mobile'),

-- #23: pending_first (pending then completed same month)
(205, 23, '2023-02-10', 100.00, 0.00, 'pending', 'desktop'),
(206, 23, '2023-02-25', 150.00, 0.00, 'completed', 'mobile'),
(207, 23, '2023-03-25', 200.00, 0.00, 'completed', 'desktop'),

-- #24: year_boundary (Dec 2023 -> Jan 2024 -> Feb 2024)
(208, 24, '2023-12-15', 100.00, 0.00, 'completed', 'desktop'),
(209, 24, '2024-01-15', 150.00, 0.00, 'completed', 'mobile'),
(210, 24, '2024-02-15', 200.00, 0.00, 'completed', 'desktop'),

-- #25: refunded_then_done (refunded then completed same month)
(211, 25, '2023-03-05', 100.00, 0.00, 'refunded', 'desktop'),
(212, 25, '2023-03-25', 200.00, 0.00, 'completed', 'mobile'),
(213, 25, '2023-04-25', 150.00, 0.00, 'completed', 'desktop'),

-- #26: mixed_status (multiple orders, mix completed/cancelled/refunded)
(214, 26, '2023-04-10', 100.00, 0.00, 'completed', 'desktop'),
(215, 26, '2023-04-15', 150.00, 0.00, 'cancelled', 'mobile'),
(216, 26, '2023-04-20', 200.00, 0.00, 'refunded', 'tablet'),
(217, 26, '2023-04-25', 250.00, 0.00, 'completed', 'desktop'),

-- #27: month_boundary (Jan 31 -> Feb 1 -> Mar 1)
(218, 27, '2023-01-31', 100.00, 0.00, 'completed', 'desktop'),
(219, 27, '2023-02-01', 150.00, 0.00, 'completed', 'mobile'),
(220, 27, '2023-03-01', 200.00, 0.00, 'completed', 'desktop'),

-- #28: zero_dollar ($0 completed order)
(221, 28, '2023-05-15', 0.00, 0.00, 'completed', 'mobile'),
(222, 28, '2023-06-15', 100.00, 0.00, 'completed', 'desktop');