drop table if exists sensors;
drop table if exists sensor_readings;
CREATE TABLE sensors (
    sensor_id INT PRIMARY KEY,
    location VARCHAR(50) NOT NULL,
    install_date DATE NOT NULL
);

CREATE TABLE sensor_readings (
    reading_id INT PRIMARY KEY,
    sensor_id INT NOT NULL,
    reading_time DATETIME NOT NULL,
    temperature DECIMAL(5,2) ,
    FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id)
);

