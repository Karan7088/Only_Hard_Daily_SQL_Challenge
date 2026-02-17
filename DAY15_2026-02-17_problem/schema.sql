drop table if exists users;
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    country VARCHAR(50),
    risk_level ENUM('LOW','MEDIUM','HIGH'),
    created_at DATETIME
);
drop table if exists transactions;
CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    amount DECIMAL(12,2),
    status ENUM('SUCCESS','FAILED'),
    txn_time DATETIME,
    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);
