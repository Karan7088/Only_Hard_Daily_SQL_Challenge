 WITH cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY product_id, price, start_time, end_time 
            ORDER BY start_time
        ) AS dup_rn,

        ROW_NUMBER() OVER (
            PARTITION BY product_id 
            ORDER BY start_time
        ) AS rn,

        COUNT(*) OVER (
            PARTITION BY product_id, price, start_time, end_time
        ) AS dup,

        COUNT(*) OVER (
            PARTITION BY product_id
        ) AS cnt,

        LAG(end_time) OVER (
            PARTITION BY product_id 
            ORDER BY start_time
        ) AS lg_ed_time,

        LAG(start_time) OVER (
            PARTITION BY product_id 
            ORDER BY start_time
        ) AS lg_st_time,

        LAG(price) OVER (
            PARTITION BY product_id 
            ORDER BY start_time
        ) AS lg_prc

    FROM price_logs
    ORDER BY 1, 3, 4
),

cte2 AS (
    SELECT *,
        CASE 
            WHEN 
                (dup = 1 OR (dup > 1 AND dup_rn = 1)) 
                AND (lg_ed_time > start_time AND end_time >= lg_ed_time)
                OR (lg_st_time < start_time AND end_time < lg_ed_time OR lg_ed_time IS NULL)
            THEN 'OVERLAP'

            WHEN dup > 1 
                 AND start_time = lg_st_time 
                 AND end_time = lg_ed_time 
            THEN 'DUPLICATE'

            WHEN start_time > lg_ed_time 
            THEN 'GAP'

            ELSE -1  
        END AS issue_type

    FROM cte
    WHERE cnt > 1
      AND CASE 
            WHEN 
                (dup = 1 OR (dup > 1 AND dup_rn = 1))  
                AND (lg_ed_time > start_time AND end_time >= lg_ed_time)
                OR (lg_st_time < start_time AND end_time < lg_ed_time)
            THEN 'OVERLAP'

            WHEN dup > 1 
                 AND start_time = lg_st_time 
                 AND end_time = lg_ed_time 
                 OR lg_ed_time IS NULL 
                 OR lg_st_time IS NULL 
            THEN 'DUPLICATE'

            WHEN start_time > lg_ed_time 
            THEN 'GAP'

            ELSE -1  
        END != -1

      AND (
            (cnt > 1 AND rn > 1 AND lg_ed_time IS NOT NULL)
         OR (cnt > 1 AND rn > 1 AND lg_ed_time IS NULL)
      )
)

SELECT 
    product_id,
    issue_type,

    CASE 
        WHEN issue_type = 'overlap' THEN start_time 
        WHEN issue_type = 'gap' THEN lg_ed_time 
        ELSE start_time 
    END AS issue_start,

    CASE 
        WHEN issue_type = 'overlap' 
             AND lg_ed_time IS NOT NULL 
             AND lg_ed_time <= end_time 
        THEN lg_ed_time 

        WHEN issue_type = 'gap' 
        THEN start_time 

        ELSE end_time 
    END AS issue_end

FROM cte2;
