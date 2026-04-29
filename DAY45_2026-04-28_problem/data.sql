INSERT INTO user_activity VALUES
-- User 1 (perfect retention → churn → resurrection)
(1,'2024-01-05'),
(1,'2024-01-10'),
(1,'2024-02-03'),
(1,'2024-02-15'),
(1,'2024-04-01'),

-- User 2 (single month → churn forever)
(2,'2024-01-07'),

-- User 3 (gap + resurrection + retention)
(3,'2024-01-01'),
(3,'2024-03-01'),
(3,'2024-04-01'),

-- User 4 (continuous retention)
(4,'2024-01-02'),
(4,'2024-02-02'),
(4,'2024-03-02'),
(4,'2024-04-02'),

-- User 5 (multiple activities same month)
(5,'2024-02-01'),
(5,'2024-02-05'),
(5,'2024-02-20'),
(5,'2024-03-01'),

-- User 6 (late start)
(6,'2024-03-10'),
(6,'2024-04-10'),

-- User 7 (resurrection multiple times)
(7,'2024-01-01'),
(7,'2024-03-01'),
(7,'2024-05-01'),

-- User 8 (only one late month)
(8,'2024-04-15'),

-- User 9 (continuous but noisy duplicates)
(9,'2024-01-01'),
(9,'2024-01-02'),
(9,'2024-02-01'),
(9,'2024-02-02'),
(9,'2024-03-01'),

-- User 10 (gap then return)
(10,'2024-02-01'),
(10,'2024-04-01'),

-- User 11 (long inactivity then return)
(11,'2024-01-01'),
(11,'2024-06-01'),

-- User 12 (single + duplicate)
(12,'2024-03-05'),
(12,'2024-03-06'),

-- User 13 (perfect retention long)
(13,'2024-01-01'),
(13,'2024-02-01'),
(13,'2024-03-01'),
(13,'2024-04-01'),
(13,'2024-05-01'),

-- User 14 (churn immediately)
(14,'2024-02-10'),

-- User 15 (zig-zag activity)
(15,'2024-01-01'),
(15,'2024-02-01'),
(15,'2024-04-01'),
(15,'2024-06-01'),

-- User 16 (only mid activity)
(16,'2024-03-01'),

-- User 17 (duplicate heavy)
(17,'2024-01-01'),
(17,'2024-01-02'),
(17,'2024-01-03'),
(17,'2024-02-01'),

-- User 18 (late + gap)
(18,'2024-04-01'),
(18,'2024-06-01'),

-- User 19 (continuous small)
(19,'2024-02-01'),
(19,'2024-03-01'),

-- User 20 (single last month)
(20,'2024-06-01');
 
