# Day 48 – Only Hard Daily SQL Challenge (EXTREME)

## 🔥 Problem: Time-Aware Pricing Anomaly Detection

You are given a historical pricing table that tracks how product prices change over time.

### **Table Schema**

```
price_logs
----------
product_id   INT
price        INT
start_time   DATETIME
end_time     DATETIME   -- NULL means price is currently active
```

Each row represents a time interval during which a specific price was active for a product.

---

## 🎯 Objective

Write a SQL query to identify **invalid or anomalous pricing intervals**.

Return the result in the following format:

```
product_id | issue_type | issue_start | issue_end
```

---

## ⚙️ Rules & Constraints

### 1. OVERLAP

* A product must not have multiple active prices at the same time.
* If intervals overlap (partial or nested), flag the **intersection**.

---

### 2. GAP

* Pricing should be continuous.
* If there is a gap between intervals, flag that duration.

---

### 3. DUPLICATE

* Exact same interval (same product_id, price, start_time, end_time).
* Should be reported once.

---

### 4. IMPORTANT NOTES

* Data is not sorted.
* Intervals may overlap, be nested, duplicated, or unordered.
* `end_time IS NULL` should be handled.
* Only anomalies should be returned.

---

## 🧠 Approach & Query Breakdown

### Step 1: Base CTE (Feature Engineering)

```
with cte as(
select *,
row_number() over(partition by product_id,price,start_time,end_time order by start_time ) as dup_rn,
row_number() over(partition by product_id order by start_time) as rn,
count(*) over(partition by product_id,price,start_time,end_time) as dup,
count(*) over(partition by product_id) as cnt,
lag(end_time) over(partition by product_id order by start_time) as lg_ed_time,
lag(start_time) over(partition by product_id order by start_time) as lg_st_time,
lag(price) over(partition by product_id order by start_time) as lg_prc 
from price_logs 
order by 1,3,4
)
```

### 🔍 What each column does:

* **dup_rn** → identifies duplicate rows (keep first occurrence)
* **rn** → sequence of intervals per product
* **dup** → count of identical intervals
* **cnt** → total intervals per product
* **lg_ed_time** → previous interval’s end_time
* **lg_st_time** → previous interval’s start_time
* **lg_prc** → previous price

---

### Step 2: Issue Classification

```
,cte2 as(
select *,
case 
when (dup=1 or (dup>1 and dup_rn=1)) 
     and (lg_ed_time>start_time and end_time>=lg_ed_time) 
     or (lg_st_time<start_time and end_time<lg_ed_time or lg_ed_time is null ) 
then  'OVERLAP'

WHEN DUP>1 and start_time=lg_st_time and end_time=lg_ed_time 
THEN 'DUPLICATE' 

when start_time>lg_ed_time 
then  'GAP'

else -1  
END AS issue_type 
from cte 
where cnt>1
and case 
when (dup=1 or (dup>1 and dup_rn=1))  
     and (lg_ed_time>start_time and end_time>=lg_ed_time) 
     or (lg_st_time<start_time and end_time<lg_ed_time ) 
then  'OVERLAP'

WHEN DUP>1 and start_time=lg_st_time and end_time=lg_ed_time 
     or lg_ed_time is null 
     or lg_st_time is null 
THEN 'DUPLICATE' 

when start_time>lg_ed_time 
then  'GAP'

else -1  
END!=-1

and (cnt>1 and rn>1 and lg_ed_time is not null) 
or (cnt>1 and rn>1 and lg_ed_time is  null )
)
```

### 🔍 Logic Explained

* **OVERLAP**

  * Current interval starts before previous ends
  * Handles both partial and nested overlaps

* **DUPLICATE**

  * Same interval repeated
  * Controlled using `dup` + `dup_rn`

* **GAP**

  * Current start_time > previous end_time

* Filters remove:

  * invalid rows
  * first row (no comparison possible)

---

### Step 3: Final Output Formatting

```
select product_id,issue_type,
case 
when issue_type='overlap' then start_time 
when issue_type='gap' then lg_ed_time 
else start_time 
end as issue_start,

case 
when issue_type='overlap' and lg_ed_time is not null and lg_ed_time<=end_time then lg_ed_time 
when issue_type='gap' then start_time 
else end_time 
end as issue_end 
from cte2
```

---

## 🎯 Final Logic Summary

| Issue Type | Condition                      |
| ---------- | ------------------------------ |
| OVERLAP    | start_time < previous end_time |
| GAP        | start_time > previous end_time |
| DUPLICATE  | exact same interval            |

---

## 🚀 Key Concepts Used

* Window Functions (LAG, ROW_NUMBER, COUNT)
* Interval Comparison Logic
* Deduplication Strategy
* Conditional Classification
* Temporal Data Handling

---

## 💡 Insight

This problem mimics **real-world data quality validation** in pricing systems where:

* overlapping prices = business bug
* gaps = missing data
* duplicates = ingestion issues

---

## 🧠 Difficulty

**Extreme / Production-Level SQL**

---

## 🔗 Challenge Reference

Day 48 of Only Hard Daily SQL Challenge
 
