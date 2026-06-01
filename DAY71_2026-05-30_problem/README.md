 # Day 71 — Multi-Warehouse Inventory Transfer Chain Detection

## Problem Statement

A company manages inventory across multiple warehouses.

Each product can move through different inventory events such as receipts, sales, warehouse transfers, and manual stock adjustments.

Sometimes stock does not directly disappear from the first warehouse. Instead, it moves across multiple warehouses and later gets adjusted, mismatched, duplicated, or lost during transfer.

Your task is to identify suspicious inventory movement chains and calculate the anomaly quantity for each product.

---

## Event Types

### RECEIPT

Stock entered the system.

### SALE

Stock was sold to customers.

### TRANSFER_OUT

Stock left one warehouse.

### TRANSFER_IN

Stock arrived at another warehouse.

### ADJUSTMENT

Manual stock correction, usually done during audits.

Negative adjustment means stock was removed.

---

## Suspicious Conditions

A product should appear in the final output if at least one of the following conditions is true:

1. Stock moved through a transfer chain and later had a negative adjustment.
2. A TRANSFER_OUT event does not have a matching TRANSFER_IN.
3. A TRANSFER_OUT event has multiple matching TRANSFER_IN records.
4. TRANSFER_OUT quantity and TRANSFER_IN quantity do not match.
5. A product has negative adjustment with no sale.

---

## Transfer Matching Rule

A transfer is matched using:

- product_id
- reference_id
- quantity

A valid transfer should have exactly one TRANSFER_OUT and exactly one matching TRANSFER_IN.

---

## Output Columns Explanation

### product_id

The product involved in the suspicious inventory movement.

Example:

P2

---

### end_event_id

The event where the suspicious chain or anomaly ends.

Example:

For P2, the chain ends at adjustment event 10.

---

### end_warehouse

Warehouse where the chain or anomaly ended.

Example:

P2 ends in W4.

---

### chain_id

Unique sequence number assigned to each suspicious chain.

---

### chain_start_warehouse

Warehouse where the chain started.

Example:

P2 starts from W1.

---

### chain_end_warehouse

Final warehouse reached by the chain.

For special anomaly cases:

- MISSING_TRANSFER_IN means stock was transferred out but never received.
- DUPLICATE_TRANSFER means one transfer was received more than once.

---

### warehouses_involved

Full warehouse path followed by the product.

Example:

W1->W2->W3->W4

---

### total_transfer_hops

Number of warehouse-to-warehouse movements.

Example:

W1->W2->W3->W4 has 3 hops.

---

### received_qty

Total received quantity for the product.

Calculated from RECEIPT events.

---

### sold_qty

Total sold quantity for the product.

Calculated from SALE events.

---

### adjusted_qty

Total stock removed through negative adjustment.

Example:

ADJUSTMENT = -120

adjusted_qty = 120

---

### missing_qty

The suspicious anomaly quantity.

For this challenge, missing_qty is calculated based on anomaly type:

#### Adjustment Loss

If stock disappears through negative adjustment:

missing_qty = ABS(adjustment quantity)

Example:

ADJUSTMENT = -120

missing_qty = 120

---

#### Missing Transfer-In

If stock was transferred out but no matching transfer-in exists:

missing_qty = TRANSFER_OUT quantity

Example:

TRANSFER_OUT = 60

missing_qty = 60

---

#### Duplicate Transfer-In

If one transfer-out has multiple matching transfer-in records:

missing_qty = 0

Reason:

This is a duplicate transfer anomaly, but not confirmed stock loss.

---

#### Quantity Mismatch

If transfer-out and transfer-in quantities do not match:

missing_qty = ABS(TRANSFER_OUT quantity - TRANSFER_IN quantity)

Example:

TRANSFER_OUT = 100  
TRANSFER_IN = 90

missing_qty = 10

---

### risk_level

Risk level is based on missing_qty.

Rules:

CRITICAL: missing_qty > 100  
HIGH: missing_qty > 50  
MEDIUM: missing_qty > 20  
LOW: missing_qty <= 20

---

## Example Explanation

### Example Product: P2

Inventory events:

- 200 units received in W1
- 120 units moved from W1 to W2
- 120 units moved from W2 to W3
- 120 units moved from W3 to W4
- 120 units adjusted out from W4
- No sale happened

Warehouse path:

W1->W2->W3->W4

Total hops:

3

Since stock was transferred across multiple warehouses and then removed through adjustment, it is suspicious.

Calculation:

received_qty = 200  
sold_qty = 0  
adjusted_qty = 120  
missing_qty = 120

Risk:

missing_qty = 120

Since 120 > 100:

risk_level = CRITICAL

Final row:

P2 | 10 | W4 | 1 | W1 | W4 | W1->W2->W3->W4 | 3 | 200 | 0 | 120 | 120 | CRITICAL

---

## Final Expected Output

| product_id | end_event_id | end_warehouse | chain_id | chain_start_warehouse | chain_end_warehouse | warehouses_involved | total_transfer_hops | received_qty | sold_qty | adjusted_qty | missing_qty | risk_level |
|------------|--------------|---------------|----------|-----------------------|---------------------|---------------------|---------------------|--------------|----------|--------------|-------------|------------|
| P2  | 10 | W4 | 1 | W1 | W4 | W1->W2->W3->W4 | 3 | 200 | 0 | 120 | 120 | CRITICAL |
| P4  | 15 | W1 | 2 | W1 | MISSING_TRANSFER_IN | W1 | 1 | 90 | 0 | 0 | 60 | HIGH |
| P5  | 20 | W3 | 3 | W1 | DUPLICATE_TRANSFER | W1->W2->W3 | 1 | 100 | 0 | 0 | 0 | LOW |
| P7  | 35 | W8 | 4 | W5 | W8 | W5->W6->W7->W8 | 3 | 500 | 0 | 250 | 250 | CRITICAL |
| P8  | 39 | W2 | 5 | W1 | W2 | W1->W2 | 1 | 100 | 0 | 30 | 30 | MEDIUM |
| P9  | 41 | W1 | 6 | W1 | W1 | W1 | 0 | 50 | 0 | 10 | 10 | LOW |
| P10 | 44 | W2 | 7 | W1 | W2 | W1->W2 | 1 | 200 | 0 | 0 | 10 | LOW |

---

## Why This Problem Is Hard

This is not a simple aggregation problem.

It requires:

- Matching transfer-out and transfer-in events
- Detecting missing transfer records
- Detecting duplicate transfer-in records
- Finding quantity mismatches
- Building warehouse movement chains
- Handling adjustment-based losses
- Calculating risk level from anomaly quantity
- Separating real loss from duplicate data issues

---

## Concepts Tested

- Recursive CTE
- Graph traversal
- Event stream analysis
- Inventory reconciliation
- Transfer chain detection
- Conditional aggregation
- Data quality checks
- Supply chain analytics
- Fraud and anomaly detection

---

## Real-World Relevance

This type of problem is common in:

- E-commerce warehouses
- Retail supply chain analytics
- Logistics companies
- Inventory audit systems
- Data engineering pipelines
- Fraud detection teams

It helps identify stock losses, broken transfers, duplicate records, and suspicious warehouse movements.
