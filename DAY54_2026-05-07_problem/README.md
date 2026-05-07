 
# Day 54 — Only Hardest Daily SQL Challenge

## Rolling Fraud Ring Detection using Advanced Window Analytics

A food delivery company wants to identify suspicious delivery behavior where drivers repeatedly deliver to the same small group of customers within short time intervals.

This challenge focuses on building a rolling fraud-detection system using SQL.

The main difficulty comes from dynamically recalculating metrics inside moving 7-day rolling windows.

---

# Problem Overview

For every driver, analyze delivery activity inside rolling 7-day windows and classify whether the behavior is suspicious or normal.

The solution must calculate:

* Total deliveries inside the active rolling window
* Distinct customers inside the window
* Percentage of fast deliveries
* Percentage of repeat-customer deliveries
* Final fraud classification

---

# Fraud Detection Rules

A rolling window is considered `SUSPICIOUS` when BOTH conditions are satisfied:

* Fast delivery percentage ≥ 70%
* Repeat customer percentage ≥ 60%

Otherwise classify the window as:

```text
NORMAL
```

---

# Rolling Window Logic

This is NOT a fixed calendar-week problem.

The window continuously shifts based on delivery activity.

For every active rolling bucket:

```text
[current_window_start → current_window_end]
```

all calculations must be recomputed dynamically.

---

# Fast Delivery Logic

A delivery is considered fast when:

```text
delivery completed within 10 minutes
```

Fast delivery percentage is calculated only using rows inside the active rolling window.

---

# Repeat Customer Logic

A repeat customer order means:

```text
customer already appeared earlier inside the same rolling window
```

Repeat percentage must also be calculated only inside the active window.

---

# Important Rules

* Ignore non-delivered orders
* Multiple orders may occur at the exact same timestamp
* Rolling windows are continuous and overlapping
* Metrics must reset for every rolling window
* Repeat-customer calculations are window-specific
* Drivers may transition between:

  * NORMAL
  * SUSPICIOUS
  * NORMAL again

depending on changing window composition

---

# Key SQL Concepts Tested

This challenge combines multiple advanced SQL concepts together:

* Rolling interval windows
* Stateful behavior tracking
* Window functions
* Dynamic aggregations
* Conditional percentage calculations
* Fraud pattern analytics
* Overlapping window analysis
* Real-world event stream processing

---

# Why This Problem Is Hard

This is not a standard aggregation problem.

The main challenge comes from:

* Continuously changing rolling windows
* Recalculating customer repeat behavior dynamically
* Maintaining accurate rolling percentages
* Handling edge cases around timestamps and window boundaries
* Producing scalable logic suitable for large datasets

Naive self-join solutions become extremely expensive at scale.

Efficient implementations require careful use of:

* Window functions
* Rolling grouping strategies
* Conditional aggregations
* Stateful analytics logic

---

# Real-World Relevance

This type of logic is commonly used in:

* Food delivery fraud detection
* Ride-sharing abuse monitoring
* Cashback exploitation systems
* Marketplace fraud analytics
* Referral abuse tracking
* Behavioral anomaly detection systems

---

# Challenge Difficulty

```text
Extreme Hard
```

This problem reflects real production-level analytics scenarios where SQL is used for behavioral monitoring and fraud detection over large-scale event streams.
