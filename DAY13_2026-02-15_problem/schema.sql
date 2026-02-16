DROP TABLE IF EXISTS inventory_events;

CREATE TABLE inventory_events (
    event_id BIGINT PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    event_time DATETIME NOT NULL,
    event_type VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    reference_id BIGINT NULL
);