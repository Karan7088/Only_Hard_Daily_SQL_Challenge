DROP TABLE IF EXISTS delivery_events;

CREATE TABLE delivery_events (
    order_id        INT,
    event_type      VARCHAR(50),
    event_time      DATETIME,
    rider_id        INT,
    city            VARCHAR(50)
);
