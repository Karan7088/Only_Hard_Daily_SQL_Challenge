
Date:2026-02-14  

# 🚍 LeetCode 2153 – Count Passengers in Each Bus

## 🧠 Problem Understanding

Buses and passengers arrive at the station at different times.

Each bus has:
- `bus_id`
- `arrival_time`
- `capacity`

Each passenger has:
- `passenger_id`
- `arrival_time`

---

## 📜 Rules

1. A passenger can board a bus if:
   - `passenger.arrival_time <= bus.arrival_time`
   - The passenger has not boarded any previous bus.

2. Each bus has limited `capacity`.

3. If more passengers are waiting than the bus capacity,
   only `capacity` number of passengers will board.

4. Return the number of passengers that boarded each bus.

5. The final result must be ordered by `bus_id` in ascending order.

---

## 🎯 What We Need to Calculate

We must compute:

| bus_id | passengers_count |

Where:

- `passengers_count` = number of passengers who successfully boarded that bus.

---

## 🔍 How to Think About the Problem

### Step 1️⃣ Sort Everything by Time

Passengers stand in a queue ordered by `arrival_time`.

Buses also arrive in increasing `arrival_time`.

---

### Step 2️⃣ Understand the Boarding Logic

When a bus arrives:

- All passengers who arrived **before or at that time**
- And who have **not boarded any previous bus**
- Are eligible to board.

But only up to `capacity` passengers can board.

---

### Step 3️⃣ Key Idea (Very Important)

Think of passengers as one global queue.

Each bus consumes some part of that queue based on:

- Arrival time
- Remaining passengers
- Capacity

Once a passenger boards a bus:
- They cannot board another bus.

---

## 🧮 How to Calculate `passengers_count`

To compute how many passengers board each bus:

1. Rank passengers globally by arrival time.
2. For each bus:
   - Identify passengers who arrived before the bus.
   - Exclude passengers already assigned to earlier buses.
   - Limit count by bus capacity.
3. Count how many passengers were assigned to that bus.

---

## 💡 Conceptual Example

If:

Passengers arrive at:  
`[1, 2, 3, 5, 6, 7]`

Buses:
| bus_id | arrival_time | capacity |
|--------|-------------|----------|
| 1      | 2           | 1        |
| 2      | 4           | 1        |
| 3      | 7           | 2        |

Then:

- Bus 1 takes 1 passenger (arrival ≤ 2)
- Bus 2 takes next 1 passenger (arrival ≤ 4)
- Bus 3 takes next 2 passengers (arrival ≤ 7)

Final result:

| bus_id | passengers_count |
|--------|-------------------|
| 1      | 1                 |
| 2      | 1                 |
| 3      | 2                 |

---

## ⚡ Key SQL Techniques Used

- `ROW_NUMBER()` → to rank passengers
- `JOIN` → to match eligible passengers and buses
- Window functions → to manage capacity and order
- `GROUP BY` → to count passengers per bus

---

## 🏁 Final Goal

Return:

- `bus_id`
- Number of passengers who used that bus

Ordered by:

```sql
ORDER BY bus_id ASC