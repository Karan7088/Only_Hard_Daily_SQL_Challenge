INSERT INTO events VALUES
-- User 1 (perfect funnel)
(1, '2024-01-01 10:00:00', 'login'),
(1, '2024-01-01 10:05:00', 'view_product'),
(1, '2024-01-01 10:07:00', 'add_to_cart'),
(1, '2024-01-01 10:10:00', 'purchase'),

-- User 1 (new session fail)
(1, '2024-01-01 11:00:00', 'login'),
(1, '2024-01-01 11:10:00', 'view_product'),

-- User 2 (delayed purchase → invalid)
(2, '2024-01-01 09:00:00', 'login'),
(2, '2024-01-01 09:05:00', 'view_product'),
(2, '2024-01-01 09:10:00', 'add_to_cart'),
(2, '2024-01-01 09:40:00', 'purchase'),

-- User 3 (skip steps)
(3, '2024-01-01 12:00:00', 'login'),
(3, '2024-01-01 12:02:00', 'purchase'),

-- User 4 (multiple sessions, mixed behavior)
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
