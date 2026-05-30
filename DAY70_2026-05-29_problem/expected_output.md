 | order_id | user_id | first_attempt_time  | first_gateway | successful_attempt_time | successful_gateway | total_attempts | failed_attempts | success_attempts | final_order_status | payment_recovery_status        |
|----------|---------|---------------------|---------------|-------------------------|--------------------|----------------|-----------------|------------------|--------------------|--------------------------------|
| 1001 | 101 | 2024-01-01 10:00:00 | G1 | 2024-01-01 10:00:00 | G1 | 1 | 0 | 1 | ORDER_CREATED | FIRST_ATTEMPT_SUCCESS |
| 1002 | 102 | 2024-01-01 10:05:00 | G1 | 2024-01-01 10:10:00 | G1 | 2 | 1 | 1 | ORDER_CREATED | RECOVERED_AFTER_FAILURE |
| 1003 | 103 | 2024-01-01 10:15:00 | G1 | 2024-01-01 10:20:00 | G2 | 2 | 1 | 1 | ORDER_CREATED | RECOVERED_AFTER_GATEWAY_SWITCH |
| 1004 | 104 | 2024-01-01 10:25:00 | G1 | NULL | NULL | 2 | 2 | 0 | ORDER_CREATED | FAILED_NEVER_RECOVERED |
| 1005 | 105 | 2024-01-01 10:35:00 | G1 | 2024-01-01 10:50:00 | G1 | 2 | 1 | 1 | ORDER_EXPIRED | SUCCESS_AFTER_ORDER_EXPIRED |
| 1006 | 106 | 2024-01-01 11:00:00 | G1 | 2024-01-01 11:00:00 | G1 | 2 | 0 | 2 | ORDER_CREATED | DUPLICATE_SUCCESS |
| 1007 | 107 | 2024-01-01 11:10:00 | G2 | 2024-01-01 11:20:00 | G2 | 2 | 1 | 1 | ORDER_CANCELLED | REVENUE_LEAKAGE |
| 1008 | 108 | 2024-01-01 11:25:00 | G1 | NULL | NULL | 2 | 1 | 0 | ORDER_CREATED | FAILED_NEVER_RECOVERED |
| 1009 | 109 | 2024-01-01 11:35:00 | G1 | 2024-01-01 11:45:00 | G1 | 3 | 2 | 1 | ORDER_CREATED | RECOVERED_AFTER_FAILURE |
| 1010 | 110 | 2024-01-01 12:00:00 | G1 | 2024-01-01 12:10:00 | G3 | 3 | 2 | 1 | ORDER_CREATED | RECOVERED_AFTER_GATEWAY_SWITCH |
| 1011 | 111 | 2024-01-01 12:15:00 | G1 | 2024-01-01 12:15:00 | G1 | 2 | 0 | 1 | ORDER_CREATED | FIRST_ATTEMPT_SUCCESS |
| 1012 | 112 | 2024-01-01 12:25:00 | G2 | 2024-01-01 12:25:00 | G2 | 1 | 0 | 1 | ORDER_CANCELLED | REVENUE_LEAKAGE |
| 1013 | 113 | 2024-01-01 12:30:00 | G1 | NULL | NULL | 1 | 0 | 0 | ORDER_CREATED | FAILED_NEVER_RECOVERED |
| 1014 | 114 | 2024-01-01 12:35:00 | G1 | 2024-01-01 12:35:00 | G1 | 2 | 0 | 2 | ORDER_CREATED | DUPLICATE_SUCCESS |
| 1015 | 115 | 2024-01-01 12:40:00 | G1 | 2024-01-01 12:55:00 | G2 | 3 | 1 | 2 | ORDER_EXPIRED | DUPLICATE_SUCCESS |
