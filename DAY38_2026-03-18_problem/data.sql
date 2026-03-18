
INSERT INTO subscriptions_log (user_id, event_type, event_date, amount) VALUES

-- ✅ Normal flow (start → renewal → cancel → restart after 30 days → recovery)
(1, 'start',   '2026-01-01 10:00:00', 100),
(1, 'renewal', '2026-02-01 10:00:00', 100),
(1, 'cancel',  '2026-02-10 09:00:00', NULL),
(1, 'start',   '2026-03-20 08:00:00', 120), -- recovery (>30 days)

-- ❌ Restart within 30 days (NOT churn)
(2, 'start',  '2026-01-01 09:00:00', 80),
(2, 'cancel', '2026-01-10 09:00:00', NULL),
(2, 'start',  '2026-01-25 09:00:00', 90),

-- 💀 Multiple pause/resume cycles
(3, 'start',  '2026-01-01 08:00:00', 70),
(3, 'pause',  '2026-01-05 08:00:00', NULL),
(3, 'resume', '2026-01-10 08:00:00', NULL),
(3, 'pause',  '2026-01-15 08:00:00', NULL),
(3, 'resume', '2026-01-18 08:00:00', NULL),
(3, 'cancel', '2026-02-01 08:00:00', NULL),

-- 💀 Resume without pause (dirty data)
(4, 'resume', '2026-01-01 07:00:00', NULL),
(4, 'start',  '2026-01-02 07:00:00', 60),
(4, 'cancel', '2026-01-20 07:00:00', NULL),

-- 💀 Cancel without start
(5, 'cancel', '2026-01-10 06:00:00', NULL),

-- 💀 Overlapping starts
(6, 'start', '2026-01-01 10:00:00', 100),
(6, 'start', '2026-01-05 10:00:00', 110),
(6, 'cancel','2026-01-20 10:00:00', NULL),

-- 💀 No cancel (still active)
(7, 'start',   '2026-01-01 12:00:00', 200),
(7, 'renewal', '2026-02-01 12:00:00', 200),

-- 💀 Multiple churn + recovery cycles
(8, 'start',  '2026-01-01 09:00:00', 50),
(8, 'cancel', '2026-01-05 09:00:00', NULL),
(8, 'start',  '2026-02-10 09:00:00', 70), -- recovery
(8, 'cancel', '2026-02-20 09:00:00', NULL),
(8, 'start',  '2026-04-01 09:00:00', 90), -- recovery again

-- 💀 Out-of-order events (important!)
(9, 'cancel', '2026-01-20 10:00:00', NULL),
(9, 'start',  '2026-01-01 10:00:00', 120),

-- 💀 Same timestamp events
(10, 'start',  '2026-01-01 10:00:00', 100),
(10, 'cancel', '2026-01-01 10:00:00', NULL),

-- 💀 Long inactivity then resume (edge of churn logic)
(11, 'start',  '2026-01-01 10:00:00', 100),
(11, 'pause',  '2026-01-05 10:00:00', NULL),
(11, 'resume', '2026-02-10 10:00:00', NULL), -- >30 days gap

-- 💀 Multiple renewals before cancel
(12, 'start',   '2026-01-01 09:00:00', 150),
(12, 'renewal', '2026-02-01 09:00:00', 150),
(12, 'renewal', '2026-03-01 09:00:00', 150),
(12, 'cancel',  '2026-03-10 09:00:00', NULL); 
