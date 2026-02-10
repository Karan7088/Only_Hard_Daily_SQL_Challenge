## Expected Output

| sid | loc          | tot | val | avg_t | min_t | max_t | jump | idle_h | hot_h | idle_f | anom_f |
|-----|--------------|-----|-----|-------|-------|-------|------|--------|-------|--------|--------|
| 1   | Boiler Room  | 11  | 11  | 79.82 | 60.00 | 120.0 | 53.0 | 184    | 2     | 1      | 1      |
| 2   | Assembly Ln  | 9   | 9   | 70.44 | -10.0 | 200.0 | 150. | 1      | 1     | 0      | 1      |
| 3   | Warehouse    | 7   | 3   | 62.33 | 60.00 | 65.00 | 3.0  | 1      | 0     | 0      | 0      |
| 4   | Lab          | 8   | 7   | 78.86 | 40.00 | 100.0 | 60.0 | 1      | 3     | 0      | 0      |
| 5   | Server Room  | 5   | 5   | 83.00 | 80.00 | 85.00 | 0.0  | 1      | 3     | 0      | 0      |
| 6   | Backup Room  | 1   | 1   | 55.00 | 55.00 | 55.00 | 0.0  | 0      | 0     | 0      | 0      |



### Column Mapping

| Short Name | Full Meaning 
|-----------|-------------
| sid       | sensor_id 
| loc       | location 
| tot       | total_readings 
| val       | valid_readings (non-null temperature) 
| avg_t     | average temperature 
| min_t     | minimum temperature 
| max_t     | maximum temperature 
| jump      | maximum temperature jump between consecutive readings 
| idle_h    | longest inactivity duration (hours) 
| hot_h     | longest continuous overheated duration (temperature ≥ 80) 
| idle_f    | inactive_flag (1 if idle_h > 24 hours) 
| anom_f    | anomaly_temp_flag (1 if max_t > 100 or min_t < 0) 