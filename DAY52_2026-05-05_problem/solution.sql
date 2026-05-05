 WITH RECURSIVE hierarchy_cte AS (
    SELECT 
        *,
        1 AS lvl,
        CAST(emp_id AS CHAR(1000)) AS path,
        0 AS cycle
    FROM employee_hierarchy  
    WHERE manager_id IS NOT NULL

    UNION 

    SELECT 
        c.emp_id,
        CASE 
            WHEN e.manager_id IS NULL THEN NULL 
            ELSE e.manager_id 
        END AS manager_id,
        lvl + 1 AS lvl,
        CONCAT(path, ',', e.manager_id) AS path,
        CASE 
            WHEN FIND_IN_SET(e.manager_id, path) > 0 
                 OR e.manager_id = e.emp_id 
            THEN 1 ELSE 0 
        END AS cycle
    FROM hierarchy_cte c
    INNER JOIN employee_hierarchy e 
        ON c.manager_id = e.emp_id
       AND c.cycle = 0 
       AND c.manager_id IS NOT NULL
),

metrics_cte AS (
    SELECT 
        emp_id,
        cycle,
        MAX(manager_id) OVER (PARTITION BY emp_id) AS manager_id,
        IFNULL(
            MIN(CASE WHEN emp_id = manager_id THEN lvl END) 
                OVER (PARTITION BY emp_id, manager_id),
            MAX(lvl) OVER (PARTITION BY emp_id, manager_id)
        ) AS chain_length,
        ROW_NUMBER() OVER (PARTITION BY emp_id, manager_id ORDER BY cycle DESC) AS rn,
        MAX(cycle) OVER (PARTITION BY emp_id) AS is_cycle,
        ROW_NUMBER() OVER (PARTITION BY emp_id) AS rn2
    FROM hierarchy_cte
),

final_metrics AS (
    SELECT 
        *,
        MAX(chain_length) OVER (PARTITION BY emp_id) AS chain_length2,
        COUNT(*) OVER (PARTITION BY emp_id, manager_id) AS cnt
    FROM metrics_cte
    WHERE rn = 1 OR rn2 = 1
)

SELECT 
    emp_id,
    CASE 
        WHEN manager_id NOT IN (
            SELECT emp_id 
            FROM employee_hierarchy 
            WHERE manager_id IS NULL
        ) THEN NULL 
        ELSE manager_id 
    END AS root_manager,
    chain_length2 AS chain_length,
    CASE 
        WHEN manager_id NOT IN (
            SELECT emp_id 
            FROM employee_hierarchy 
            WHERE manager_id IS NULL
        )
        AND manager_id IN (
            SELECT DISTINCT emp_id 
            FROM employee_hierarchy
        ) 
        THEN 1 
        ELSE is_cycle 
    END AS is_cycle
FROM final_metrics 
WHERE rn2 = 1

UNION 

SELECT 
    emp_id,
    emp_id,
    1,
    0 
FROM employee_hierarchy a 
WHERE NOT EXISTS (
    SELECT 1 
    FROM hierarchy_cte 
    WHERE a.emp_id = emp_id
) 
AND manager_id IS NULL

ORDER BY 1;
