# Day 59 - OnlyHardDailySQLChallenge

**Date:** 2026-05-12

# Smart Elevator Scheduling Analysis

## Problem Statement

You are given elevator movement logs from a smart building system.

Each row represents the elevator state at a particular timestamp, including:

- elevator position
- timestamp
- passenger count inside the elevator

Your task is to reconstruct elevator trips and identify inefficient elevator behavior.

The challenge is to correctly determine:

- when a trip starts
- when a trip ends
- maximum passengers carried
- empty elevator movement before trips
- capacity violations
- final trip status

---

# Business Context

Modern smart buildings continuously monitor elevator activity to optimize movement efficiency and passenger experience.

Operational analytics systems often analyze:

- idle movement
- unnecessary empty travel
- passenger load patterns
- trip reconstruction
- elevator utilization
- capacity violations

This problem simulates real-world elevator operational analytics used in:

- smart buildings
- malls
- airports
- hospitals
- office towers

---

# Table

## elevator_logs

| Column Name | Description |
|---|---|
| log_id | Unique log identifier |
| elevator_id | Elevator identifier |
| log_time | Timestamp of elevator state |
| floor_no | Elevator floor at that time |
| passenger_count | Number of passengers inside elevator |

---

# Rules Before Solving

## 1. Trip Start Rule

A trip starts when:

passenger_count changes from 0 to greater than 0

Example:

08:00 -> passenger_count = 0
08:02 -> passenger_count = 2

Trip starts at:

08:02
2. Trip End Rule

A trip ends when:

passenger_count becomes 0 again

Example:

08:06 -> passenger_count = 1
08:08 -> passenger_count = 0

Trip ends at:

08:08
3. Maximum Passenger Rule

For every trip:

max_passengers =
highest passenger_count during that trip

Example:

2 -> 3 -> 1 -> 0

Maximum passengers:

3
4. Elevator Capacity Rule

Maximum allowed capacity:

5 passengers

If any trip exceeds:

max_passengers > 5

then trip status becomes:

CAPACITY_VIOLATION
5. Empty Movement Rule

Empty movement means:

elevator travelled floors while passenger_count = 0
before the next trip started

Example:

08:08 -> floor 7 -> passengers 0
08:10 -> floor 2 -> passengers 0
08:12 -> floor 2 -> passengers 1

Before next trip started:

elevator moved from floor 7 -> floor 2 empty

So:

empty_floors_travelled = 5

using:

ABS(7 - 2)
6. Empty Movement Status Rule

If:

empty_floors_travelled > 0

then trip status becomes:

EMPTY_MOVEMENT

unless a higher priority rule exists.

7. Status Priority Rule

Trip status must follow this priority order:

Highest Priority
CAPACITY_VIOLATION
Second Priority
EMPTY_MOVEMENT
Otherwise
NORMAL
Expected Output Columns
Column Name	Description
elevator_id	Elevator identifier
trip_id	Trip sequence number per elevator
trip_start_time	Trip start timestamp
trip_end_time	Trip end timestamp
max_passengers	Maximum passengers during trip
empty_floors_travelled	Empty floors travelled before trip
trip_status	Final trip classification
Example
Input
08:08 -> floor 7 -> passengers 0
08:10 -> floor 2 -> passengers 0
08:12 -> floor 2 -> passengers 1
08:14 -> floor 6 -> passengers 2
08:18 -> floor 8 -> passengers 0
Explanation

Before trip started:

elevator moved empty:
7 -> 2

Empty movement:

ABS(7 - 2) = 5

Trip:

08:12 -> 08:18

Maximum passengers:

2

Final status:

EMPTY_MOVEMENT
Correct Expected Output
elevator_id | trip_id | trip_start_time     | trip_end_time       | max_passengers | empty_floors_travelled | trip_status
------------|---------|---------------------|---------------------|----------------|-------------------------|----------------------
E1          | 1       | 2024-01-01 08:02:00 | 2024-01-01 08:08:00 | 3              | 0                       | NORMAL
E1          | 2       | 2024-01-01 08:12:00 | 2024-01-01 08:18:00 | 2              | 5                       | EMPTY_MOVEMENT
E2          | 1       | 2024-01-01 09:02:00 | 2024-01-01 09:06:00 | 6              | 0                       | CAPACITY_VIOLATION
E2          | 2       | 2024-01-01 09:10:00 | 2024-01-01 09:12:00 | 2              | 10                      | EMPTY_MOVEMENT
E3          | 1       | 2024-01-01 10:01:00 | 2024-01-01 10:13:00 | 4              | 0                       | NORMAL
E4          | 1       | 2024-01-01 11:05:00 | 2024-01-01 11:08:00 | 1              | 8                       | EMPTY_MOVEMENT
E5          | 1       | 2024-01-01 12:02:00 | 2024-01-01 12:06:00 | 6              | 0                       | CAPACITY_VIOLATION
Key Challenges

This problem tests:

Trip reconstruction
Stateful event analysis
Sessionization
Window functions
Previous-row comparison
Empty-state movement tracking
Capacity validation
Event grouping
Why This Problem Is Hard

This is not a simple aggregation problem.

The difficult part is correctly reconstructing trip boundaries while simultaneously tracking:

passenger transitions
idle elevator movement
pre-trip empty travel
trip-level metrics
priority-based status assignment

This closely resembles real operational analytics problems used in smart infrastructure and IoT monitoring systems. 
