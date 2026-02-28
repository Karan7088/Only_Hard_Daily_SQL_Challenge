CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    user_id INT,
    txn_type VARCHAR(20),   -- 'credit', 'debit', 'reversal'
    amount DECIMAL(10,2),
    txn_time DATETIME
);