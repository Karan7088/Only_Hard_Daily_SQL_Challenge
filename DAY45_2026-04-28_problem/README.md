# 🧩 Day 45 — User Lifecycle Segmentation (Extreme SQL Challenge)

## 📌 Overview

This problem focuses on analyzing **user activity over time** and classifying each user into lifecycle stages such as:

* New
* Retained
* Churned
* Resurrected

It simulates real-world **product analytics and growth tracking**, where understanding user behavior month-over-month is critical.

---

## 📂 Dataset

We are given a table:

**user_activity**

| Column        | Description                          |
| ------------- | ------------------------------------ |
| user_id       | Unique identifier for each user      |
| activity_date | Date when user performed an activity |

Each row represents a **single user activity event**.

---

## 🎯 Objective

For each **user and each month**, determine the user's lifecycle status.

---

## 🧠 Lifecycle Definitions

### 🟢 NEW

* The **first month** in which the user appears.
* A user can be NEW **only once**.

---

### 🔵 RETAINED

* User is active in the current month
* AND was also active in the **previous month**

---

### 🔴 CHURNED

* User was active in the previous month
* BUT is **not active in the current month**

> Note: This row must be **generated manually**, even if no activity exists.

---

### 🟡 RESURRECTED

* User is active in the current month
* BUT was **not active in the previous month**
* AND has been active at some point **before that**

---

## ⚠️ Key Rules to Consider

### 1. Monthly Granularity

* All activity must be grouped at **month level (YYYY-MM)**

---

### 2. Deduplication

* Multiple activities in the same month should be treated as **one**

---

### 3. Timeline Construction

* Build a **continuous month sequence**
* Missing months must be included

---

### 4. Start Point (Critical)

* Timeline for each user must start from their **first activity month**
* Do NOT include months before a user exists

---

### 5. Churn Handling

* If a user becomes inactive after being active
* You must explicitly create a **CHURNED** row

---

### 6. Resurrection Logic

* A user returning after **any gap (1 month or more)**
* Should be marked as **RESURRECTED**

---

### 7. Status Assignment Order (Important)

For each user-month:

1. If first activity → **NEW**
2. Else if active & previous active → **RETAINED**
3. Else if inactive & previous active → **CHURNED**
4. Else if active & previous inactive → **RESURRECTED**

---

## 🔍 Example

### Input Activity

```
Jan → Active  
Feb → Active  
Mar → No Activity  
Apr → Active  
```

### Output

```
Jan → NEW  
Feb → RETAINED  
Mar → CHURNED  
Apr → RESURRECTED  
```

---

## 🔥 Edge Cases Covered

* Users with only one activity
* Users with long inactivity gaps
* Multiple resurrection cycles
* Continuous retention users
* Duplicate activities within same month
* Users appearing late in timeline

---

## 🧠 Key Insight

This problem is not just about querying data — it’s about:

* Building **time-based user state transitions**
* Handling **missing data explicitly**
* Understanding **user lifecycle behavior**

---

## 💡 Real-World Applications

* Retention analysis
* Customer churn tracking
* Growth analytics
* Cohort analysis
* Product engagement monitoring

---

## 🚀 Final Takeaway

> Build a monthly timeline for each user starting from their first activity, and classify each month based on their activity compared to the previous month.

---

## 🏁 Difficulty Level

**Extreme (FAANG-level)**
Requires strong understanding of:

* Time-series logic
* State transitions
* Edge case handling
* Analytical thinking

---
 
