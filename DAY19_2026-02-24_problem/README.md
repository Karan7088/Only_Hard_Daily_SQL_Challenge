🚀 Day 19 – Peak Meeting Room Concurrency (Only Hard SQL Challenge)

📅 Date: 2026-02-24
📘 Difficulty: Hard
🧠 Concepts Covered:

Window Functions

Running Totals

Event-Based Time Processing

Data Validation Logic

Handling Overlapping Intervals

🧩 Problem Statement

You are given a table that stores meeting room event logs.

Each row represents either a meeting START or END event for a room.

Your task is to:

Identify valid rooms

Calculate the maximum number of concurrent meetings in each valid room

Exclude rooms that contain invalid logs

📂 Table Structure
CREATE TABLE meeting_logs (
    room_id INT,
    event_time DATETIME,
    event_type VARCHAR(10) -- 'START' or 'END'
);
⚠️ Rules & Constraints

A room is considered valid only if:

Every START has a matching END

Running meeting count never becomes negative

Total START count = Total END count

If any of these conditions fail → exclude that room completely.

🎯 What You Need To Find

For each valid room, calculate:

🔥 The peak (maximum) number of meetings running at the same time.

This is also called:

Peak Concurrent Meetings

Maximum Overlapping Intervals

Max Running Count

🧠 How Concurrency Is Calculated

Convert:

START → +1

END → -1

Sort events by:

event_time

If same time → process END before START

Compute a running total using window function.

The highest value of the running total =
👉 Max Concurrent Meetings