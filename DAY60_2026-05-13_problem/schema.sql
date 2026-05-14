 DROP TABLE IF EXISTS account_events;

CREATE TABLE account_events (
    event_id INT PRIMARY KEY,
    account_id INT,
    event_time DATETIME,
    event_type VARCHAR(30),
    amount DECIMAL(10,2),
    reference_id VARCHAR(50),
    status VARCHAR(20)
);

