 DROP TABLE IF EXISTS delivery_events;

CREATE TABLE delivery_events (
    event_id INT,
    order_id INT,
    event_time DATETIME,
    status VARCHAR(30)
);


