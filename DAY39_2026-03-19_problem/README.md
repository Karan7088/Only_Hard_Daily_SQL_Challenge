# 💀 Day 39 – Only Hard SQL Challenge   
## 🔥 Converting Messy Data into 1NF (First Normal Form) 
DATE: 19-03-2026
 
--- 
 
## 🧠 Problem Overview 
 
In real-world systems, data is often stored in a **denormalized format**, where multiple values are packed into a single column using delimiters like commas. 
 
This violates **First Normal Form (1NF)**, which requires: 
- Atomic (indivisible) column values 
- No repeating groups or multi-valued attributes 
 
--- 
 
## 📦 Input Table: `orders_raw` 
 
| order_id | customer_id | product_ids        | quantities     | prices              | 
|----------|------------|--------------------|----------------|---------------------| 
| 12       | 112        | P19,P20,P21        | 1,2,3          | 1900,,2100          | 
| 13       | 113        | P22,P23            | two,3          | 2200,2300           | 
| ...      | ...        | ...                | ...            | ...                 | 
 
--- 
 
## 🚨 Challenges 
 
This dataset includes multiple real-world issues: 
 
- ❌ Comma-separated values (violates 1NF) 
- ❌ Unequal list lengths 
- ❌ Missing values (`''`, NULL) 
- ❌ Invalid data (`two`, `abc`) 
- ❌ Extra delimiters (`,,,`) 
- ❌ Leading/trailing spaces 
- ❌ Mixed data types (integers, decimals) 
- ❌ Negative values (returns/refunds) 
- ❌ Duplicate records 
 
--- 
 
## 🎯 Objective 
 
Convert the data into **First Normal Form (1NF)**: 
 
### ✅ Expected Output Structure 
 
| order_id | customer_id | product | quantity | price | 
|----------|------------|---------|----------|-------| 
 
Each row should represent: 
> **One product per order (atomic record)** 
 
--- 
 
## ⚙️ Approach 
 
We use a **Recursive CTE** to: 
 
1. Split comma-separated values into rows 
2. Maintain positional alignment between: 
   - `product_ids` 
   - `quantities` 
   - `prices` 
3. Iteratively extract values until all lists are exhausted 
 
--- 
 
## 🧹 Data Cleaning Rules 
 
- ✅ Trim spaces using `TRIM()` 
- ❌ Ignore empty values (`''`) 
- ❌ Ignore invalid numeric values (`two`, `abc`) 
- ✅ Use `REGEXP` to validate numeric fields 
- ✅ Cast only after validation 
- ⚠️ Handle mismatched lengths safely 
- ✅ Keep decimals and negative values (business-aware) 
 
 
--- 
 
## ⚠️ Key Learnings 
 
- Never **cast before validation** → leads to runtime errors 
- Always maintain **positional mapping** when splitting 
- SQL execution order matters (**SELECT before WHERE in expressions**) 
- Real-world data requires **cleaning + transformation together** 
 
--- 
 
## 💡 Business Insight 
 
- Positive quantity → **Sale** 
- Negative quantity → **Return/Refund** 
- Avoid blindly filtering (`quantity > 0`) without context 
 
--- 
 
## 🚀 Difficulty Level 
 
🔥 **9.5 / 10** 
 
This problem simulates: 
- ETL pipelines 
- Data cleaning workflows 
- Real-world messy datasets 
- Interview-level SQL challenges 
 
--- 
 
## 🛠️ Tech Used 
 
- MySQL 
- Recursive CTE 
- String functions (`SUBSTRING_INDEX`, `TRIM`) 
- Regular Expressions (`REGEXP`) 
- Type casting (`CAST`) 
 
--- 
 
## 👨‍💻 Author 
 
**Karan Aswal**   
📌 Only Hard Daily SQL Challenge   
 
--- 
 
## 🔗 Connect 
 
If you found this useful, feel free to connect and follow for more brutal SQL problems 🔥 
 
---
