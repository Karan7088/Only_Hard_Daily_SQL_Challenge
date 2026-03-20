 🔥 Day 40 – Only Hard SQL Challenge
🏨 Hotel Booking System (Overlapping Intervals)
🧠 Problem Statement

You are given a table hotel_bookings containing booking details for different rooms.

Each booking has:

room_id

check_in

check_out

Your task is to analyze booking data and generate insights while correctly handling overlapping intervals.

📊 Table Schema
CREATE TABLE hotel_bookings (
    booking_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE
);
🎯 Objectives

For each room_id, calculate:

Total Booked Days

Simple sum of all booking durations

Overlaps are counted multiple times

Unique Occupied Days

Actual days the room was occupied

Overlapping days should be counted only once

Overbooking Flag

If overlapping bookings exist → 1

Else → 0

⚠️ Important Rules

Booking interval follows:

[check_in, check_out)

👉 check_out is excluded

Example:

2026-03-01 → 2026-03-05 = 4 days (1,2,3,4)
💀 Challenges

Handling overlapping intervals

Avoiding double counting

Dealing with:

Duplicate bookings

Nested overlaps

Boundary-touch cases

Zero-day bookings

🧠 Approach
Step 1: Base Table

Calculate booking duration using:

DATEDIFF(check_out, check_in)

Assign row number per room ordered by check_in

Step 2: Overlap Detection

For each booking:

Compare with previous bookings in same room

Use:

MAX(check_out) of previous rows
Step 3: Unique Days Logic

If fully overlapping → count 0

If partially overlapping → count only non-overlapping portion

Else → count full duration

Step 4: Aggregation

For each room:

SUM(total days)

SUM(unique days)

Compare both to detect overbooking

📊 Final Output
room_id	total_booked_days	unique_occupied_days	over_booked
101	19	14	1
102	12	9	1
103	16	8	1
104	38	24	1
105	26	24	1
🚀 Key Learnings

Interval problems in SQL

Window functions (ROW_NUMBER)

Correlated subqueries

Handling real-world booking logic

Difference between:

Total vs Unique metrics

💡 Real-World Applications

Hotel reservation systems

Airbnb availability tracking

Hospital bed allocation

Resource scheduling systems

🔥 Difficulty Level

💀 Hard / Interview+ Level

👨‍💻 Author Note

This problem tests deep understanding of:

Time intervals

Overlap logic

Edge case handling

If you solved this correctly — you're already ahead of most SQL learners 🚀
