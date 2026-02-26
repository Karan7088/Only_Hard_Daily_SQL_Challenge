# 🔥 Day 21 – Only Hard Daily SQL Challenge
📅 Date: 26 February 2026  
🧠 Difficulty: Extreme  
🏷 Topic: Fraud Analytics – Suspicious Login Cluster Detection  

---

## 🚨 Problem Title
Account Takeover Detection Using Rolling 10-Minute Window

---

## 📌 Business Context

You are working as a **Data Science Analyst** in a fintech company.

The Risk & Fraud team suspects that some user accounts are being accessed from multiple IP addresses within a short time window — a strong signal of **account takeover fraud**.

Your task is to detect suspicious login clusters.

---

## 📂 Table Schema

```sql
CREATE TABLE user_logins (
    login_id INT PRIMARY KEY,
    user_id INT,
    login_time DATETIME,
    ip_address VARCHAR(50),
    device_id VARCHAR(50)
);

🎯 Objective

Identify users who have:

✅ 3 or more logins

✅ Within a 10-minute rolling window

✅ From 3 or more distinct IP addresses

Return:

| user_id | cluster_start_time | cluster_end_time | distinct_ips | total_logins |

🧠 Important Rules
1️⃣ Rolling Window (NOT fixed bucket)

The 10-minute window is dynamic.

For each login, consider the next 10 minutes from that timestamp.

Do NOT group by fixed 10-minute intervals.

2️⃣ Same User Only

Clusters must be calculated per user.

No cross-user mixing.

3️⃣ Distinct IP Logic

IP addresses must be unique inside the window.

Repeated IP should NOT increase distinct count.

Device ID does NOT affect distinct IP logic.

4️⃣ Minimum Conditions

Inside a 10-minute window:

total_logins >= 3

distinct_ips >= 3

Both conditions must be satisfied.

5️⃣ Boundary Condition

Exactly 10 minutes difference should count.

Example:

15:00:00

15:10:00 ✅ Valid (exactly 10 minutes)

6️⃣ Cross Midnight Handling

Window can cross date boundary.

Example:

23:57:00

00:04:00 next day

Must still be treated correctly.

7️⃣ Multiple Clusters

A single user may have multiple independent clusters.

Return all clusters.

Order by:

ORDER BY user_id, cluster_start_time
🔎 Edge Cases Included in Dataset
Scenario	Expected Behavior
Same IP repeated	Should NOT qualify
Different device same IP	Should NOT increase distinct IP
More than 3 IPs	Should qualify
Exactly 10-minute boundary	Should qualify
Logins >10 mins apart	Should NOT qualify
Overlapping clusters	Must handle carefully
Heavy burst activity	Should detect
🧮 Bonus Extension (Ultra Hard)

Add:

risk_score = distinct_ips * total_logins

Add:

CASE 
  WHEN risk_score >= 9 THEN 'HIGH_RISK'
  ELSE 'MEDIUM_RISK'
END AS risk_flag
💀 Why This Problem Is Hard

This challenge tests:

Window Functions

Rolling time-window simulation

Dynamic distinct counts

Fraud detection logic

Overlapping cluster handling

Edge-case management

Analytical thinking under real-world constraints

This is not a simple GROUP BY problem.

This simulates real fintech fraud detection systems.

🚀 Expected Skill Level After Solving

If you solve this cleanly without brute-force Cartesian joins:

You understand rolling window logic

You can handle real-world fraud analytics

You are operating at production SQL level

🏆 Challenge Rule

❌ No hardcoded time buckets
❌ No manual filtering
❌ No ignoring edge cases
✅ Proper rolling window logic required