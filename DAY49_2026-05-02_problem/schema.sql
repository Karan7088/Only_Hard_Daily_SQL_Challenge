 DROP TABLE IF EXISTS flights;

CREATE TABLE flights (
    flight_id INT,
    source VARCHAR(10),
    destination VARCHAR(10),
    departure_time DATETIME,
    arrival_time DATETIME,
    price INT
);
