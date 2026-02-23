WITH RECURSIVE seq AS (
    
    -- 🔹 Base case: every number starts its own sequence
    SELECT  
        id,
        value,
        value        AS last_val,
        id           AS last_id,
        CAST(value AS CHAR(500)) AS path,
        1            AS length
    FROM numbers

    UNION ALL

    -- 🔹 Recursive case: extend increasing sequence
    SELECT  
        s.id,
        n.value,
        n.value      AS last_val,
        n.id         AS last_id,
        CONCAT(s.path, ' -> ', n.value) AS path,
        s.length + 1 AS length
    FROM seq s
    JOIN numbers n
        ON n.value > s.last_val     -- strictly increasing
       AND n.id > s.last_id         -- maintain order
)

-- 🔹 Get the longest sequence
SELECT path, length
FROM seq
ORDER BY length DESC
LIMIT 1;