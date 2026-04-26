DROP TABLE IF EXISTS transaction_items;
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    txn_id INT,
    user_id INT,
    txn_date DATE
);

CREATE TABLE transaction_items (
    txn_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO transactions (txn_id, user_id, txn_date) VALUES
(1, 101, '2024-01-01'),
(2, 102, '2024-01-01'),
(3, 103, '2024-01-02'),
(4, 104, '2024-01-02'),
(5, 105, '2024-01-03'),
(6, 101, '2024-01-03'),
(7, 102, '2024-01-04'),
(8, 103, '2024-01-04'),
(9, 104, '2024-01-05'),
(10,105, '2024-01-05'),
(11,101, '2024-01-06'),
(12,102, '2024-01-06'),
(13,103, '2024-01-07'),
(14,104, '2024-01-07'),
(15,105, '2024-01-08');

INSERT INTO transaction_items (txn_id, product_id, quantity) VALUES

-- Strong pair: (101,102)
(1,101,1),(1,102,1),(1,103,1),
(2,101,1),(2,102,2),
(3,101,1),(3,102,1),(3,104,1),
(4,101,1),(4,102,1),

-- Strong pair: (103,104)
(5,103,1),(5,104,1),
(6,103,1),(6,104,2),
(7,103,1),(7,104,1),(7,105,1),

-- Mixed basket (explosion risk)
(8,101,1),(8,102,1),(8,103,1),(8,104,1),(8,105,1),

-- Noise + weak pairs
(9,106,1),(9,107,1),
(10,108,1),
(11,101,1),(11,109,1),
(12,102,1),(12,110,1),

-- Repeated strong co-occurrence
(13,101,1),(13,102,1),
(14,101,1),(14,102,1),
(15,101,1),(15,102,1),(15,103,1),

-- Duplicate-like edge case
(8,101,2),
(8,102,3),

-- Sparse transactions
(5,111,1),
(6,112,1),
(7,113,1),
(8,114,1);
