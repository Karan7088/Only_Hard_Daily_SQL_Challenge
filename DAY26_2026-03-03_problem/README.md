# 🔥 Day 26 – Only Hard SQL Challenge  
📅 Date: 03 March 2026  
💀 Difficulty Level: Hard  
🧠 Concepts Covered: Window Functions, Consecutive Dates Logic, Streak Analysis, Dense Ranking, Advanced CTE Design  

---

## 📌 Problem Statement

You are given a table:

### `user_activity`

| user_id | activity_date |
|----------|--------------|
| INT      | DATE         |

Each row represents a user’s activity on a particular date.

---

### 🎯 Objective

For each user:

1. Find the **longest consecutive activity streak**
2. Return:
   - `user_id`
   - `st` → Start date of longest streak
   - `ed` → End date of longest streak
   - `streak` → Length of that streak
3. If multiple streaks have same length, return the earliest one.
4. Order final result by:
   - `streak DESC`
   - `user_id ASC`

---

# 🧠 Core Logic Explanation

The main challenge is:

> How do we detect consecutive dates inside partitions?

---

## 🔹 Step 1 – Identify Date Gaps

We use:

```sql
DATEDIFF(activity_date, LAG(activity_date))