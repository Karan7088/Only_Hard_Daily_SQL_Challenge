# 🚀 Day 23 – Only Hard SQL Challenge  
📅 Date: 27 February 2026  
## 🔍 Problem: Detect Earliest Suspicious 60-Minute Credit Burst

### 📌 Difficulty: Hard  
### 🧠 Concepts Covered:
- Self Join
- Window-Based Time Filtering
- Conditional Aggregation
- HAVING Clause Logic
- Fraud Pattern Detection
- CTE Structuring
- First Occurrence Selection

---

## 🏦 Business Context

You are working as a Data Analyst in a FinTech company.

The Fraud Monitoring Team wants to identify users who show suspicious credit activity within a **rolling 60-minute window**.

Your task is to detect the **earliest qualifying 60-minute window per user** that satisfies strict fraud conditions.

---

## 📊 Table: `transactions`

| Column Name | Data Type | Description |
|-------------|----------|------------|
| txn_id      | INT      | Unique transaction ID |
| user_id     | INT      | User identifier |
| txn_time    | DATETIME | Transaction timestamp |
| txn_type    | VARCHAR  | credit / debit / reversal |
| amount      | DECIMAL  | Transaction amount |

---

## 🚨 Fraud Detection Rules

For any rolling 60-minute window (starting from a transaction time), flag a user if:

1. ✅ Total Credit ≥ 3 × Total Debit  
2. ✅ (Total Credit − Total Debit) > 10,000  
3. ✅ No Reversal Transactions  
4. ✅ No Single Credit > 90% of Total Credit  
5. ✅ If multiple windows qualify → select the **earliest window only**

---

## 🎯 Expected Output

Return one row per flagged user containing:

- `user_id`
- `window_start`
- `window_end`
- `total_credit`
- `total_debit`
- `net_amount`

---

## 💡 Key Insight

This problem simulates **real-world fraud burst detection**, where attackers:

- Rapidly inject credits
- Avoid reversals
- Split large amounts into smaller credits
- Trigger suspicious activity within short time intervals

---

## 🏆 Goal

Build a SQL solution that:

- Dynamically evaluates rolling 60-minute windows
- Applies conditional aggregation
- Filters using HAVING clause
- Selects only the earliest valid fraud window per user
- Produces a clean summary output

---

## 🔥 Why This Problem Is Powerful

This challenge tests:

- Advanced aggregation logic
- Time-based joins
- Edge-case handling
- Window ranking logic
- Real-world financial fraud modeling

---

### 💬 Author

Part of the **Only Hard Daily SQL Challenge Series**  
Designed for Data Analysts & Data Scientists who want to master advanced SQL patterns.

---

⭐ If you found this useful, consider starring the repository!