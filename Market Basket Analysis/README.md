📅 Day 43 —Only Hard Daily SQL Challenge

Date: April 26, 2026 (Sunday)

🛒 Market Basket Analysis (SQL)

📌 Problem Statement

Given a set of transactions and their associated products, the goal is to identify frequently co-purchased product pairs.

Each transaction may contain multiple products, and the objective is to find product combinations that occur together frequently across transactions.

🎯 Objective
Identify pairs of products bought together
Calculate frequency of co-occurrence
Filter only significant pairs (based on a threshold)
Handle real-world data issues like duplicates and large baskets
📊 Dataset Overview
1. Transactions Table

Contains high-level transaction details:

txn_id → Unique transaction ID
user_id → Customer identifier
txn_date → Date of purchase
2. Transaction Items Table

Contains product-level details:

txn_id → Transaction reference
product_id → Product purchased
quantity → Number of units
⚠️ Key Challenges
1. 🔁 Duplicate Entries
Same product may appear multiple times in a transaction
Example: (txn_id = 8, product_id = 101) appears multiple times
Impact: Can falsely inflate co-occurrence counts

👉 Must deduplicate at (txn_id, product_id) level

2. 💥 Combinatorial Explosion

A transaction with N products generates:

2
N×(N−1)
	​


pairs

Example:
5 products → 10 pairs
100 products → 4950 pairs

👉 Large baskets can heavily impact performance

3. 🔄 Symmetric Pairs
(101,102) and (102,101) represent the same combination

👉 Must enforce ordering:

Always store as (smaller_id, larger_id)
4. 🧊 Sparse & Noisy Data
Some transactions contain unrelated products
Example:
(106,107), (108)

👉 These create low-frequency noise pairs

5. ⚖️ Threshold Selection
Not all co-occurrences are meaningful

👉 Apply a minimum frequency threshold to:

Remove noise
Focus on strong associations
🧠 Business Interpretation

Frequent product pairs help in:

🛍️ Product Bundling
🎯 Recommendation Systems
📈 Cross-Selling Strategies
🏬 Store Layout Optimization
🧩 Rules to Consider Before Solving
✅ Data Preparation Rules
Remove duplicate (txn_id, product_id) entries
Ignore quantity for pair generation (presence matters, not count)
Ensure clean and consistent data
✅ Pair Generation Rules
Only generate unique combinations
Avoid self-pairing (A, A)
Enforce ordering constraint:
Always (A, B) where A < B
✅ Counting Rules
Count number of transactions where both products appear
Do NOT count:
Multiple occurrences within the same transaction
Each transaction contributes at most 1 to a pair
✅ Filtering Rules
Apply minimum support threshold (e.g., frequency > 2)
Remove weak and accidental pairings
✅ Performance Considerations
Avoid full Cartesian joins
Use deduplication early
Be cautious with large baskets
Optimize joins on indexed columns
📌 Edge Cases Covered
Duplicate product entries in same transaction
Large basket transactions (explosion risk)
Sparse transactions with unrelated items
Strong repeated co-occurrence patterns
Mixed baskets with both strong & weak pairs
🚀 Expected Outcome

The final output should provide:

product1	product2	frequency
101	102	High
103	104	Medium

👉 Only meaningful, high-frequency product pairs should appear

🧠 Interview Insight

This problem tests:

SQL join optimization
Handling real-world dirty data
Understanding of combinatorics
Analytical thinking in recommendation systems
💡 Pro Tip

This is a classic FAANG-style question where:

Basic logic is simple
But handling scale + edge cases is the real challenge
