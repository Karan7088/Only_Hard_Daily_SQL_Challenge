 Day 62 — Only Hard Daily SQL Challenge
Dynamic Ride Surge Pricing Detection
Date: 2026-05-22
Problem Overview

Ride-sharing platforms continuously monitor ride demand and driver availability to decide whether surge pricing should be activated.

In this challenge, you are given:

Ride request events
Driver ONLINE/OFFLINE status events

Your task is to detect 15-minute city-level time buckets where demand becomes significantly higher than available driver capacity.

Instead of simply counting drivers, this problem introduces a more realistic operational metric:

effective_drivers

which is calculated using actual driver availability duration inside each bucket.

This closely simulates how real-world mobility and logistics companies monitor marketplace imbalance.

Objective

For every city and every 15-minute time bucket:

Count total ride requests
Calculate total active driver minutes
Convert active minutes into effective drivers
Calculate demand-to-supply ratio
Detect whether surge pricing should be enabled
Time Bucket Rules

The dataset must be divided into fixed 15-minute buckets.

Examples:

09:00 → 09:15
09:15 → 09:30
10:00 → 10:15

A ride request belongs to a bucket if:

window_start <= request_time < window_end
Driver Availability Logic

Driver events represent state changes.

Example:

ONLINE at 08:55
OFFLINE at 09:12

This means the driver stayed active continuously from:

08:55 → 09:12

The challenge requires calculating how many minutes of this interval overlap with each bucket.

Active Driver Minutes

For every bucket:

active_driver_minutes

represents the total number of minutes all drivers remained ONLINE inside that bucket.

Example:

Driver A active for 15 mins
Driver B active for 12 mins
Driver C active for 9 mins

Then:

active_driver_minutes = 36
Effective Drivers

Instead of directly counting drivers, convert total active minutes into equivalent fully-available drivers.

Formula:

effective_drivers = active_driver_minutes / 15

Example:

36 / 15 = 2.40

Meaning:

system effectively had 2.4 fully-available drivers during that bucket
Surge Ratio Calculation

The demand-to-supply ratio is calculated as:

ratio = ride_requests / effective_drivers

Equivalent formula:

ratio = ride_requests / (active_driver_minutes / 15)
Surge Detection Rule

If:

ratio >= 3

then:

SURGE_ON

Otherwise:

NORMAL
Important Rules
1. Use Fixed 15-Minute Buckets

Do not use rolling windows.

All calculations must be bucket-based.

2. Driver Availability is Continuous

ONLINE events continue until the next OFFLINE event.

Do not treat ONLINE rows as isolated records.

3. Calculate Interval Overlap

For every driver:

ONLINE interval ∩ bucket interval

must be calculated correctly.

4. OFFLINE Events Stop Availability

If a driver goes OFFLINE before bucket end, only count active overlap duration.

Example:

ONLINE 08:56
OFFLINE 09:12

For bucket:

09:00 → 09:15

active duration becomes:

09:00 → 09:12 = 12 minutes
5. Carry Previous ONLINE State Forward

If a driver became ONLINE before the bucket started, they may still remain active during the bucket.

Example:

ONLINE at 08:55

must still contribute to:

09:00 → 09:15

bucket.

Real-World Concepts Tested

This problem evaluates advanced SQL concepts including:

Event stream analysis
Stateful interval reconstruction
Time bucket analytics
Interval overlap calculations
Dynamic operational metrics
Driver marketplace balancing
Surge pricing analytics
Real-time mobility analytics
Edge Cases Included

The dataset intentionally includes:

Drivers going OFFLINE mid-bucket
Drivers becoming ONLINE mid-bucket
Sparse ride request buckets
Multiple cities
Partial driver availability
Dynamic supply fluctuations
Carry-forward ONLINE states


Goal

Build a city-level surge pricing engine capable of:

Measuring real demand
Measuring true driver availability
Converting partial availability into effective supply
Detecting operational imbalance
Automatically identifying surge conditions

This problem reflects real production-style analytics commonly used in ride-sharing and logistics platforms.












