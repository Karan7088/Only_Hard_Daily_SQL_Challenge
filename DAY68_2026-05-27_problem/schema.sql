DROP TABLE IF EXISTS tournament_matches;
CREATE TABLE tournament_matches (
    match_id INT,
    match_date DATE,
    team_a VARCHAR(20),
    team_b VARCHAR(20),
    team_a_score INT,
    team_b_score INT
);

