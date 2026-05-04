  DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    user_id INT,
    txn_id INT PRIMARY KEY,
    amount INT
);

