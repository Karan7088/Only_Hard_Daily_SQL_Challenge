DROP TABLE IF EXISTS badge_logs;
DROP TABLE IF EXISTS vpn_logs;
DROP TABLE IF EXISTS meeting_room_logs;

CREATE TABLE badge_logs (
    log_id INT,
    employee_id INT,
    office_city VARCHAR(30),
    event_type VARCHAR(20),
    event_time DATETIME
);

CREATE TABLE vpn_logs (
    log_id INT,
    employee_id INT,
    login_city VARCHAR(30),
    event_time DATETIME
);

CREATE TABLE meeting_room_logs (
    log_id INT,
    employee_id INT,
    room_id VARCHAR(20),
    office_city VARCHAR(30),
    event_time DATETIME
);
