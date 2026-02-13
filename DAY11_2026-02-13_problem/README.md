
# 📊 SaaS MRR Movement Analysis (MySQL 8)


Date:2026-02-13  

---

## 🚀 Problem Statement

We are given two tables:

### `subscriptions`
- `subscription_id`
- `user_id`
- `start_date`
- `end_date`
- `base_price`

### `plan_changes`
- `subscription_id`
- `change_date`
- `new_price`

We need to calculate **Monthly MRR movements**:

- ✅ `new_mrr`
- ✅ `expansion_mrr`
- ✅ `reactivation_mrr`
- ✅ `churned_mrr`

For each month of 2025.

---

# 🧠 Business Definitions (Enterprise Grade)

Understanding definitions is **more important than writing SQL**.

---

## 1️⃣ New MRR

Revenue from users whose **first-ever active month** is the current month.

### Logic:

prev_mrr IS NULL AND mrr > 0


Meaning:
- No previous record
- Now generating revenue

---

## 2️⃣ Expansion MRR

Increase in MRR from existing active users.

### Logic:

prev_mrr > 0 AND mrr > prev_mrr


Formula:

mrr - prev_mrr


---

## 3️⃣ Churned MRR

Revenue lost when an active user drops to zero.

### Logic:

prev_mrr > 0 AND mrr = 0


Formula:

prev_mrr


---

## 4️⃣ Reactivation MRR

Revenue from users who were previously active, churned, and came back.

### Logic:

prev_mrr = 0
AND mrr > 0
AND user had revenue historically


This prevents counting new users as reactivations.

---

# 🏗 How the Solution Works

---

## Step 1: Generate Monthly Calendar

We generate months from Jan 2025 to Dec 2025 using a recursive CTE.

This ensures:
- Every user has a row for every possible month.
- No missing timeline gaps.

---

## Step 2: Clean Plan Changes

We:
- Remove duplicate same-day changes
- Keep the latest change using `ROW_NUMBER()`

---

## Step 3: Build Price Timeline

We combine:
- Base subscription price
- Valid plan changes

We ignore:
- Changes before `start_date`
- Changes after `end_date`

---

## Step 4: Carry Forward MRR

For each subscription and month:

We fetch the latest price where:

event_date <= month


This ensures:
- MRR persists month-to-month
- No artificial drops
- No fake reactivations

---

## Step 5: Aggregate to User Level

If a user has multiple subscriptions:


SUM(price) per user per month


---

## Step 6: Detect Movements Using LAG

We calculate:


LAG(mrr) OVER (PARTITION BY user_id ORDER BY month)


This gives:
- Previous month MRR
- Used to classify movements

We also calculate:

Had user ever been active before?


This avoids misclassifying new users.

---

# 📈 Final Output Columns

| Column | Meaning |
|--------|----------|
| `new_mrr` | First-time revenue |
| `expansion_mrr` | Increase from active users |
| `churned_mrr` | Lost revenue |
| `reactivation_mrr` | Revenue from returned users |

---

# 🎯 Why This Approach Is Correct

This solution:

- ✔ Handles mid-month plan changes
- ✔ Deduplicates dirty data
- ✔ Prevents fake reactivation spikes
- ✔ Carries revenue forward correctly
- ✔ Works for multiple subscriptions per user
- ✔ Is enterprise SaaS ready

---

# 🧪 Edge Cases Handled

- Plan change before subscription start → ignored
- Plan change after subscription end → ignored
- Duplicate same-day plan changes → latest kept
- Zero price treated as churn
- Reactivation requires historical activity

---