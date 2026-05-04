 WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY amount) AS rn,
           COUNT(*) OVER (PARTITION BY user_id) AS cnt
    FROM transactions
)

SELECT *,
       CASE 
           WHEN cnt % 2 = 0 THEN (
               SELECT ROUND(SUM(amount) / 2)
               FROM cte
               WHERE (rn = (cnt / 2) OR rn = (cnt / 2) + 1)
                 AND user_id = a.user_id
           )
           ELSE (
               SELECT amount
               FROM cte
               WHERE rn = CEIL(a.cnt / 2)
                 AND user_id = a.user_id
           )
       END AS median,

       ABS(
           CASE 
               WHEN cnt % 2 = 0 THEN (
                   SELECT ROUND(SUM(amount) / 2)
                   FROM cte
                   WHERE (rn = (cnt / 2) OR rn = (cnt / 2) + 1)
                     AND user_id = a.user_id
               )
               ELSE (
                   SELECT amount
                   FROM cte
                   WHERE rn = CEIL(a.cnt / 2)
                     AND user_id = a.user_id
               )
           END - amount
       ) AS abs_dev

FROM cte a;
