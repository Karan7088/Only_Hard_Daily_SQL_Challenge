# Day 55 - Delivery SLA Violation Detection

## Problem Statement

You are given a table containing delivery tracking events for multiple orders.

Each order can move through different delivery stages such as:

- PLACED
- PICKED_UP
- OUT_FOR_DELIVERY
- DELIVERED
- CANCELLED

Your task is to identify orders that violated the delivery SLA rules.

The output should return only those orders that have some kind of violation.

---

## Business Context

In real-world food delivery, logistics, and quick-commerce systems, every order goes through multiple operational stages.

A delay at any stage can affect customer experience, rider performance, and delivery reliability.

This problem focuses on detecting the first root cause of an SLA violation from messy event-level data.

---

## Required Event Flow

For a successfully completed order, the required flow is:


PLACED -> PICKED_UP -> OUT_FOR_DELIVERY -> DELIVERED

Only these four events are mandatory for SLA validation.

SLA Rules

An order is considered violated if any of the following conditions are true:

1. Missing Event

If any required event is missing:

PLACED
PICKED_UP
OUT_FOR_DELIVERY
DELIVERED

Then mark the order as:

MISSING_EVENT
2. Invalid Event Sequence

If all required events exist, but they are not in the correct order:

PLACED <= PICKED_UP <= OUT_FOR_DELIVERY <= DELIVERED

Then mark the order as:

INVALID_EVENT_SEQUENCE

Same timestamps are allowed.

Example:

PLACED = 18:00
PICKED_UP = 18:00

This is valid because the sequence is still non-decreasing.

3. Pickup Delay

If pickup happens more than 30 minutes after the order was placed:

PICKED_UP - PLACED > 30 minutes

Then mark the order as:

PICKUP_DELAY
4. Out For Delivery Delay

If the order goes out for delivery more than 60 minutes after pickup:

OUT_FOR_DELIVERY - PICKED_UP > 60 minutes

Then mark the order as:

OUT_FOR_DELIVERY_DELAY
5. Delivery Delay

If delivery happens more than 45 minutes after the order goes out for delivery:

DELIVERED - OUT_FOR_DELIVERY > 45 minutes

Then mark the order as:

DELIVERY_DELAY
Duplicate Event Rule

If the same event appears multiple times for an order, use the first occurrence of that event.

Example:

PICKED_UP = 16:10
PICKED_UP = 16:15

Use:

PICKED_UP = 16:10

Duplicate events should not be treated as a violation.

Cancelled Order Rule

If an order is cancelled and does not have all required successful delivery events, it should be marked as:

MISSING_EVENT
Violation Priority

Return only the first root cause violation for each order.

Priority order:

1. MISSING_EVENT
2. INVALID_EVENT_SEQUENCE
3. PICKUP_DELAY
4. OUT_FOR_DELIVERY_DELAY
5. DELIVERY_DELAY

If multiple SLA rules fail for the same order, return only the highest-priority violation.

Example:

PLACED -> PICKED_UP delay = 90 minutes
PICKED_UP -> OUT_FOR_DELIVERY delay = 90 minutes
OUT_FOR_DELIVERY -> DELIVERED delay = 120 minutes

Output:

PICKUP_DELAY

Because pickup delay is the first root cause.

Expected Output Columns
order_id
violation_reason
