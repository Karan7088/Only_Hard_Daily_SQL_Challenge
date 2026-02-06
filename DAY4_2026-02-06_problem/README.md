# Moving Metrics with Gaps

**Date**: 2026-02-06 
**Difficulty**: ⭐⭐⭐⭐⭐  
**Topics**: Rolling Windows, Gap Handling, Running Totals

## Problem

Calculate per-order metrics handling irregular purchase patterns.

## Output Columns

- `rolling_3avg`: Average of current + previous 2 orders
- `days_since_prev_order`: Days from previous order (0 if same day)
- `cumulative_categories`: Distinct categories up to this order
- `running_category_total`: Orders in same category so far

## Edge Cases

- Same-day multiple orders
- First order (NULL days_since)
- 90+ day gaps
- Single order customers