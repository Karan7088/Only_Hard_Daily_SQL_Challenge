 DROP TABLE IF EXISTS ride_requests;
DROP TABLE IF EXISTS driver_events;

CREATE TABLE ride_requests (
    request_id INT,
    city VARCHAR(50),
    request_time DATETIME
);

CREATE TABLE driver_events (
    event_id INT,
    driver_id INT,
    city VARCHAR(50),
    event_time DATETIME,
    status VARCHAR(20) -- ONLINE / OFFLINE
);

