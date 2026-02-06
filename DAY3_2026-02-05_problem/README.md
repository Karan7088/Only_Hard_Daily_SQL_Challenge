# Sequential Purchase Pattern Detection

**Date**: 2026-02-05 
**Difficulty**: ⭐⭐⭐⭐⭐  
**Topics**: LAG/LEAD, Pattern Matching, Conditional Aggregation

## Patterns

1. **Loyalty Loop**: Any category → [different middle] → Same category (length ≥ 3)
2. **Category Escalation**: 3+ consecutive orders with strictly increasing avg unit price
3. **Discount Hunter**: &gt;50% orders have discount_amount &gt; 0
4. **Device Switcher**: Used ≥3 different device types

## Output

One row per customer with 4 boolean flags and pattern_count (sum of flags).