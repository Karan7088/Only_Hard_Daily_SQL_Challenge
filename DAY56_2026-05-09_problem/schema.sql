 DROP TABLE IF EXISTS score_events;

CREATE TABLE score_events (
    event_id INT,
    player_id INT,
    event_time DATETIME,
    score_change INT
);

