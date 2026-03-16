 # Day 36 – Advanced YouTube Recommendation Engine

**Only Hard Daily SQL Challenge**
**Date:** 16 March 2026

---

## Problem Overview

Modern video platforms recommend content based on **user engagement, recency of interaction, and overall video popularity**.

In this challenge, you will simulate a simplified version of a recommendation ranking pipeline similar to systems used by companies like YouTube and Netflix.

Your goal is to **rank videos for each user and return the Top 3 recommendations** based on a calculated score that combines:

* Watch behavior
* Video engagement
* Recency decay
* Trending boost

---

## Tables

### `watch_sessions`

| column       | description                     |
| ------------ | ------------------------------- |
| session_id   | Unique watch session ID         |
| user_id      | User watching the video         |
| video_id     | Video being watched             |
| watch_time   | Seconds watched in that session |
| video_length | Total length of the video       |
| watch_date   | Date of the session             |

A user may watch the **same video multiple times** across different sessions.

---

### `video_engagement`

| column   | description             |
| -------- | ----------------------- |
| video_id | Video identifier        |
| likes    | Total likes received    |
| comments | Total comments received |
| shares   | Total shares received   |

These represent **global engagement metrics** for the video.

---

## Business Logic

### 1. Aggregate Watch Sessions

Users may watch the same video multiple times, so interactions must first be aggregated.

For each **(user_id, video_id)** compute:

* `total_watch_time = SUM(watch_time)`
* `avg_watch_ratio = AVG(watch_time / video_length)`
* `last_watch_date = MAX(watch_date)`

---

### 2. Join Engagement Signals

Combine aggregated watch data with **video engagement metrics**.

---

### 3. Compute Engagement Score

```
engagement_score =
(avg_watch_ratio * 0.5)
+ (likes * 0.2)
+ (comments * 0.2)
+ (shares * 0.1)
```

---

### 4. Apply Recency Decay

Recent interactions should matter more than older ones.

```
decay_factor =
EXP(-DATEDIFF(CURDATE(), last_watch_date) / 30)
```

```
final_score = engagement_score * decay_factor
```

---

### 5. Trending Boost

Videos with strong engagement get a boost.

If:

```
likes + comments + shares > 500
```

Then:

```
final_score = final_score * 1.2
```

---

### 6. Ranking

For each user:

```
ORDER BY final_score DESC
```

Return **Top 3 videos per user**.

If a user watched fewer than 3 videos, return only the available ones.

---

## Expected Output

| user_id | video_id | rank |
| ------- | -------- | ---- |
| 1       | 102      | 1    |
| 1       | 101      | 2    |
| 1       | 103      | 3    |
| 2       | 104      | 1    |
| 2       | 101      | 2    |
| 2       | 105      | 3    |
| 3       | 107      | 1    |
| 3       | 106      | 2    |
| 3       | 108      | 3    |
| 4       | 109      | 1    |
| 4       | 111      | 2    |
| 4       | 110      | 3    |
| 5       | 113      | 1    |
| 5       | 112      | 2    |
| 6       | 114      | 1    |
| 6       | 115      | 2    |
| 7       | 116      | 1    |
| 7       | 117      | 2    |
| 8       | 118      | 1    |
| 9       | 119      | 1    |
| 10      | 120      | 1    |
| 10      | 121      | 2    |

---

## SQL Concepts Tested

* Aggregation
* Window functions
* Ranking per group
* Feature engineering in SQL
* Mathematical scoring logic
* Handling multiple sessions per user

---

## Difficulty Level

**Advanced / Hard**

This problem simulates a simplified **recommendation ranking pipeline**, combining user behavior signals with engagement metrics and time decay.

---

## Challenge Goal

Design a SQL query that:

1. Aggregates session data
2. Calculates engagement scores
3. Applies time decay
4. Ranks videos per user
5. Returns the **Top 3 recommendations per user**

---

**Part of the "Only Hard Daily SQL Challenge" series.**
