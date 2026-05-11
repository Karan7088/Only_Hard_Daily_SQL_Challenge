 # Day 58 - OnlyHardDailySQLChallenge

**Date:** 2026-05-11

# Inventory Stockout Recovery Analysis

## Problem Statement

You are given inventory snapshot data for multiple products.

Each row represents the stock quantity of a product at a specific snapshot time.

Your task is to detect every stockout incident for each product and calculate how long it took for the product to recover.

A stockout happens when a product's stock quantity becomes `0`.

A recovery happens when the product's stock quantity becomes greater than `0` after being out of stock.

---

## Table

### inventory_snapshots

| Column Name | Description |
|---|---|
| snapshot_id | Unique snapshot record id |
| product_id | Unique product id |
| snapshot_time | Time when inventory was captured |
| stock_quantity | Available stock quantity at that time |

---

## Rules Before Solving

### 1. Stockout Start Rule

A stockout incident starts when:

stock_quantity = 0

Example:

10:00 -> stock = 20
12:00 -> stock = 0

Stockout starts at:

12:00
2. Consecutive Zero Rule

If a product has multiple consecutive 0 stock snapshots, they belong to the same stockout incident.

Example:

12:00 -> stock = 0
14:00 -> stock = 0
16:00 -> stock = 15

This is only one stockout incident.

Stockout start:

12:00

Recovery time:

16:00

Duration:

240 minutes
3. Recovery Rule

A stockout incident ends when the stock becomes greater than 0.

Example:

09:00 -> stock = 0
10:00 -> stock = 5

Recovery time is:

10:00
4. Not Recovered Rule

If a product goes out of stock and never becomes positive again, mark it as:

NOT_RECOVERED

In this case:

stockout_duration_minutes = NULL
5. Multiple Incident Rule

A product can go out of stock multiple times.

Example:

08:00 -> stock = 10
09:00 -> stock = 0
10:00 -> stock = 5
11:00 -> stock = 0
13:00 -> stock = 7

This creates two separate stockout incidents:

Incident 1: 09:00 -> 10:00
Incident 2: 11:00 -> 13:00
6. Product Already Out of Stock Rule

If the first available snapshot of a product already has stock quantity 0, then the stockout starts from that first snapshot time.

Example:

08:00 -> stock = 0
09:00 -> stock = 0
10:00 -> stock = 12

Stockout start:

08:00

Recovery time:

10:00
7. Ignore Never-Stockout Products

If a product never reaches stock quantity 0, it should not appear in the output.

Expected Output Columns
Column Name	Description
product_id	Product that went out of stock
stockout_start	Time when stockout started
stockout_duration_minutes	Minutes taken to recover
incident_number	Stockout incident sequence number per product
recovery_status	RECOVERED or NOT_RECOVERED
Output Logic

For each product:

Identify all timestamps where stock quantity is 0.
Group consecutive zero-stock rows into one incident.
Find the first timestamp of each stockout group.
Find the next timestamp where stock becomes greater than 0.
Calculate duration in minutes.
Assign incident number per product.
Mark recovery status.
Example

Input snapshots for one product:

snapshot_time        | stock_quantity
---------------------|---------------
2024-01-01 08:00:00 | 10
2024-01-01 09:00:00 | 0
2024-01-01 10:00:00 | 0
2024-01-01 11:00:00 | 5
2024-01-01 12:00:00 | 0
2024-01-01 13:00:00 | 7

Explanation:

First stockout:

09:00 -> stock became 0
11:00 -> stock recovered
Duration = 120 minutes

Second stockout:

12:00 -> stock became 0
13:00 -> stock recovered
Duration = 60 minutes

Expected result:

product_id | stockout_start      | stockout_duration_minutes | incident_number | recovery_status
-----------|---------------------|----------------------------|------------------|----------------
101        | 2024-01-01 09:00:00 | 120                        | 1                | RECOVERED
101        | 2024-01-01 12:00:00 | 60                         | 2                | RECOVERED
Correct Expected Output
product_id | stockout_start      | stockout_duration_minutes | incident_number | recovery_status
-----------|---------------------|----------------------------|------------------|----------------
101        | 2024-01-01 12:00:00 | 240                        | 1                | RECOVERED
102        | 2024-01-01 10:00:00 | NULL                       | 1                | NOT_RECOVERED
103        | 2024-01-01 09:00:00 | 60                         | 1                | RECOVERED
103        | 2024-01-01 11:00:00 | 120                        | 2                | RECOVERED
105        | 2024-01-01 08:00:00 | 120                        | 1                | RECOVERED
106        | 2024-01-01 09:00:00 | 120                        | 1                | RECOVERED
106        | 2024-01-01 12:00:00 | 60                         | 2                | RECOVERED
106        | 2024-01-01 14:00:00 | NULL                       | 3                | NOT_RECOVERED
107        | 2024-01-01 09:00:00 | 60                         | 1                | RECOVERED
107        | 2024-01-01 11:00:00 | 60                         | 2                | RECOVERED
107        | 2024-01-01 13:00:00 | 60                         | 3                | RECOVERED
Key Concepts Tested
Gap and island logic
Consecutive zero grouping
Window functions
State transition detection
Recovery time calculation
Open-ended incident handling
Incident numbering
Why This Problem Is Hard

This is not just a simple filter on stock_quantity = 0.

The hard part is identifying continuous stockout periods and separating them from new incidents after recovery.

The query must correctly handle:

Consecutive zero stock rows
Multiple stockout incidents
Products already out of stock
Products that never recover
Products that never go out of stock
Accurate duration calculation

This type of problem is common in real-world inventory analytics, supply chain monitoring, and e-commerce stock availability systems.

