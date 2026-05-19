Day 61 — Food Delivery SLA Breach Detection
Problem Overview

In real-world food delivery platforms, every order goes through multiple operational stages before reaching the customer.

Operations teams continuously monitor these stages using SLA (Service Level Agreement) rules to identify delays and operational bottlenecks.

Your task is to analyze delivery event logs and detect orders that violated SLA thresholds during any stage of the delivery lifecycle.

The challenge becomes difficult because the dataset contains:

Duplicate events
Missing stages
Cancelled orders
Invalid delivery flows
Multiple SLA checks within the same order

This problem simulates real production-style event stream analysis commonly seen in delivery, logistics, and operational analytics systems.

Expected Delivery Flow

A valid order must follow this exact sequence:

PLACED → ACCEPTED → PICKED_UP → DELIVERED

Orders missing any mandatory stage are considered invalid and must be ignored.

Cancelled orders must also be ignored completely.

SLA Rules

The following SLA thresholds are defined for each delivery stage:

Stage	Maximum Allowed Time
PLACED → ACCEPTED	10 Minutes
ACCEPTED → PICKED_UP	30 Minutes
PICKED_UP → DELIVERED	40 Minutes

If actual time exceeds the allowed threshold, that stage is considered an SLA breach.

Breach Time Calculation

Breach duration is calculated as:

Actual Duration - Allowed SLA Duration

Example:

PLACED at 10:00
ACCEPTED at 10:15

Actual Duration = 15 Minutes
Allowed Duration = 10 Minutes

Breach = 5 Minutes
Important Rules
1. Ignore Cancelled Orders

If an order contains a CANCELLED event at any point, the order must not be considered for SLA analysis.

2. Ignore Invalid Flows

Orders missing any required delivery stage must be excluded.

Example invalid cases:

Missing ACCEPTED
Missing PICKED_UP
Missing DELIVERED
3. Handle Duplicate Status Events

Some orders may contain duplicate statuses.

Example:

ACCEPTED
ACCEPTED

In such cases, use the earliest valid occurrence only.

4. Maintain Correct Event Sequence

The analysis must always respect chronological event order using:

event_time
5. One Order Can Have Multiple Breaches

An order may violate multiple SLA stages simultaneously.

Example:

PLACED → ACCEPTED breached
PICKED_UP → DELIVERED breached

Both breaches should appear separately in the final output.

Real-World Concepts Tested

This problem evaluates advanced SQL skills including:

Event stream analysis
Sequential workflow validation
SLA monitoring
Duplicate event handling
Operational analytics
Time difference calculations
Multi-stage breach detection
Data quality filtering
Edge Cases Included

The dataset intentionally includes difficult scenarios such as:

Duplicate ACCEPTED events
Orders without ACCEPTED stage
Cancelled deliveries
Multiple SLA violations in a single order
Orders with valid and invalid transitions
Exact boundary timing cases
Goal

For every valid order:

Build the complete delivery timeline
Validate the workflow sequence
Calculate time spent between each stage
Detect SLA breaches
Calculate breach duration for every violated stage

The final output should contain only breached stages along with their breach duration. 
