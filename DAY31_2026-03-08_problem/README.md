 📅 Day 31 — Hard
🚕 Uber Surge Pricing (SQL)

Date: March 8, 2026
Challenge: Day 31 of Daily SQL Challenge
Difficulty: Hard

🧠 Problem Overview

Ride-sharing platforms like Uber dynamically adjust ride prices using surge pricing when demand exceeds supply.

Your task is to compute the surge multiplier for each area in 5-minute time windows based on the ratio of ride requests to available drivers.

We are given two tables:

ride_requests
column	description
request_id	unique ride request id
area_id	location where the request was made
request_time	timestamp when the ride was requested
drivers_online
column	description
driver_id	unique driver id
area_id	driver’s current area
online_time	timestamp when the driver came online
🎯 Goal

For every area and every 5-minute window, compute:

column	meaning
area_id	location
window_start	start of the 5-minute window
total_requests	number of ride requests
total_drivers	number of drivers online
ratio	request-to-driver ratio
surge_multiplier	price multiplier applied
⏱ Time Window Logic

All data must be grouped into 5-minute windows.

Example windows:

window_start	covers
09:00	09:00 – 09:04
09:05	09:05 – 09:09
09:10	09:10 – 09:14

To generate these windows we:

1️⃣ Find minimum request time
2️⃣ Recursively add 5 minutes
3️⃣ Stop when we reach maximum request time

📊 Surge Pricing Rules

The surge multiplier depends on:

ratio = total_requests / total_drivers
Ratio	Surge Multiplier
≤ 1	1.0

1 and ≤2 | 1.5 |
2 and ≤3 | 2.0 |
3 | 3.0 |

Special Case

If:

total_drivers = 0

Then:

ratio = NULL
surge_multiplier = 3.0

Because demand exists but supply is zero.

🧮 How Each Column Is Computed
1️⃣ window_start

We generate 5-minute buckets using a recursive CTE.

Example:

09:00
09:05
09:10

These represent the start of each time window.

2️⃣ total_requests

Count ride requests inside each window.

Condition:

request_time >= window_start
AND request_time < window_end

Then:

COUNT(DISTINCT request_id)
3️⃣ total_drivers

Count drivers who came online inside the same window.

Condition:

online_time >= window_start
AND online_time < window_end

Then:

COUNT(DISTINCT driver_id)
4️⃣ ratio

Calculated as:

ratio = total_requests / total_drivers

If drivers are zero:

ratio = NULL
5️⃣ surge_multiplier

Computed using a CASE expression.

CASE
WHEN ratio <= 1 THEN 1.0
WHEN ratio <= 2 THEN 1.5
WHEN ratio <= 3 THEN 2.0
ELSE 3.0
END
🧩 Key SQL Concepts Used

This problem combines several advanced SQL techniques:

Recursive CTE

Generate time windows dynamically.

Window Functions

Used to determine window boundaries.

Time Range Joins

Match rows inside time intervals.

Aggregation

Compute request and driver counts.

Conditional Logic

Apply surge pricing rules.

⚠️ Common Pitfalls
1️⃣ Cartesian Explosion

Joining requests and drivers directly can create duplicate combinations.

Use:

COUNT(DISTINCT ...)
2️⃣ Missing Windows

Ensure windows are generated even if no drivers exist.

3️⃣ Division by Zero

Always handle:

drivers = 0
📌 Example Output
area_id	window_start	total_requests	total_drivers	ratio	surge_multiplier
101	09:00	5	2	2.5	2.0
101	09:05	2	1	2.0	1.5
102	09:00	3	1	3.0	2.0
102	09:05	1	1	1.0	1.0
103	09:00	2	0	NULL	3.0
104	09:10	1	1	1.0	1.0
105	09:00	8	1	8.0	3.0
🏁 Final Thoughts

This problem is considered Hard because it requires combining:

Recursive time generation

Window logic

Multi-table joins

Aggregations

Conditional pricing rules

It closely resembles real-world data engineering tasks used in ride-sharing platforms.

✅ Day 31 Completed — Hard SQL Challenge
