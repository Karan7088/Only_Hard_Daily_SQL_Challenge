
INSERT INTO orders_raw VALUES

-- Empty strings instead of NULL
(9, 109, '', '', ''),

-- Only delimiters
(10, 110, ',,,', ',,,', ',,,'),

-- Mixed NULL + values
(11, 111, 'P17,P18', NULL, '1700,1800'),

-- Prices missing in between
(12, 112, 'P19,P20,P21', '1,2,3', '1900,,2100'),

-- Non-numeric quantities
(13, 113, 'P22,P23', 'two,3', '2200,2300'),

-- Non-numeric prices
(14, 114, 'P24,P25', '1,2', 'abc,2500'),

-- Extra spaces + inconsistent commas
(15, 115, '  P26  ,P27 ,  P28 ', ' 1 ,2, 3 ', ' 2600, 2700 ,2800 '),

-- Leading and trailing commas
(16, 116, ',P29,P30,', ',1,2,', ',2900,3000,'),

-- Huge list (performance test)
(17, 117, 
 'P31,P32,P33,P34,P35,P36,P37,P38,P39,P40',
 '1,2,3,4,5,6,7,8,9,10',
 '3100,3200,3300,3400,3500,3600,3700,3800,3900,4000'),

-- Completely mismatched counts
(18, 118, 'P41,P42', '1', '4100,4200,4300'),

-- Duplicate delimiters + random text
(19, 119, 'P43,,P44,xyz', '1,,2,abc', '4300,,4400,xyz'),

-- Negative values (edge case)
(20, 120, 'P45,P46', '-1,2', '-4500,4600'),

-- Decimal quantities and prices
(21, 121, 'P47,P48', '1.5,2.5', '4700.75,4800.25'),

-- Special characters
(22, 122, 'P@49,P#50', '1,2', '4900,5000'),

-- Duplicate full rows
(23, 123, 'P51,P52', '1,2', '5100,5200'),
(23, 123, 'P51,P52', '1,2', '5100,5200'),

-- Only one column filled
(24, 124, 'P53,P54', NULL, NULL),

-- Random order mismatch
(25, 125, 'P55,P56,P57', '3,1,2', '5700,5500,5600');

