DROP TABLE IF EXISTS hashtag_events;

CREATE TABLE hashtag_events (
    event_id INT,
    user_id INT,
    hashtag VARCHAR(50),
    event_time DATETIME
);

