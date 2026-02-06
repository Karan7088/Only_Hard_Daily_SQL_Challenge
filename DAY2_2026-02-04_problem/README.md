# Customer Lifetime Value with Time-Decay

**Date**: 2026-02-04 
**Difficulty**: ⭐⭐⭐⭐⭐  
**Topics**: Time-decay, Segmentation, Window Functions

## Problem

Calculate LTV for each customer using time-decay weighting and segment them.

## Formula
LTV = SUM(order_amount × discount_adjustment × time_decay_factor)
discount_adjustment = (order_amount - discount_amount) / order_amount
time_decay_factor = EXP(-0.1 × months_since_first_order)


## Segments

- **High**: LTV > 500
- **Medium**: 100-500
- **Low**: < 100
- **At Risk**: No orders 90+ days

## Edge Cases

- $0 orders (avoid division by zero)
- Single order customers
- No completed orders (LTV = 0)