# 🚀 Day 29 – Only Hard SQL Challenge

📅 Date: 2026-03-06

## Problem: Ad Campaign Scheduling with Priority and Budget

In digital advertising platforms, multiple campaigns may compete for the same **time slot**.
Each campaign has its own **priority**, **budget**, and **time window** during which it wants to run.

Your task is to determine **which campaign should run at each moment of time** when multiple campaigns overlap.

---

# 📊 Table Structure

### `campaigns`

| Column      | Description                                    |
| ----------- | ---------------------------------------------- |
| campaign_id | Unique identifier of the campaign              |
| slot_id     | Ad slot where the campaign runs                |
| start_time  | Campaign start time                            |
| end_time    | Campaign end time                              |
| priority    | Higher priority campaigns should be preferred  |
| budget      | Used as a tiebreaker when priority is the same |

---

# 🎯 Objective

For each **slot**, determine which **campaign should run during every atomic time interval**.

The selection rules are:

1️⃣ If multiple campaigns overlap → choose the campaign with **higher priority**
2️⃣ If priority is the same → choose the campaign with **higher budget**
3️⃣ If both are the same → choose the campaign with **earlier start_time**

---

# 🧠 Key Concept

Instead of evaluating large overlapping intervals directly, the problem must be solved by splitting time into **atomic intervals**.

Atomic intervals are created using **all unique start and end timestamps**.

Example:

```
10:00 — 11:00
11:00 — 11:30
11:30 — 12:00
12:00 — 12:30
```

Each atomic interval is then evaluated to determine **which campaign wins that time segment**.

---

# ⚙️ Logic Overview

Step 1:
Extract all **start and end timestamps** for each slot.

Step 2:
Sort them and generate **atomic time segments** using `LEAD()`.

Step 3:
For each atomic segment, determine **all campaigns active during that time**.

Step 4:
Select the **winning campaign** based on:

```
priority DESC
budget DESC
start_time ASC
```

---

# ⚠️ Edge Cases Included in Dataset

This dataset intentionally includes tricky cases such as:

• Multiple overlapping campaigns
• Campaigns fully containing other campaigns
• Same priority but different budgets
• Duplicate campaigns
• Gaps where no campaign runs
• Long campaigns spanning multiple smaller campaigns

Handling these cases correctly is what makes this a **Hard SQL Challenge**.

---

# 📌 Expected Output

The final result should return:

| slot_id | st | ed | duration_minutes | priority | budget | campaign_id |
| ------- | -- | -- | ---------------- | -------- | ------ | ----------- |

Where each row represents the **winning campaign for that atomic time segment**.

---

# 🧩 Skills Tested

This challenge tests several advanced SQL skills:

• Time interval splitting
• Window functions (`LEAD`)
• Handling overlapping intervals
• Priority-based ranking logic
• Edge case handling
• Complex query structuring with CTEs

---

# 💡 Why This Problem Matters

This is a **real-world ad-tech scheduling problem** used in:

• Google Ads
• Meta Ads
• Real-time bidding platforms
• Ad inventory management systems

Understanding this logic helps build **efficient scheduling and allocation systems**.

---

# 🔗 Repository

Full dataset, schema, and solution available here:

👉 https://github.com/Karan7088/Only_Hard_Daily_SQL_Challenge

---

🔥 Follow the **Only Hard SQL Challenge** series where a new complex SQL problem is solved every day.
