# Machine Logs – Peak Concurrent Users & Conflict Minutes

**Date:** 2026-02-08  
**Difficulty:** Hard  
**Tags:** SQL, Window Functions, Intervals, Concurrency, Analytics, Data Quality

---

## 📌 Problem Statement (Detailed)

You are given a table `machine_logs` that stores user activity sessions on multiple machines.  
Each record represents a time interval during which a specific user was active on a specific machine.

### Objective

For **each `machine_id`**, compute:

1. **max_concurrent_users**  
   The maximum number of users that were active **at the same time** on that machine during any time window.

2. **conflict_min**  
   The total number of minutes during which **two or more users were active concurrently** on the machine.  
   If peak concurrency occurs in only one continuous window, return `0` (as per problem definition).

3. **users**  
   A comma-separated, sorted list of `user_id`s that participated in the **peak concurrency window(s)**.

---

