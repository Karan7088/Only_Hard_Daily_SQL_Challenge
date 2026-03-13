CREATE TABLE robots (
robot_id INT,
robot_name VARCHAR(50)
);
CREATE TABLE tasks (
task_id INT,
robot_id INT,
start_time DATETIME,
end_time DATETIME,
zone VARCHAR(20)
);
