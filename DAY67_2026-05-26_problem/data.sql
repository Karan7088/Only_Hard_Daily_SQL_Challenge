INSERT INTO product_price_history VALUES
-- Product P1: normal price, then glitch, then fixed
(1,'P1','2024-01-01 08:00:00','2024-01-01 10:00:00',1000.00,1000.00,'NORMAL'),
(2,'P1','2024-01-01 10:00:00','2024-01-01 10:30:00',1000.00,100.00,'GLITCH'),
(3,'P1','2024-01-01 10:30:00',NULL,1000.00,1000.00,'NORMAL'),

-- Product P2: short glitch window
(4,'P2','2024-01-01 09:00:00','2024-01-01 09:20:00',500.00,500.00,'NORMAL'),
(5,'P2','2024-01-01 09:20:00','2024-01-01 09:40:00',500.00,50.00,'GLITCH'),
(6,'P2','2024-01-01 09:40:00',NULL,500.00,500.00,'NORMAL'),

-- Product P3: no glitch
(7,'P3','2024-01-01 08:00:00',NULL,300.00,300.00,'NORMAL'),

-- Product P4: overlapping glitch-like edge case
(8,'P4','2024-01-01 11:00:00','2024-01-01 11:30:00',2000.00,2000.00,'NORMAL'),
(9,'P4','2024-01-01 11:30:00','2024-01-01 12:00:00',2000.00,250.00,'GLITCH'),
(10,'P4','2024-01-01 12:00:00',NULL,2000.00,2000.00,'NORMAL');


INSERT INTO orders VALUES
-- Customer 101 abuses P1 glitch with multiple orders
(1,101,'P1','2024-01-01 10:05:00',1,100.00),
(2,101,'P1','2024-01-01 10:10:00',2,200.00),
(3,101,'P1','2024-01-01 10:25:00',1,100.00),

-- Customer 102 buys once during glitch only, not abuse
(4,102,'P1','2024-01-01 10:15:00',1,100.00),

-- Customer 103 buys after glitch fixed
(5,103,'P1','2024-01-01 10:35:00',1,1000.00),

-- Customer 104 abuses P2 glitch
(6,104,'P2','2024-01-01 09:22:00',1,50.00),
(7,104,'P2','2024-01-01 09:25:00',2,100.00),
(8,104,'P2','2024-01-01 09:35:00',1,50.00),

-- Customer 105 normal P3 purchases
(9,105,'P3','2024-01-01 09:00:00',1,300.00),
(10,105,'P3','2024-01-01 10:00:00',2,600.00),

-- Customer 106 buys P4 during glitch but only once
(11,106,'P4','2024-01-01 11:40:00',1,250.00),

-- Customer 107 abuses P4 glitch
(12,107,'P4','2024-01-01 11:35:00',1,250.00),
(13,107,'P4','2024-01-01 11:45:00',1,250.00),
(14,107,'P4','2024-01-01 11:55:00',2,500.00),

-- Edge: order exactly at glitch start should count
(15,108,'P1','2024-01-01 10:00:00',1,100.00),

-- Edge: order exactly at glitch end should NOT count, fixed price applies
(16,109,'P1','2024-01-01 10:30:00',1,1000.00),

-- Customer 110 buys multiple products, only P1 abuse qualifies
(17,110,'P1','2024-01-01 10:02:00',1,100.00),
(18,110,'P1','2024-01-01 10:12:00',1,100.00),
(19,110,'P2','2024-01-01 09:50:00',1,500.00),

-- Customer 111 has two glitch orders but loss threshold low quantity
(20,111,'P2','2024-01-01 09:21:00',1,50.00),
(21,111,'P2','2024-01-01 09:39:00',1,50.00); 
