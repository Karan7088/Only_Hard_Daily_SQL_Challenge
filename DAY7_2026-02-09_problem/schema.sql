drop table if exists cpu_usage;
CREATE TABLE cpu_usage (
    usage_date DATE,
    user_id INT,
    cpu_minutes INT
);