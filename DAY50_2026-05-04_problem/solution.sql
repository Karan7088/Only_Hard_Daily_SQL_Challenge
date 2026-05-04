 # 🔥 Day 50 — Hard SQL Challenge

## Dynamic Median per User (Without Built-in Functions)

---

## 🧠 Problem Overview

You are given a dataset of transactions where each record represents a purchase made by a user.

Your task is to compute the **median transaction amount for each user**, **without using any built-in median or percentile functions**.

Additionally, for each transaction, you must calculate how far that transaction amount is from the user’s median.

---

## 📊 Table Structure

### `transactions`

| Column Name | Data Type | Description                     |
| ----------- | --------- | ------------------------------- |
| user_id     | INT       | Unique identifier for each user |
| txn_id      | INT       | Unique transaction ID           |
| amount      | INT       | Transaction amount              |

---

## 🎯 Objectives

For each `user_id`:

1. Calculate the **median transaction amount**
2. Attach that median to **every row of that user**
3. Compute **absolute deviation**:

   ```
   abs_dev = |amount - median|
   ```

---

## ⚠️ Constraints

* ❌ Do NOT use:

  * `MEDIAN()`
  * `PERCENTILE_CONT()`
  * Any built-in percentile/median function

* ✅ Must correctly handle:

  * Odd number of transactions
  * Even number of transactions
  * Duplicate values
  * Negative values
  * Unsorted input

---

## 🧩 Expected Output

| user_id | txn_id | amount | median | abs_dev |
| ------- | ------ | ------ | ------ | ------- |

Each row should include:

* Original transaction details
* Median value for that user
* Absolute deviation from median

---

## 💡 Key Concepts Involved

This problem tests your understanding of:

* Window functions
* Row ranking within partitions
* Conditional logic for even vs odd cases
* Aggregation over dynamically selected rows
* Handling edge cases in grouped data

---

## 🧠 Important Insight

Median is **not** a simple aggregation.

It depends on:

* The **position of elements** after sorting
* Not the total sum or average of all values

This makes it fundamentally different from typical SQL aggregations like `SUM` or `AVG`.

---

## 💀 Why This Problem is Hard

* Requires combining **multiple concepts together**
* Needs **precise control over row positions**
* Small logical mistakes lead to completely incorrect results
* SQL does not provide a straightforward built-in median in many environments
* Handling both **even and odd cases correctly** is tricky
* Edge cases like duplicates and unordered data add complexity

---

## 🧪 Real-World Relevance

This type of problem appears in:

* Financial data analysis
* Outlier detection
* Behavioral analytics
* Data cleaning and preprocessing

Median is often preferred over average when:

* Data is skewed
* Outliers are present

---

## 🚀 Takeaway

If you can solve this problem correctly:

* You understand **advanced window function usage**
* You can handle **non-trivial aggregation logic**
* You are moving beyond basic SQL into **analytical problem solving**

---

## 🏁 Difficulty Level

**Medium–Hard**

* Easy to understand
* Hard to implement correctly
* Even harder to optimize cleanly

---

👉 This problem is a strong indicator of whether someone can move from:

* writing queries
  ➡️ to
* thinking analytically in SQL
