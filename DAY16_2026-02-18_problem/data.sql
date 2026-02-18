INSERT INTO Users (user_id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David'),
(5, 'Eve'),
(6, 'Frank'),
(7, 'Grace'),
(8, 'Hannah'),
(9, 'Ivy'),
(10, 'Jack');

INSERT INTO Referrals (referrer_id, referee_id, signup_date) VALUES
-- Alice's network
(1, 2, '2026-01-01'),  -- Bob
(1, 6, '2026-01-02'),  -- Frank
-- Bob's network
(2, 3, '2026-01-02'),  -- Charlie
(2, 5, '2026-01-05'),  -- Eve
-- Charlie's network
(3, 4, '2026-01-03'),  -- David
-- Frank's network
(6, 7, '2026-01-06'),  -- Grace
(6, 8, '2026-01-07'),  -- Hannah
-- Grace's network
(7, 9, '2026-01-08'),  -- Ivy
-- Hannah's network
(8, 10, '2026-01-09'); -- Jack
