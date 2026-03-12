# Day 32 – Hard SQL Challenge  
📅 Date: 2026-03-12

## Problem: Dynamic Pricing Optimization (Airbnb Style)

In many marketplace platforms like Airbnb, prices are not fixed.  
Instead, they change depending on **recent demand**.

If many bookings happen recently → price increases.  
If demand is low → price decreases.

This challenge simulates a **dynamic pricing engine** based on recent booking activity.

---

# Tables

## listings

Stores information about each listing and its base price.

| column | description |
|------|-------------|
| listing_id | unique id of listing |
| city | city where listing is located |
| base_price | original price before dynamic adjustment |

---

## bookings

Stores every booking event.

| column | description |
|------|-------------|
| booking_id | unique booking id |
| listing_id | listing that was booked |
| booking_date | date when booking happened |

---

# Pricing Rule

The price depends on **number of bookings in the last 7 days**.

Bookings window:

current_booking_date  
+ previous 6 days

Total window = **7 days**

| bookings_last_7_days | multiplier |
|---------------------|-----------|
| 0 – 1 | 0.9 |
| 2 – 3 | 1.0 |
| 4 – 5 | 1.1 |
| 6+ | 1.25 |

Final price formula:

dynamic_price = base_price × multiplier

---

# Task

For each booking calculate:

- booking demand in last 7 days
- adjusted dynamic price

Return:

| column | description |
|------|-------------|
| booking_id | booking identifier |
| listing_id | listing id |
| booking_date | booking date |
| city | listing city |
| base_price | original price |
| bookings_last_7_days | demand in last 7 days |
| dynamic_price | adjusted price |

---

# Column Calculation Explanation

## booking_id
Directly comes from the bookings table.

---

## listing_id
Used to group bookings belonging to the same listing.

This is important because demand must be calculated **per listing**.

---

## booking_date
Used to define the **rolling 7-day window**.

Example:

If booking_date = 2026-01-07

Window becomes:

2026-01-01 → 2026-01-07

---

## bookings_last_7_days

This counts how many bookings exist within the window:

booking_date BETWEEN (current_date - 6 days) AND current_date

Example:

Listing 1 bookings:

Jan 1  
Jan 2  
Jan 3  
Jan 5  
Jan 7  

For booking on **Jan 7**:

Window:

Jan 1 → Jan 7

Bookings inside window:

Jan 1  
Jan 2  
Jan 3  
Jan 5  
Jan 7  

Total = **5**

---

## multiplier

The multiplier depends on booking count.

Example:

5 bookings → multiplier = 1.1

---

## dynamic_price

Final price:

dynamic_price = base_price × multiplier

Example:

base_price = 100  
multiplier = 1.1  

dynamic_price = 110

---

# Example Walkthrough

Listing 4 bookings:

Jan 1  
Jan 3  
Jan 6  
Jan 7  
Jan 8  
Jan 12

---

## Booking Date = Jan 8

Window:

Jan 2 → Jan 8

Bookings in window:

Jan 3  
Jan 6  
Jan 7  
Jan 8  

Total = **4**

Multiplier = **1.1**

Price:

200 × 1.1 = **220**

---

# Concepts Tested

This problem tests advanced SQL concepts:

- rolling window calculations
- demand analysis
- conditional pricing logic
- real-world marketplace analytics

These patterns are used in:

- dynamic pricing engines
- demand forecasting
- marketplace optimization 
