 DROP TABLE IF EXISTS events;

CREATE TABLE events (
    user_id INT,
    event_time TIMESTAMP,
    event_type VARCHAR(50)
);
