# 🚀 Day 18 – Longest Increasing Subsequence (LIS) in SQL

📅 Date: 2026-02-23  
📘 Difficulty: Extreme  
🧠 Category: Data Structures & Algorithms in SQL  
📂 Focus: Recursive CTE + Dynamic Programming Simulation  

---

## 🧩 Problem Statement

You are given a table `numbers`:

```sql
CREATE TABLE numbers (
    id INT PRIMARY KEY,
    value INT
);

Each row represents a number in a sequence.

Your task is to compute:

✅ The Length of the Longest Increasing Subsequence (LIS)

📌 What Exactly Is a Longest Increasing Subsequence?

A subsequence is a sequence derived from another sequence by:

Preserving the original order

Possibly removing some elements

NOT necessarily keeping elements contiguous

A subsequence is increasing if:

Each next value is strictly greater than the previous one

Important Conditions in This Problem:

id must be strictly increasing

value must be strictly increasing

You are allowed to skip rows

Duplicates cannot be part of a strictly increasing chain

📊 Example to Understand LIS

If the table contains:

id	value
1	10
2	9
3	2
4	5
5	3
6	7
7	101
8	18

One valid LIS would be:

2 → 5 → 7 → 101

Length = 4

Notice:

We skipped 9 and 3

Order of id is preserved

Values strictly increase

📌 Subsequence vs Subarray
Type	Must Be Contiguous?	Can Skip Elements?
Subarray	✅ Yes	❌ No
Subsequence	❌ No	✅ Yes

This problem is about Subsequence, not subarray.

🧠 Why This Is a DSA Problem?

In traditional programming (like C++/Java/Python), LIS is solved using Dynamic Programming.

Classic formula:

dp[i] = 1 + max(dp[j])
        where j < i AND arr[j] < arr[i]

Meaning:

For every element

Look at all previous smaller elements

Extend the longest subsequence found so far

Time complexity: O(n²)