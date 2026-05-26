 DROP TABLE IF EXISTS employee_meetings;

CREATE TABLE employee_meetings (
    meeting_id INT,
    employee_id INT,
    meeting_title VARCHAR(100),
    start_time DATETIME,
    end_time DATETIME
);

