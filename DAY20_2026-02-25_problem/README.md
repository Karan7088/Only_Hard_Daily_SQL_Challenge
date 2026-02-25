🎟️ Day 20 SQL Seat Allocation System – Advanced Window Function Challenge

Date:2026-02-25

📌 Problem Title
Dynamic Seat Allocation Based on Booking Time with Overlap Handling

📖 Problem Statement (Detailed)

You are given a table:

bookings
---------
booking_id   INT
room_id      INT
start_time   DATETIME
end_time     DATETIME

Each row represents a booking for a specific room.

Your task is to assign seat numbers dynamically for each booking inside each room based on time availability.

🎯 Objective

For every room_id, assign seats such that:

✅ Bookings are ordered by:

room_id

start_time

booking_id

✅ A booking is valid only if:

start_time < end_time

✅ If two bookings overlap in time in the same room, they must get different seat numbers.

✅ If a booking ends before another booking starts, the seat can be reused.

✅ If multiple bookings start at the same time in the same room:

They must get different seats.

Allocation should be stable and deterministic (use booking_id as tie-breaker).

✅ Seat numbering restarts for every room.

🧠 What Makes This Hard?

This is NOT simple ranking.

You must handle:

Overlapping time intervals

Seat reuse

Simultaneous start times

Dynamic seat reassignment

Partitioned window logic

Gap detection between time intervals

This is essentially a temporal allocation problem.

🛠️ How to Think About the Solution
Step 1️⃣ – Filter Invalid Sessions

Remove invalid bookings:

WHERE start_time < end_time
Step 2️⃣ – Order the Data Properly

Within each room:

ORDER BY room_id, start_time, booking_id

This ensures deterministic seat assignment.

Step 3️⃣ – Detect Overlaps

Use LAG() to compare:

Current start_time

Previous end_time

If:

previous_end_time <= current_start_time

👉 Seat can be reused.

Else:

👉 New seat required.

Step 4️⃣ – Handle Simultaneous Start Times

If multiple rows have:

same room_id
same start_time

Then:

They must get different seats.

Use ROW_NUMBER() partitioned by (room_id, start_time).

Step 5️⃣ – Generate Dynamic Seat Logic

Using:

ROW_NUMBER()

DENSE_RANK()

LAG()

Conditional CASE logic

Window partitions

We compute an intermediate seat tracker (st), then finally:

DENSE_RANK() OVER (PARTITION BY room_id ORDER BY st)

This ensures:

Seats restart per room

No gaps

Correct reuse logic

📤 Expected Output Format
booking_id | room_id | seats
-----------+---------+------
2          | 1       | 1
9          | 1       | 1
13         | 1       | 2
7          | 1       | 3
1          | 1       | 3
...