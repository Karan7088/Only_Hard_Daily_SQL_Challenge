| product_id | end_event_id | end_warehouse | chain_id | chain_start_warehouse | chain_end_warehouse | warehouses_involved | total_transfer_hops | received_qty | sold_qty | adjusted_qty | missing_qty | risk_level |
|------------|--------------|---------------|----------|-----------------------|---------------------|---------------------|---------------------|--------------|----------|--------------|-------------|------------|
| P2  | 10 | W4 | 1 | W1 | W4 | W1->W2->W3->W4 | 3 | 200 | 0 | 120 | 120 | CRITICAL |
| P4  | 15 | W1 | 2 | W1 | MISSING_TRANSFER_IN | W1 | 1 | 90 | 0 | 0 | 60 | HIGH |
| P5  | 20 | W3 | 3 | W1 | DUPLICATE_TRANSFER | W1->W2->W3 | 1 | 100 | 0 | 0 | 0 | LOW |
| P7  | 35 | W8 | 4 | W5 | W8 | W5->W6->W7->W8 | 3 | 500 | 0 | 250 | 250 | CRITICAL |
| P8  | 39 | W2 | 5 | W1 | W2 | W1->W2 | 1 | 100 | 0 | 30 | 30 | MEDIUM |
| P9  | 41 | W1 | 6 | W1 | W1 | W1 | 0 | 50 | 0 | 10 | 10 | LOW |
| P10 | 44 | W2 | 7 | W1 | W2 | W1->W2 | 1 | 200 | 0 | 0 | 10 | LOW | 
