DAY 63 - Only Hard Daily SQL Challenge

Warehouse Inventory Mismatch Detection
Problem Statement

A retail company performs regular warehouse inventory audits to compare:

system_stock → inventory recorded in the ERP/database
physical_stock → actual inventory counted during warehouse audits

In real-world warehouse operations, mismatches can occur because of:

delayed stock updates
damaged goods
theft/leakage
incorrect adjustments
synchronization failures
operational mistakes

The company wants to identify products that continuously remain mismatched across multiple audits, even after adjustment attempts.

Your task is to detect suspicious inventory reconciliation failures.

Objective

Identify all (warehouse_id, product_id) combinations where:

stock mismatches occur in 3 or more consecutive audits
mismatch continues even after adjustment attempts
inventory discrepancy remains unresolved
Definitions
Mismatch Audit

An audit is considered a mismatch when:

system_stock <> physical_stock
Resolved Audit

An audit is considered resolved when:

system_stock = physical_stock

A resolved audit breaks the ongoing mismatch streak.

Rules
1. Consecutive Mismatch Logic

A suspicious streak exists when:

the same warehouse_id
and same product_id

have:

3 or more consecutive mismatch audits

without any resolved audit in between.

2. Streak Reset Logic

If an audit becomes resolved:

system_stock = physical_stock

then the mismatch streak must restart from zero.

3. Warehouse Isolation

The same product in different warehouses should be treated independently.

Example:

P1 in W1
and
P1 in W2

must be analyzed separately.

4. Total Stock Gap

Calculate:

SUM(
ABS(system_stock - physical_stock)
)

across the entire mismatch streak.

5. Maximum Stock Gap

Find the largest single-audit discrepancy within the streak:

MAX(
ABS(system_stock - physical_stock)
)
6. Adjustment Attempts

Count how many audits attempted correction using:

adjustment_done = 'YES'
7. Final Status Logic
UNRESOLVED

If the latest audit in the mismatch streak is still mismatched.

RESOLVED

If the next audit after the mismatch streak becomes balanced:

system_stock = physical_stock
Expected Output Columns
warehouse_id
product_id
mismatch_start_time
mismatch_end_time
consecutive_mismatch_audits
total_stock_gap
max_stock_gap
adjustment_attempts
final_status
Edge Cases Covered

The dataset includes several real-world edge cases:

consecutive mismatches
mismatch resolution after adjustment
failed adjustment attempts
products existing in multiple warehouses
isolated mismatches
long mismatch streaks
resolved vs unresolved reconciliation cases
Real-World Use Cases

This type of analysis is commonly used in:

warehouse analytics
supply chain monitoring
ERP reconciliation systems
inventory leakage detection
retail operations analytics
fraud and shrinkage detection
audit monitoring systems
Difficulty Level
HARD / REAL-WORLD ANALYTICS

This problem requires strong understanding of:

streak detection
grouping logic
consecutive event analysis
partitioning
edge-case handling
aggregation over dynamic windows
warehouse-level behavioral analytics
