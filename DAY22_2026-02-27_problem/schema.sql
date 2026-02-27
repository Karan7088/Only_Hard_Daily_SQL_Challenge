CREATE TABLE events (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_type VARCHAR(50), -- 'view', 'cart', 'purchase'
    product_id INT,
    event_time DATETIME
);