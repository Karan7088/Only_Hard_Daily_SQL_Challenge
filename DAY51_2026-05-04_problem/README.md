# 📅 2026-05-04

# 🔥 Day 51 — Only Hard Daily SQL Challenge

---

## 🧠 Problem Overview

This challenge focuses on identifying **user activity streaks** using raw event-level data.

The goal is to transform noisy, multi-row daily activity into meaningful behavioral insights by detecting **valid streaks**, handling **resets**, and computing **longest and current streaks** per user.

---

## 📊 Dataset Description

The dataset contains user-level activity logs with the following columns:

* `user_id` → unique identifier for each user
* `activity_date` → date of activity
* `activity_type` → type of activity performed

---

## ⚙️ Core Rules & Logic

### 1. Work at Daily Level (Not Raw Rows)

* Multiple records can exist per user per day
* You must **collapse data per user per date**

For each day:

* Check if **login exists**
* Check if **cancel exists**

---

### 2. Valid Day Definition

A day is considered **valid** only if:

* At least one `login` exists
* AND no `cancel` exists

---

### 3. Invalid Day Conditions

A day becomes invalid if:

* A `cancel` occurs (even if login exists)
* Only `purchase` exists
* No login activity

---

### 4. Streak Definition

A streak is a sequence of:

* **Consecutive calendar days**
* Where each day is **valid**

---

### 5. Streak Break Conditions

A streak breaks if:

* A day is invalid
* There is a gap in dates (missing day)

---

### 6. Outputs Required

For each user:

* **longest_streak** → maximum consecutive valid days
* **current_streak** → streak ending at latest activity date
* **longest_streak_start** → starting date of longest streak

---

## 🧠 Key Concepts Used

* Data normalization (daily aggregation)
* Conditional logic for validation
* Gaps & islands pattern
* Window functions
* Streak grouping using date transformations

---

## ⚠️ Edge Cases Covered

* Multiple activities per day
* Cancel overriding valid behavior
* Missing dates breaking streaks
* Users with no valid streaks
* Overlapping streak segments
* Current streak different from longest

---

## 🎯 Objective

This problem tests your ability to:

* Think beyond simple aggregations
* Handle real-world messy data
* Combine multiple SQL patterns into a single solution

---

## 🚀 Outcome

Solving this correctly demonstrates:

* Strong command over window functions
* Deep understanding of streak logic
* Ability to handle production-level edge cases

---

## 🧨 Final Note

This is not just a SQL problem —
it reflects real-world analytics scenarios like:

* user retention
* engagement tracking
* behavioral segmentation

---

🔥 If you can solve this cleanly, you are operating at a **top-tier SQL level**.
 
