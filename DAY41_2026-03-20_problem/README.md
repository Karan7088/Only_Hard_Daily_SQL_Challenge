 # 🚀 SQL Challenge – Day 41

📅 Date: 2026-03-26
📌 Level: Extreme Hard

---

## 🧠 Problem Statement

You are given a table `sales` with the following columns:

* `product_id` (INT)
* `category` (VARCHAR)
* `revenue` (INT)
* `sale_date` (DATE)

---

## 🎯 Objective

Your goal is to analyze the data and return the **top-performing products within high-performing categories**.

---

## 🔍 What You Need to Do

### 1️⃣ Product-Level Calculation

* Calculate **total revenue for each product**
* Find the **latest sale date** for each product

---

### 2️⃣ Category-Level Calculation

* Compute **total revenue for each category**

---

### 3️⃣ Global Calculation

* Calculate the **average revenue across all categories**

---

### 4️⃣ Filtering Logic

* Keep only those categories where:

  ```
  category_total > average_category_total
  ```

---

### 5️⃣ Ranking Logic

* Rank products **within each category**
* Ranking rules:

  * Higher total revenue → higher rank
  * If revenue is same → use latest sale date for ordering
* Use **DENSE_RANK()** to handle ties properly

---

### 6️⃣ Final Output

* Return only **top 3 ranks per category**
* Include:

  * category
  * product_id
  * total revenue
  * latest sale date
  * rank

---

## ⚠️ Important Points

* Multiple rows may exist for the same product
* Products can have **same total revenue (ties)**
* Categories may have **less than 3 products**
* Some categories should be **excluded entirely**
* Tie-breaking affects **order, not rank**

---

## 🧠 Key Concepts

* Window Functions
* Aggregation vs Row-level data
* Multi-level calculations
* Ranking functions (`DENSE_RANK`)
* Filtering using derived values

---

## 💪 Status

✅ Completed Day 41 of Daily Extreme SQL Challenge
🔥 Consistency Level: High
🚀 Moving towards Advanced SQL Mastery
