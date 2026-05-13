 DROP TABLE IF EXISTS elevator_logs;

CREATE TABLE elevator_logs (
    log_id INT,
    elevator_id VARCHAR(10),
    log_time DATETIME,
    floor_no INT,
    passenger_count INT
);

