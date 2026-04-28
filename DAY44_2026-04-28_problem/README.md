📦 Refund Abuse Detection (Advanced SQL)
🧠 Problem Statement

You are given two tables:

orders → contains all customer purchases
refunds → contains refund transactions for some orders

Your task is to identify customers who are potential refund abusers based on behavioral patterns.

🎯 Objective

Detect customers who satisfy both conditions:

High Refund Ratio
At least 60% of their orders are refunded
Consecutive Refund Behavior
They have at least one pair of consecutive refund dates
i.e., difference between two refund dates = 1 day
🧾 Tables Overview
orders
Column	Description
order_id	Unique order identifier
customer_id	Customer identifier
product_id	Product identifier
order_date	Date of order
order_amount	Order value
refunds
Column	Description
refund_id	Unique refund identifier
order_id	Associated order
refund_date	Date of refund
refund_amount	Refunded value
⚠️ Rules & Edge Cases

Before solving, carefully consider:

1. Ignore Invalid Refunds
Refunds where refund_amount = 0 should be excluded
2. Left Join Required
Not all orders have refunds
Use LEFT JOIN to preserve total order count
3. Refund Ratio Calculation
refund_ratio = refunded_orders / total_orders
Must be ≥ 0.6
Ensure proper handling of NULLs
4. Consecutive Refund Detection
Use window functions:
LEAD(refund_date)
DATEDIFF
Identify if:
DATEDIFF(next_refund_date, current_refund_date) = 1
5. Customer-Level Aggregation
Metrics must be computed per customer
Avoid row-level filtering before aggregation
6. Window Functions Are Key

Use:

COUNT() OVER (PARTITION BY customer_id)
LEAD() OVER (...)
MIN() OVER (...)
🧩 Approach
Step 1: Join Orders & Refunds
Perform a LEFT JOIN
Filter out invalid refunds (refund_amount > 0)
Step 2: Compute Metrics Using Window Functions

For each customer:

Total orders
Total refunded orders
Refund date differences using LEAD
Step 3: Detect Consecutive Refunds
Compute date difference between consecutive refunds
Extract minimum difference per customer
If min_diff = 1 → has consecutive refunds
Step 4: Apply Filters

Keep only customers where:

refund_ratio ≥ 0.6
min_diff = 1
Step 5: Final Output

Return:

customer_id
total_orders
refunded_orders
refund_ratio
has_consecutive_refunds
✅ Expected Output Logic
customer_id	total_orders	refunded_orders	refund_ratio	has_consecutive_refunds
101	5	5	1.0	yes
103	5	3	0.6	yes
105	5	4	0.8	yes
🚫 Common Mistakes
❌ Using INNER JOIN (loses non-refunded orders)
❌ Including zero refund amounts
❌ Calculating ratio before aggregation
❌ Missing consecutive date logic
❌ Using GROUP BY too early instead of window functions
💡 Key Learnings
Advanced window function usage
Behavioral analytics using SQL
Handling edge cases in real datasets
Combining ratio + sequence detection
🔥 Difficulty Level

Hard / FAANG-Level SQL

🚀 Use Cases
Fraud detection systems
E-commerce refund monitoring
Customer risk profiling
Financial anomaly detection 
