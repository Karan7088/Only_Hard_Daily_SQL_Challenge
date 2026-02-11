INSERT INTO users VALUES
(1,'2026-01-01'),
(2,'2026-01-02'),
(3,'2026-01-03'),
(4,'2026-01-04'),
(5,'2026-01-05'),
(6,'2026-01-06'),
(7,'2026-01-07'),
(8,'2026-01-08'),
(9,'2026-01-09'),
(10,'2026-01-10'),
(11, '2026-02-05 09:00:00'),
(12, '2026-02-05 09:05:00'),
(13, '2026-02-05 09:10:00'),
(14, '2026-02-05 09:15:00');

INSERT INTO transactions VALUES

-- Circular cluster A
('T1',1,2,1000,'SUCCESS','2026-02-01 10:00:00'),
('T2',2,3,2000,'SUCCESS','2026-02-01 10:05:00'),
('T3',3,1,1500,'SUCCESS','2026-02-01 10:10:00'),

-- Duplicate txn_id (should deduplicate if logic applied)
('T4',3,4,3000,'SUCCESS','2026-02-01 10:15:00'),
('T4',3,4,3000,'SUCCESS','2026-02-01 10:16:00'),

-- Self transfer (ignore)
('T5',4,4,500,'SUCCESS','2026-02-01 10:20:00'),

-- Failed transaction (ignore)
('T6',4,5,4000,'FAILED','2026-02-01 10:25:00'),

-- Negative reversal (ignore in exposure)
('T7',2,1,-1000,'SUCCESS','2026-02-02 09:00:00'),

-- Cross cluster legit transfer
('T8',5,6,6000,'SUCCESS','2026-02-02 10:00:00'),

-- Another connection forming larger component
('T9',6,7,2500,'SUCCESS','2026-02-02 11:00:00'),

-- Same timestamp different rows
('T10',7,5,1200,'SUCCESS','2026-02-02 11:00:00'),

-- Zero amount edge case
('T11',8,9,0,'SUCCESS','2026-02-03 12:00:00'),

-- Orphan transaction (sender not in users table)
('T12',99,1,3000,'SUCCESS','2026-02-03 13:00:00'),

-- Receiver not in users
('T13',2,100,2000,'SUCCESS','2026-02-03 14:00:00'),

-- Large isolated transfer
('T14',9,10,7000,'SUCCESS','2026-02-04 15:00:00'),

-- Reverse direction linking
('T15',10,9,1000,'SUCCESS','2026-02-04 16:00:00');

 
 INSERT INTO device_logins VALUES

-- Shared device cluster A
(1,'D1','2026-02-01'),
(2,'D1','2026-02-01'),

-- Device linking cluster A to 4
(3,'D2','2026-02-01'),
(4,'D2','2026-02-01'),

-- Bridge cluster
(5,'D3','2026-02-02'),
(6,'D3','2026-02-02'),

-- Multi-device user
(6,'D4','2026-02-02'),

-- NULL device edge case
(7,NULL,'2026-02-02'),

-- Same device reused later (time gap)
(7,'D5','2026-02-05'),
(8,'D5','2026-02-05'),

-- Isolated login
(9,'D9','2026-02-06'),

-- User not in users table
(100,'D10','2026-02-07'),

(14, 'd99',  '2026-02-05 10:00:00'),
(11, 'd99',  '2026-02-05 11:00:00'),
(12, 'd99', '2026-02-05 12:00:00'),
(13, 'd99',  '2026-02-05 13:00:00');

 INSERT INTO fraud_alerts VALUES
(2,'2026-02-01 11:00:00'),
(6,'2026-02-02 12:00:00'),
(6,'2026-02-02 12:30:00'), -- duplicate alert
(100,'2026-02-03 10:00:00'), -- user not in users
(10,'2026-02-04 17:00:00');



