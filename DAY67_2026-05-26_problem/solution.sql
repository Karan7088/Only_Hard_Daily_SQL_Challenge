 WITH base AS (
    SELECT o.*,
           p.start_time,
           IFNULL(
               p.end_time,
               MAX(end_time) OVER ()
           ) AS end_time,

           p.correct_price,
           p.charged_price,

           COUNT(*) OVER (
               PARTITION BY customer_id
           ) AS cnt,

           ROW_NUMBER() OVER (
               PARTITION BY customer_id, start_time, end_time
           ) AS rn2

    FROM orders o
    LEFT JOIN product_price_history p
           ON p.product_id = o.product_id
          AND order_time BETWEEN p.start_time
                              AND p.end_time
          AND p.price_status = 'GLITCH'

    WHERE charged_price IS NOT NULL
)

SELECT customer_id,
       product_id,

       cnt AS order_placed,

       SUM(correct_price * quantity) AS total_expected_amount,

       SUM(charged_price * quantity) AS total_paid_amount,

       SUM(correct_price * quantity)
       -
       SUM(charged_price * quantity) AS total_loss,

       COUNT(
           CASE
               WHEN rn2 = 1 THEN 1
           END
       ) OVER (
           PARTITION BY customer_id
       ) AS abuse_sessions,

       CASE
           WHEN cnt >= 3
             OR SUM(correct_price * quantity)
                -
                SUM(charged_price * quantity) >= 1500
           THEN 'HIGH'

           ELSE 'MEDIUM'
       END AS risk_level

FROM base

WHERE cnt >= 2

GROUP BY 1,2,3;
