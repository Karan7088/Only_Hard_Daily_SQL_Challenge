 WITH team_match_outcomes AS (

    SELECT *,
           CASE
               WHEN team_a_score > team_b_score
               THEN team_a
               ELSE team_b
           END AS winning_team,

           CASE
               WHEN team_a_score > team_b_score
               THEN team_b
               ELSE team_a
           END AS losing_team,

           CASE
               WHEN team_a_score = team_b_score
               THEN team_a
           END AS draw_team_1,

           CASE
               WHEN team_a_score = team_b_score
               THEN team_b
           END AS draw_team_2,

           CASE
               WHEN team_a_score > team_b_score
               THEN team_a_score
               ELSE team_b_score
           END AS winning_team_score,

           CASE
               WHEN team_a_score > team_b_score
               THEN team_b_score
               ELSE team_a_score
           END AS losing_team_score,

           CASE
               WHEN team_a_score = team_b_score
               THEN team_a_score
           END AS draw_team_1_score,

           CASE
               WHEN team_a_score = team_b_score
               THEN team_b_score
           END AS draw_team_2_score

    FROM tournament_matches
    ORDER BY team_a
),

team_level_matches AS (

    SELECT match_id,
           winning_team AS team,
           match_date,
           1 AS is_win,
           3 AS points_earned,
           winning_team_score AS goals_scored,
           losing_team_score AS goals_conceded
    FROM team_match_outcomes

    UNION

    SELECT match_id,
           losing_team,
           match_date,
           -1,
           0,
           losing_team_score,
           winning_team_score
    FROM team_match_outcomes

    UNION

    SELECT match_id,
           draw_team_1,
           match_date,
           0,
           1,
           draw_team_1_score,
           draw_team_1_score
    FROM team_match_outcomes
    WHERE draw_team_1 IS NOT NULL

    UNION

    SELECT match_id,
           draw_team_2,
           match_date,
           0,
           1,
           draw_team_2_score,
           draw_team_1_score
    FROM team_match_outcomes
    WHERE draw_team_2 IS NOT NULL

    ORDER BY 1,2
),

deduplicated_team_matches AS (

    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY team, match_date
               ORDER BY match_id
           ) AS duplicate_match_rank

    FROM team_level_matches
),

team_match_sequence AS (

    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY team
               ORDER BY match_date
           ) AS match_sequence_no

    FROM deduplicated_team_matches

    WHERE duplicate_match_rank = 1

    ORDER BY 2,3
),

rolling_3_match_metrics AS (

    SELECT *,
           MAX(match_sequence_no) OVER (
               PARTITION BY team
           ) AS total_matches,

           SUM(points_earned) OVER (
               PARTITION BY team
               ORDER BY match_date
               ROWS BETWEEN 2 PRECEDING
               AND CURRENT ROW
           ) AS rolling_3_match_points,

           SUM(goals_scored) OVER (
               PARTITION BY team
               ORDER BY match_date
               ROWS BETWEEN 2 PRECEDING
               AND CURRENT ROW
           ) AS rolling_3_match_goals_scored,

           SUM(goals_conceded) OVER (
               PARTITION BY team
               ORDER BY match_date
               ROWS BETWEEN 2 PRECEDING
               AND CURRENT ROW
           ) AS rolling_3_match_goals_conceded

    FROM team_match_sequence
),

team_momentum_summary AS (

    SELECT team,
           3 AS early_matches,
           3 AS late_matches,

           IFNULL(
               (
                   SELECT rolling_3_match_points
                   FROM rolling_3_match_metrics
                   WHERE match_sequence_no = 3
                     AND team = a.team
               ),
               0
           ) AS early_points,

           IFNULL(
               (
                   SELECT rolling_3_match_points
                   FROM rolling_3_match_metrics
                   WHERE match_sequence_no = total_matches
                     AND team = a.team
               ),
               0
           ) AS late_points,

           IFNULL(
               (
                   SELECT rolling_3_match_goals_scored
                   FROM rolling_3_match_metrics
                   WHERE match_sequence_no = 3
                     AND team = a.team
               ),
               0
           )
           -
           IFNULL(
               (
                   SELECT rolling_3_match_goals_conceded
                   FROM rolling_3_match_metrics
                   WHERE match_sequence_no = 3
                     AND team = a.team
               ),
               0
           ) AS early_score_diff,

           IFNULL(
               (
                   SELECT rolling_3_match_goals_scored
                   FROM rolling_3_match_metrics
                   WHERE match_sequence_no = total_matches
                     AND team = a.team
               ),
               0
           )
           -
           IFNULL(
               (
                   SELECT rolling_3_match_goals_conceded
                   FROM rolling_3_match_metrics
                   WHERE match_sequence_no = total_matches
                     AND team = a.team
               ),
               0
           ) AS late_score_diff

    FROM rolling_3_match_metrics a

    WHERE total_matches >= 6
)

SELECT *,

       CASE
           WHEN early_points - late_points >= 6
            AND late_score_diff < early_score_diff
           THEN 'MOMENTUM_DROP'

           WHEN late_points - early_points >= 6
            AND late_score_diff > early_score_diff
           THEN 'MOMENTUM_GAIN'

           ELSE 'CONSISTENT'
       END AS momentum_status

FROM team_momentum_summary

GROUP BY 1,2,3,4,5,6,7,8;
