INSERT INTO user_activity (user_id, activity_date, activity_type) VALUES

-- USER 1 (basic + cancel reset)
(1, '2024-01-01', 'login'),
(1, '2024-01-02', 'login'),
(1, '2024-01-03', 'login'),
(1, '2024-01-03', 'cancel'), -- break
(1, '2024-01-04', 'login'),
(1, '2024-01-05', 'login'),

-- USER 2 (missing day breaks streak)
(2, '2024-01-01', 'login'),
(2, '2024-01-02', 'login'),
(2, '2024-01-04', 'login'),

-- USER 3 (purchase only ignored)
(3, '2024-01-01', 'purchase'),
(3, '2024-01-02', 'login'),
(3, '2024-01-03', 'login'),
(3, '2024-01-04', 'purchase'),

-- USER 4 (multiple same day + cancel)
(4, '2024-01-01', 'login'),
(4, '2024-01-01', 'login'),
(4, '2024-01-02', 'login'),
(4, '2024-01-02', 'cancel'), -- invalid
(4, '2024-01-03', 'login'),

-- USER 5 (all valid long streak)
(5, '2024-01-01', 'login'),
(5, '2024-01-02', 'login'),
(5, '2024-01-03', 'login'),
(5, '2024-01-04', 'login'),

-- USER 6 (only cancel days)
(6, '2024-01-01', 'cancel'),
(6, '2024-01-02', 'cancel'),

-- USER 7 (complex mixed)
(7, '2024-01-01', 'login'),
(7, '2024-01-02', 'login'),
(7, '2024-01-03', 'cancel'),
(7, '2024-01-04', 'login'),
(7, '2024-01-05', 'login'),
(7, '2024-01-06', 'login'),
(7, '2024-01-07', 'purchase'),
(7, '2024-01-08', 'login');
select * from user_activity; 
