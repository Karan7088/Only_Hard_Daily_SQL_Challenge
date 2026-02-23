INSERT INTO numbers (id, value) VALUES
-- 🔹 Normal random start
(1, 10),
(2, 9),

-- 🔹 Strict decreasing sequence
(3, 8),
(4, 7),
(5, 6),

-- 🔹 Start of increasing subsequence
(6, 2),
(7, 5),

-- 🔹 Duplicate case
(8, 5),

-- 🔹 Drop then rise
(9, 3),
(10, 7),

-- 🔹 Big spike
(11, 101),

-- 🔹 Smaller than previous but can form another LIS
(12, 18),

-- 🔹 Negative values
(13, -5),
(14, -1),

-- 🔹 Another increasing chain from negatives
(15, 0),
(16, 1),
(17, 2),
(18, 3),

-- 🔹 Plateau values
(19, 3),
(20, 3),

-- 🔹 Large jump
(21, 200),

-- 🔹 Zig-zag pattern
(22, 50),
(23, 40),
(24, 60),
(25, 30),
(26, 70),

-- 🔹 All equal section
(27, 100),
(28, 100),
(29, 100),

-- 🔹 Final rising tail
(30, 300);
-- select * from numbers;