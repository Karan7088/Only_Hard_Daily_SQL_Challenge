INSERT INTO employee_hierarchy VALUES

-- 🔹 Simple linear chain
(1, 2),
(2, 3),
(3, NULL),

-- 🔹 Self loop
(4, 4),

-- 🔹 Small cycle
(5, 6),
(6, 5),

-- 🔹 Mid-chain cycle
(7, 8),
(8, 9),
(9, 10),
(10, 8),

-- 🔹 Proper tree
(11, 12),
(12, 13),
(13, NULL),

-- 🔹 Another independent tree
(14, 15),
(15, 16),
(16, 17),
(17, NULL),

-- 🔹 Disconnected single node
(18, NULL),

-- 🔹 Deep hierarchy
(19, 20),
(20, 21),
(21, 22),
(22, 23),
(23, 24),
(24, NULL),

-- 🔹 Cycle with tail
(25, 26),
(26, 27),
(27, 28),
(28, 26),

-- 🔹 Two-node loop
(29, 30),
(30, 29),

-- 🔹 Node pointing into another cycle
(31, 7),

-- 🔹 Node pointing to self-loop chain
(32, 4),

-- 🔹 Orphan (manager doesn't exist)
(33, 999),

-- 🔹 Chain ending in orphan
(34, 33);
