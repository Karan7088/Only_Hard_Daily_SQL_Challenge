 drop table if exists machine_logs;
create table  machine_logs (
  machine_id INT,
  user_id INT,
  start_time TIMESTAMP,
  end_time   TIMESTAMP
);