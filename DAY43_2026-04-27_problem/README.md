 📅 Day 43 – Only Hard Daily SQL Challenge

Date: 2026-04-27

💡 Problem Overview

This problem focuses on identifying pricing leakage in an order system by comparing the price charged to customers with the actual valid price from a historical pricing table.

In real-world systems, product prices change over time. When an order is placed, the correct price must be determined based on the effective price window at that exact timestamp. Any mismatch between the charged price and the valid historical price leads to revenue leakage or overcharge.

🧠 Core Objective

The goal is to:

Map each order to the correct price version based on time
Detect mismatches between:
PRICE_CHARGED (what customer paid)
ACTUAL_PRICE (what should have been charged)
Calculate the leakage amount
Filter only the relevant discrepancies
🧩 Key Concepts Involved
1. Slowly Changing Data (Time-based joins)

The product pricing table maintains historical records using:

START_TIME → when a price becomes active
END_TIME → when it expires

For each order:

The correct price is the one where:
Order time ≥ start time
Order time < end time (or end time is NULL)
2. Handling Multiple Matches (De-duplication)

There may be multiple overlapping or incorrectly maintained price records.
To ensure correctness:

A ranking mechanism is used to prioritize the latest valid price
The most recent price (based on start time) is selected
3. Row Selection Logic

To avoid duplicates:

Each order is grouped by product, price, and timestamp
Only the top-ranked (most relevant) record is retained
4. Leakage Calculation Logic

Leakage represents the financial impact:

Positive leakage → Undercharging (loss)
Negative leakage → Overcharging (customer paid extra)

Formula concept:

Leakage = (Actual Price - Charged Price) × Quantity

Special handling:

If either price is missing → mark as "IGNORE"
Ensures only meaningful comparisons are considered
5. Filtering Business-Relevant Records

Final output only includes:

Records where charged price ≠ actual price
Ensures focus on problematic transactions only
⚙️ Business Rules
Always pick the latest valid price for a given order timestamp
Ignore records where:
Pricing data is incomplete
No valid price window exists
Only highlight price mismatches
Maintain strict time-bound logic:
Inclusive start time
Exclusive end time
Treat NULL END_TIME as currently active price
📊 Output Interpretation

Each row represents a pricing discrepancy with:

Order details
Charged vs actual price
Calculated leakage

This helps in:

Identifying revenue loss
Detecting system pricing bugs
Auditing historical pricing accuracy
🚀 Real-World Applications
E-commerce pricing validation
Billing system audits
Revenue assurance systems
Telecom/Subscription billing
Dynamic pricing platforms
🔥 Why This Problem is “Hard”
Combines time-based joins + window functions
Requires correct deduplication strategy
Handles edge cases like NULLs and overlaps
Involves business logic interpretation, not just SQL
