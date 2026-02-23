💀 Day 17 – Revenue Growth Islands (Gap & Island Advanced SQL)

📅 Date: 2026-02-22
🔥 Difficulty: Hard
🧠 Concepts Used: CTE, Window Functions, LAG(), Gap & Island, Conditional Grouping, Aggregations

📌 Problem Statement

Given a sales table:

sales
------
sale_id       INT
customer_id   INT
sale_date     DATE
amount        DECIMAL(10,2)

Your task is to:

Calculate monthly revenue

Identify months where revenue strictly increased compared to previous month

Detect all growth streak islands

Return:

streak_id

start_month

end_month

streak_length

Also calculate:

Longest streak

Total streaks

Average streak length