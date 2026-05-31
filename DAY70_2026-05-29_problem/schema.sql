DROP TABLE IF EXISTS payment_attempts;
DROP TABLE IF EXISTS order_events;

CREATE TABLE payment_attempts (
    attempt_id INT PRIMARY KEY,
    order_id INT,
    user_id INT,
    gateway_id VARCHAR(10),
    attempt_time DATETIME,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    failure_reason VARCHAR(100)
);

CREATE TABLE order_events (
    event_id INT PRIMARY KEY,
    order_id INT,
    event_time DATETIME,
    event_type VARCHAR(30)
);

