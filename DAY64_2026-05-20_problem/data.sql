  DROP TABLE IF EXISTS payment_attempts;

CREATE TABLE payment_attempts (
    txn_id INT,
    user_id INT,
    merchant_id VARCHAR(10),
    amount DECIMAL(10,2),
    txn_time DATETIME,
    status VARCHAR(20),
    failure_reason VARCHAR(50)
);

