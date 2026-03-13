 SELECT 
    a.robot_id,
    a.task_id AS task1,
    b.task_id AS task2,
    b.start_time AS conflict_start,
    a.end_time AS conflict_end
FROM tasks a
INNER JOIN tasks b
    ON a.robot_id = b.robot_id
   AND a.task_id < b.task_id
   AND a.end_time > b.start_time
ORDER BY 
    a.robot_id,
    a.task_id;
