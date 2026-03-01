DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    join_date DATE
);

CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    amount INT,
    txn_date DATETIME
);