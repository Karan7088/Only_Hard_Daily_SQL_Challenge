CREATE TABLE user (
    login_id INT PRIMARY KEY,
    user_id INT,
    login_time DATETIME,
    ip_address VARCHAR(50),
    device_id VARCHAR(50)
);