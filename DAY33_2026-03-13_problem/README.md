 # Day 33 — Hard SQL Challenge
📅 Date: 2026-03-13

## Problem Title
Amazon Warehouse Robot Scheduling (Conflict Detection)

---

# Problem Statement

An Amazon warehouse uses autonomous robots to move items between storage shelves and packing stations.

Each robot performs multiple tasks throughout the day. Every task has a specific start time and end time.

However, a robot **cannot execute two tasks at the same time**. If two tasks assigned to the same robot overlap in time, it creates a **scheduling conflict**.

Your task is to detect all such conflicts.

---

# Table Structure

## tasks

| column | description |
|------|-------------|
| task_id | unique identifier for the task |
| robot_id | robot performing the task |
| start_time | task start timestamp |
| end_time | task end timestamp |
| zone | warehouse zone where task is executed |

Example row:

| task_id | robot_id | start_time | end_time | zone |
|------|------|------|------|------|
| 1 | 1 | 08:00 | 08:30 | A |

This means:

Robot **1** performs a task in **Zone A** from **08:00 to 08:30**.

---

# The Challenge

Detect **all overlapping tasks for the same robot**.

Two tasks overlap if they are active during the same time window.

Overlap condition:

```
task1.start_time < task2.end_time
AND
task2.start_time < task1.end_time
```

This ensures both tasks share some common time interval.

---

# Expected Output

The output should contain:

| column | meaning |
|------|------|
| robot_id | robot with conflict |
| task1 | first conflicting task |
| task2 | second conflicting task |
| conflict_start | when overlap begins |
| conflict_end | when overlap ends |

---

# Example

Robot 1 tasks:

| task_id | start | end |
|------|------|------|
| 1 | 08:00 | 08:30 |
| 2 | 08:20 | 08:50 |

Timeline:

```
Task 1 : 08:00 ─────── 08:30
Task 2 :       08:20 ───────── 08:50
```

Overlap window:

```
08:20 → 08:30
```

So this pair forms a **conflict**.

---

# SQL Solution

```sql
SELECT 
    a.robot_id,
    a.task_id AS task1,
    b.task_id AS task2,
    GREATEST(a.start_time, b.start_time) AS conflict_start,
    LEAST(a.end_time, b.end_time) AS conflict_end
FROM tasks a
JOIN tasks b
    ON a.robot_id = b.robot_id
   AND a.task_id < b.task_id
   AND a.start_time < b.end_time
   AND b.start_time < a.end_time
ORDER BY 
    a.robot_id,
    a.task_id;
```

---

# Explanation of the Logic

## 1️⃣ Self Join

We join the `tasks` table with itself so that each task can be compared with other tasks.

```
tasks a
JOIN tasks b
```

---

## 2️⃣ Same Robot Condition

```
a.robot_id = b.robot_id
```

This ensures we only compare tasks belonging to the **same robot**.

---

## 3️⃣ Avoid Duplicate Pairs

```
a.task_id < b.task_id
```

Without this condition we would get duplicate pairs such as:

```
1,2
2,1
```

---

## 4️⃣ Detect Time Overlap

```
a.start_time < b.end_time
AND
b.start_time < a.end_time
```

This is the standard method used to detect **overlapping time intervals**.

---

## 5️⃣ Calculate Conflict Window

Conflict start time:

```
GREATEST(a.start_time, b.start_time)
```

Conflict end time:

```
LEAST(a.end_time, b.end_time)
```

These functions compute the **exact overlapping time range**.

---

# Edge Cases Covered

This dataset contains several complex scheduling scenarios:

### Nested Tasks
A small task completely inside a larger task.

### Same Start Times
Multiple tasks starting at the same moment.

### Boundary Edge Cases
Tasks touching exactly at the boundary time.

Example:

```
12:00–12:30
12:30–13:00
```

These do **not overlap**.

### Heavy Conflict Clusters
Many tasks overlapping simultaneously.

### Out-of-Order Inserts
Tasks inserted without chronological ordering.

---

# Real World Applications

This type of problem appears in real systems such as:

- Warehouse robot scheduling
- Airline gate scheduling
- Hospital operating room planning
- Distributed computing job schedulers

Because **one resource cannot execute multiple jobs at the same time**.

---

# Repository

Full problem and dataset:

https://github.com/Karan7088/Only_Hard_Daily_SQL_Challenge/tree/main/DAY32_2026-03-12_problem
