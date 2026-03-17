 # 💀 Day 37 – Incremental User Retention Cohort

📅 Date: 2026-03-17

---

## 🚨 Problem

Given a `user_activity` table, track **user retention cohorts**.

Each row represents a user being active on a specific date.

---

## 📊 Table Schema

| column | type |
|--------|------|
| user_id | INT |
| activity_date | DATE |

---

## 🎯 Objective

Build a retention table that shows:

- Cohort date (first activity of user)
- Retention day (days since cohort)
- Number of users active on each retention day

---

## 🧠 Key Concepts

### 1️⃣ Cohort Date
First activity date of each user.

### 2️⃣ Retention Day



### 3️⃣ Deduplication
Multiple activities on same day are counted once.

---

## ⚙️ Approach

1. Identify cohort_date using window function
2. Generate all possible date combinations (cohort × activity dates)
3. Calculate retention_day using DATEDIFF
4. Count distinct users per cohort and retention day
5. Filter out zero counts

---

## 🔥 Why This Problem is Hard

- Requires window functions
- Needs cross join for full date coverage
- Handles sparse data (missing days)
- Requires deduplication logic
- Involves correlated subqueries

---

## 🏆 Difficulty

**10/10 – Advanced SQL + Analytics**

---

## 💡 Key Insight

Retention analysis is widely used in:

- Product analytics
- Growth tracking
- User behavior analysis

---

## 🚀 Output Format

| cohort_date | retention_day | users |
|------------|--------------|------|

---

## 🔥 Author

Karan Aswal  
Only Hard Daily SQL Challenge 🚀
