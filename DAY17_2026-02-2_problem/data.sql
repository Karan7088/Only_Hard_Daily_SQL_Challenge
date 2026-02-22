INSERT INTO sales VALUES
-- Jan 2025 (Base month)
(1, 101, '2025-01-05', 200),
(2, 102, '2025-01-10', 300),

-- Feb 2025 (Growth)
(3, 101, '2025-02-05', 600),

-- Mar 2025 (Growth)
(4, 103, '2025-03-05', 700),

-- Apr 2025 (Drop)
(5, 104, '2025-04-05', 500),

-- May 2025 (Growth)
(6, 105, '2025-05-05', 800),

-- Jun 2025 (Equal revenue → break)
(7, 106, '2025-06-05', 800),

-- Jul 2025 (Growth)
(8, 107, '2025-07-05', 900),

-- Aug 2025 (Growth continues)
(9, 108, '2025-08-05', 1000),

-- Sep 2025 (Drop)
(10, 109, '2025-09-05', 600),

-- Oct 2025 (Single growth month)
(11, 110, '2025-10-05', 700),

-- Dec 2025 (Gap month missing November)
(12, 111, '2025-12-05', 1200),

-- Jan 2026 (Growth after gap)
(13, 112, '2026-01-05', 1300);

-- select * from sales;