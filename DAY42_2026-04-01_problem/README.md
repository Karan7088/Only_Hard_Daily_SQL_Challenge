 # 💣 SQL Problem: Customers Who Bought All Products Available at Their Time

## 📌 Problem Statement

Given two tables:

### **Products**

| Column      | Type    |
| ----------- | ------- |
| product_id  | VARCHAR |
| launch_date | DATE    |

### **Orders**

| Column      | Type    |
| ----------- | ------- |
| order_id    | INT     |
| customer_id | INT     |
| product_id  | VARCHAR |
| order_date  | DATE    |

---

## 🎯 Objective

Find all customers who have purchased **all products that were available up to their last order date**.

---

## 🧠 Key Idea

This is NOT a simple “buy all products” problem.

👉 Products are launched over time.

So for each customer:

> You only check products that existed **up to their last order date**, not future products.

---

## 🔥 Example

### Products Table

| product_id | launch_date |
| ---------- | ----------- |
| P1         | 2023-01-01  |
| P2         | 2023-01-01  |
| P3         | 2023-02-01  |
| P4         | 2023-03-01  |
| P5         | 2023-04-01  |

---

### Orders Table

| customer_id | product_id | order_date |
| ----------- | ---------- | ---------- |
| 10          | P1         | 2023-03-01 |
| 10          | P2         | 2023-03-03 |
| 10          | P3         | 2023-03-04 |
| 10          | P4         | 2023-03-05 |

---

### 🧠 Analysis

Customer 10’s last order date = **2023-03-05**

Products available till then:

```
P1, P2, P3, P4
```

Customer bought:

```
P1, P2, P3, P4
```

✅ Valid → Include

---

## ❌ Common Mistakes

### 1. Comparing with ALL products

```sql
SELECT COUNT(*) FROM Products
```

❌ Wrong — includes future products

---

### 2. Not handling duplicates

```sql
COUNT(product_id)
```

❌ Wrong — duplicates break logic

---

### 3. Ignoring launch_date

❌ Leads to incorrect inclusion

---

### 4. Including invalid purchases

```text
Order before product launch
```

❌ Must be excluded

---

## ✅ Correct Approach (Step-by-Step)

### Step 1: Filter valid orders

Only include orders where:

```sql
order_date >= launch_date
```

---

### Step 2: Find last order date per customer

```sql
MAX(order_date)
```

---

### Step 3: Find required products

Products where:

```sql
launch_date <= last_order_date
```

---

### Step 4: Compare sets

👉 Customer must have bought ALL required products

---

## 💡 Final SQL Solution

```sql
WITH cust_txn AS (
    SELECT 
        o.customer_id,
        o.product_id,
        MAX(o.order_date) OVER (PARTITION BY o.customer_id) AS last_dt
    FROM Orders o
    JOIN Products p
        ON o.product_id = p.product_id
       AND p.launch_date <= o.order_date
    WHERE o.product_id IS NOT NULL
)

SELECT customer_id
FROM cust_txn c
GROUP BY customer_id
HAVING COUNT(DISTINCT product_id) = (
    SELECT COUNT(*) 
    FROM Products p
    WHERE p.launch_date <= MAX(c.last_dt)
);
```

---

## 🧪 Expected Output (from brutal dataset)

```
1
3
5
7
10
11
```

---

## ⚡ Edge Cases Covered

| Case                 | Handled |
| -------------------- | ------- |
| Duplicate orders     | ✅       |
| NULL product_id      | ✅       |
| Orders before launch | ✅       |
| Future products      | ✅       |
| Partial buyers       | ✅       |

---

## 🧠 Alternative Approach (NOT EXISTS)

```sql
SELECT DISTINCT c.customer_id
FROM Orders c
WHERE NOT EXISTS (
    SELECT 1
    FROM Products p
    WHERE p.launch_date <= (
        SELECT MAX(order_date)
        FROM Orders o
        WHERE o.customer_id = c.customer_id
    )
    AND NOT EXISTS (
        SELECT 1
        FROM Orders o2
        WHERE o2.customer_id = c.customer_id
          AND o2.product_id = p.product_id
    )
);
```

---

## 🚀 Key Learning

Whenever you see:

* “ALL products”
* “EVERY condition”
* “Complete coverage”

👉 Think:

* `COUNT(DISTINCT)`
* `NOT EXISTS`
* Set comparison

---

## 💀 Difficulty Level

| Level        | Rating |
| ------------ | ------ |
| Beginner     | ❌      |
| Intermediate | ⚠️     |
| Advanced     | ✅      |
| FAANG        | 💀     |

---

## 🔥 Final Takeaway

> A customer qualifies if they purchased every product that existed up to their last order date.

---

## ⭐ If this helped

Give a ⭐ on GitHub and try the **NEXT LEVEL**:

👉 “Bought all products in EVERY month they were active” 😈

---
