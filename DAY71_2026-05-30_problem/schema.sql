 DROP TABLE IF EXISTS inventory_events;

CREATE TABLE inventory_events (
    event_id INT PRIMARY KEY,
    product_id VARCHAR(20),
    warehouse_id VARCHAR(20),
    event_time DATETIME,
    event_type VARCHAR(30),
    quantity INT,
    reference_id VARCHAR(30)
);


