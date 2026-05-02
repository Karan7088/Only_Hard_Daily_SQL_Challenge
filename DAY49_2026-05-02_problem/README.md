📌 DAY 49 — Only Hard SQL Challenge (Extreme Level)
🧠 Problem Statement

You are given a dataset of flight routes with the following attributes:

source → starting city
destination → ending city
price → cost of the flight
departure_time
arrival_time
🎯 Objective

For every (source → destination) pair, determine:

✅ The minimum total cost path
✅ The earliest possible arrival time
✅ The complete path taken
⚠️ Constraints & Rules
1. ⏱️ Connection Time Rule

A valid connection must satisfy:

Next flight’s departure time ≥ previous flight’s arrival time + 30 minutes

2. 🚫 No Cycles Allowed

A city cannot be revisited in the same path.

3. 🧩 Multi-hop Paths Allowed

You can take:

Direct flights
2-hop, 3-hop, … N-hop paths
4. 💰 Optimization Priority (VERY IMPORTANT)

Paths must be selected based on:

Lowest total cost
If tie → Minimum number of hops
If tie → Earliest departure time
5. ✅ Valid Flights Only

Each individual flight must satisfy:

departure_time + 30 min ≤ arrival_time

(ensures logically valid flight duration)

🧠 Approach

This problem is essentially:

Graph traversal + constraint validation + optimization — implemented in SQL

🔁 Step 1: Recursive Path Building

We generate all possible valid paths using a recursive CTE:

Start with direct flights
Recursively join next valid flights
Enforce:
30-minute connection gap
No revisiting nodes
🚫 Step 2: Cycle Prevention

We track visited nodes using a path string (lst) and prevent revisits using:

FIND_IN_SET() to check if destination already exists in path
🔗 Step 3: Path Construction
Maintain path as comma-separated string

Convert to readable format using:

A->B->C->D
📊 Step 4: Ranking Best Paths

For each (source, destination):

We rank paths using:

ORDER BY cost, lvl, departure_time

Where:

cost = total price
lvl = number of hops
departure_time = tie-breaker
🏆 Step 5: Final Selection

Pick:

ROW_NUMBER() = 1

→ gives the optimal path

🧾 Solution Query (Formatted)
WITH RECURSIVE route_builder AS (
    SELECT 
        SOURCE,
        DESTINATION,
        PRICE,
        DEPARTURE_TIME,
        ARRIVAL_TIME,
        CONCAT(CAST(SOURCE AS CHAR(1000)), ',', CAST(DESTINATION AS CHAR(1000))) AS LST,
        PRICE AS COST,
        1 AS LVL
    FROM flights
    WHERE departure_time + INTERVAL 30 MINUTE <= arrival_time

    UNION

    SELECT 
        RB.SOURCE,
        F.DESTINATION,
        F.PRICE,
        F.DEPARTURE_TIME,
        F.ARRIVAL_TIME,
        CONCAT(LST, ',', F.DESTINATION) AS LST,
        COST + F.PRICE,
        LVL + 1
    FROM route_builder RB
    INNER JOIN flights F 
        ON F.SOURCE = RB.DESTINATION
       AND FIND_IN_SET(F.DESTINATION, LST) = 0
       AND F.DEPARTURE_TIME >= (RB.ARRIVAL_TIME + INTERVAL 30 MINUTE)
       AND F.DEPARTURE_TIME + INTERVAL 30 MINUTE <= F.ARRIVAL_TIME
),

ranked_paths AS (
    SELECT 
        SOURCE,
        DESTINATION,
        COST AS TOTAL_COST,
        ARRIVAL_TIME AS DESTINATION_TIME,
        LST,
        ROW_NUMBER() OVER (
            PARTITION BY SOURCE, DESTINATION 
            ORDER BY COST, LVL, DEPARTURE_TIME
        ) AS RN
    FROM route_builder
)

SELECT 
    SOURCE,
    DESTINATION,
    TOTAL_COST,
    DESTINATION_TIME,
    REPLACE(LST, ',', '->') AS PATH
FROM ranked_paths
WHERE RN = 1;
🔍 Query Explanation
🔹 route_builder CTE
Builds all possible valid routes
Tracks:
Total cost (cost)
Path (lst)
Depth (lvl)
Ensures:
No cycles
Valid connection gaps
🔹 ranked_paths CTE
Assigns rank per (source, destination)
Uses:
cost → primary
lvl → secondary
departure_time → tie-breaker
🔹 Final SELECT
Filters best path (rn = 1)
Formats path string
🚀 Key Learnings
Recursive CTE can simulate graph traversal
SQL can solve shortest path problems with constraints
Ordering logic is critical in optimization problems
Handling edge cases (cycles, invalid connections) is essential
🏁 Final Thoughts

This is not a typical SQL problem — it combines:

Graph theory
Time-based constraints
Optimization strategies

👉 Solving this correctly demonstrates top-tier SQL problem-solving ability 
