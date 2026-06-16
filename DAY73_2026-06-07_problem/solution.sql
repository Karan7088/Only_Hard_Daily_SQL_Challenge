 WITH base AS
(
    SELECT
        p.*,
        d.sale_date,
        d.units_sold,
        d.revenue,
        CASE
            WHEN launch_date > sale_date
                 AND sale_date >= DATE_SUB(launch_date, INTERVAL 30 DAY)
            THEN 1

            WHEN launch_date <= sale_date
                 AND sale_date <= DATE_ADD(launch_date, INTERVAL 30 DAY)
            THEN 0

            ELSE -1
        END AS st
    FROM daily_sales d
    LEFT JOIN product_launches p
        ON d.product_id = p.impacted_product_id
    WHERE launch_id IS NOT NULL
),

cte AS
(
    SELECT
        launch_id,
        impacted_product_id,
        new_product_id,
        launch_date,

        SUM(
            CASE
                WHEN st = 0 THEN units_sold
            END
        ) OVER(PARTITION BY launch_id, st) AS post_launch_units,

        SUM(
            CASE
                WHEN st = 0 THEN revenue
            END
        ) OVER(PARTITION BY launch_id, st) AS post_sales,

        SUM(
            CASE
                WHEN st = 1 THEN units_sold
            END
        ) OVER(PARTITION BY launch_id, st) AS pre_launch_units,

        SUM(
            CASE
                WHEN st = 1 THEN revenue
            END
        ) OVER(PARTITION BY launch_id, st) AS pre_sales,

        ROW_NUMBER() OVER(PARTITION BY launch_id) AS rn

    FROM base
),

cte2 AS
(
    SELECT
        launch_id,
        impacted_product_id,
        new_product_id,
        launch_date,
        rn,

        MAX(post_sales)
            OVER(PARTITION BY launch_id) AS post_sales,

        MAX(post_launch_units)
            OVER(PARTITION BY launch_id) AS post_launch_units,

        MAX(pre_launch_units)
            OVER(PARTITION BY launch_id) AS pre_launch_units,

        MAX(pre_sales)
            OVER(PARTITION BY launch_id) AS pre_sales

    FROM cte
)

SELECT
    launch_id,
    impacted_product_id,
    new_product_id,
    launch_date,

    COALESCE(pre_launch_units, 0) AS pre_launch_units,

    post_launch_units,

    ROUND(
        (post_launch_units - pre_launch_units)
        / pre_launch_units * 100.0,
        2
    ) AS unit_change_pct,

    IFNULL(pre_sales, 0) AS pre_sales,

    COALESCE(post_sales, 0) AS post_sales,

    ROUND(
        (post_sales - pre_sales)
        / pre_sales * 100.0,
        2
    ) AS revenue_change_pct,

    CASE
        WHEN pre_launch_units = 0
             OR pre_launch_units IS NULL
        THEN 'INSUFFICIENT_PRE_DATA'

        WHEN ROUND(
                (post_launch_units - pre_launch_units)
                / pre_launch_units * 100.0,
                2
             ) <= -40
        THEN 'SEVERE_CANNIBALIZATION'

        WHEN ROUND(
                (post_launch_units - pre_launch_units)
                / pre_launch_units * 100.0,
                2
             ) > -40
         AND ROUND(
                (post_launch_units - pre_launch_units)
                / pre_launch_units * 100.0,
                2
             ) <= -20
        THEN 'MODERATE_CANNIBALIZATION'

        WHEN ROUND(
                (post_launch_units - pre_launch_units)
                / pre_launch_units * 100.0,
                2
             ) > 0
        THEN 'GROWTH_AFTER_LAUNCH'

        ELSE 'NO_CANNIBALIZATION'
    END AS cannibalization_status

FROM cte2
WHERE rn = 1;
