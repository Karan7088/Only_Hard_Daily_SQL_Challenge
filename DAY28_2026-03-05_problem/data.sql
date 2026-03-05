INSERT INTO interactions VALUES
-- strong interactions
(1,2,5),(2,1,5),
(1,3,4),(3,1,4),
(2,3,3),(3,2,3),
(2,4,5),(4,2,5),
(3,4,4),(4,3,4),

-- weak interaction
(3,5,2),(5,3,2),

-- interaction only one direction
(7,8,5),

-- null interaction (breaks filters)
(1,5,NULL),

-- circular strong network
(9,10,4),(10,9,4),
(10,11,4),(11,10,4),
(11,9,4),(9,11,4),

-- large mutual interaction case
(12,13,4),(13,12,4),
(12,14,5),(14,12,5),
(12,15,4),(15,12,4),
(16,13,4),(13,16,4),
(16,14,4),(14,16,4),
(16,15,4),(15,16,4);