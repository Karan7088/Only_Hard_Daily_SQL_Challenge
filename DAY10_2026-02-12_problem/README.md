# 🔄 Transaction Graph Analysis (Cycle Detection + Depth Calculation)
Date:2026-02-12
## 📌 Problem Statement

You are given a `transactions` table containing:

-   `tx_id`
-   `sender_id`
-   `receiver_id`
-   `amount`
-   `status`
-   `tx_date`

Your task is to analyze transaction flows **per day** and compute:

-   `depth` → Maximum number of forward hops from a sender
-   `total_nodes` → Total distinct nodes reachable from sender
    (including itself)
-   `is_cycle` → 1 if sender belongs to a cycle, otherwise 0
-   `status` → 'cyclic' or 'linear'

------------------------------------------------------------------------

## ✅ Rules & Filters

Only consider transactions where:

``` sql
status = 'success'
AND amount > 0
AND amount IS NOT NULL
AND sender_id IS NOT NULL
AND receiver_id IS NOT NULL
```

Ignore: - Failed transactions - Null amounts - Zero amounts - Negative
amounts

------------------------------------------------------------------------

## 📊 Definitions

### 🔹 Depth

Depth = Maximum number of edges in a simple path (no repeated nodes).

If a sender can reach 4 distinct nodes:

    total_nodes = 4
    depth = 3

Because visiting 4 nodes requires 3 edges.

------------------------------------------------------------------------

### 🔹 Total Nodes

Total distinct nodes reachable from sender (including itself).

------------------------------------------------------------------------

### 🔹 Cycle Detection

A sender is part of a cycle if:

> You can start from that sender and return back to it through valid
> transactions.

All nodes inside a strongly connected component (SCC) are marked as:

    is_cycle = 1
    status = 'cyclic'

------------------------------------------------------------------------

## 🔁 Recursive Strategy

We use a Recursive CTE:

-   Maintain a `path` (visited nodes list)
-   Increase depth when visiting new nodes
-   Stop recursion when:
    -   A node is revisited
    -   Cycle is detected

Recursion automatically stops when no new rows are produced.

------------------------------------------------------------------------

## 🧠 Example

For transactions:

    301 → 302
    302 → 303
    303 → 301
    301 → 304
    304 → 301

Distinct nodes = 4\
Maximum simple path edges = 3

Result:

  sender_id   depth   total_nodes   is_cycle   status
  ----------- ------- ------------- ---------- --------
  301         3       4             1          cyclic
  302         3       4             1          cyclic
  303         3       4             1          cyclic
  304         3       4             1          cyclic

------------------------------------------------------------------------

## 🏆 Final Output Columns

    sender_id
    tx_date
    depth
    total_nodes
    is_cycle
    status

------------------------------------------------------------------------

## 🚀 Key Concepts Used

-   Recursive CTE
-   Graph traversal
-   Cycle detection using visited path tracking
-   Strongly Connected Components logic
-   Longest simple path logic

------------------------------------------------------------------------

## 📌 Final Notes

-   Depth must never count a repeated node.
-   Always prevent infinite recursion.
-   Cycle detection and depth calculation are related but logically
    different.
-   Recursion stops when no new rows are produced.

------------------------------------------------------------------------

Built as part of advanced SQL graph traversal practice 🚀
