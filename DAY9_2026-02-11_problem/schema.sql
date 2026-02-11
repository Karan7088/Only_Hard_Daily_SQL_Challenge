drop table IF EXISTS USERS;
drop table IF EXISTS transactions;
drop table IF EXISTS device_logins;
drop table IF EXISTS fraud_alerts;

 
 CREATE TABLE users (
    user_id INT PRIMARY KEY,
    created_at TIMESTAMP
);

CREATE TABLE transactions (
    txn_id VARCHAR(20),
    sender_id INT,
    receiver_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    txn_time TIMESTAMP
);

CREATE TABLE device_logins (
    user_id INT,
    device_id VARCHAR(20),
    login_time TIMESTAMP
);
CREATE TABLE fraud_alerts (
    user_id INT,
    alert_time TIMESTAMP
);

