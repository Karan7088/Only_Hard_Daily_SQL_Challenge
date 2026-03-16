  CREATE TABLE watch_sessions (
    session_id INT PRIMARY KEY,
    user_id INT,
    video_id INT,
    watch_time INT,
    video_length INT,
    watch_date DATE
);

CREATE TABLE video_engagement (
    video_id INT PRIMARY KEY,
    likes INT,
    comments INT,
    shares INT
);
