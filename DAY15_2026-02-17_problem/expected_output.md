| cycle_id | path                    | total_amount | user_count | has_high_risk | duration_hours |
|----------|-------------------------|--------------|------------|---------------|----------------|
| 1        | 103→104→105→106→103     | 126000.00    | 5          | YES           | 23             |
| 2        | 101→103→105→101         | 123000.00    | 4          | YES           | 2              |
| 3        | 101→102→103→101         | 48000.00     | 4          | YES           | 23             |



## Column Description

- **cycle_id** → Unique identifier assigned to each detected cycle  
- **path** → Ordered transaction flow representing cyclic fund movement  
- **total_amount** → Sum of all transaction amounts in the cycle  
- **user_count** → Number of unique users involved in the cycle  
- **has_high_risk** → YES if any transaction exceeds the defined high-risk threshold  
- **duration_hours** → Time difference in hours between first and last transaction  

---

## Key Insights

- All detected cycles are marked as high risk (YES).
- Cycle 1 has the highest total transaction volume.
- Cycle 2 has the shortest duration (2 hours), indicating rapid movement.
- Cycles 1 and 3 span 23 hours.

Bas itna hi.
Ab ye GitHub pe perfectly render hoga 👍