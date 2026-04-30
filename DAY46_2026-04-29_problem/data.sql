 INSERT INTO graph VALUES
-- Base paths
('A','B',5),
('A','C',10),
('A','D',20),

-- Better indirect routes
('B','C',3),
('B','D',9),

('C','D',1),
('C','E',7),

('D','E',2),

-- Cycle (important)
('E','B',1),

-- Reverse expensive loop
('C','A',50),

-- Extra complexity (multiple choices)
('B','E',15),
('A','E',50),

-- Alternate cheaper chain
('E','F',3),
('F','G',2),
('G','D',1),

-- Another misleading expensive path
('C','G',20),

-- Deep cycle
('G','B',4),

-- Additional nodes for depth
('D','H',6),
('H','I',2),
('I','E',1);

select * from graph;
