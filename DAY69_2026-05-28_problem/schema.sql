drop table if exists transactions;
CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    customer_id INT,
    txn_time DATETIME,
    amount INT
);
