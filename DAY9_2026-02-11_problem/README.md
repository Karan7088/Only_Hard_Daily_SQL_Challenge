# 🔥 Day 9 – Extreme Hard SQL  
## Fraud Network Clustering & Financial Exposure Analysis

Date: 2026-02-11
---

## 🧠 Problem Overview

You are given a financial system containing:

- `users`
- `transactions`
- `device_logins`
- `fraud_alerts`

Your task is to:

1. Identify connected clusters of users.
2. Compute total users in each cluster.
3. Calculate financial exposure for each cluster.
4. Flag clusters containing fraudulent users.

This is a **graph connectivity + aggregation + fraud analytics** problem.

---

# 🧩 Business Rules

Two users belong to the same cluster if:

- They transacted with each other  
  **OR**
- They shared at least one common device  

Connectivity is **transitive**.

If:

A ↔ B  
B ↔ C  

Then:

A, B, C belong to the same cluster.

---

# 📌 Step 1 – Cluster Formation

We treat:

- Users → Nodes  
- Transactions → Edges  
- Shared Devices → Edges  

Clusters are simply **Connected Components** in this graph.

---

# 📊 Step 2 – Final Output Columns

The final result must contain:

| Column | Description |
|---------|-------------|
| `cluster_id` | Minimum user_id in cluster |
| `users_in_cluster` | Comma-separated sorted user list |
| `total_users` | Count of distinct users in cluster |
| `total_exposure` | Sum of SUCCESS outgoing transactions |
| `fraud_flag` | 1 if any user in cluster appears in fraud_alerts |

---

# 💰 How to Calculate `total_exposure`

## ✅ Definition Used (Final)

> Total Exposure = Sum of SUCCESS transactions where sender belongs to cluster.

### Why sender-only?

- Avoids internal double counting
- Represents outward financial risk
- Prevents inflation due to internal transfers

### SQL Logic

```sql
SUM(t.amount)
WHERE t.status = 'SUCCESS'
AND t.sender_id IN (cluster users)
