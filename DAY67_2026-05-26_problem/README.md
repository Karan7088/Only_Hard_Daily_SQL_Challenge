# 2026-05-26 — Day 67 of Only Hard Daily SQL Challenge

# Dynamic Pricing Abuse Detection

## Problem Statement

Modern e-commerce platforms continuously update product prices using dynamic pricing systems.

Sometimes pricing engines fail temporarily and products become available at extremely incorrect prices for a short period of time.

These temporary incorrect prices are called:

```text
GLITCH PRICES
```

Fraudulent or opportunistic customers may quickly place multiple orders before the pricing system corrects the mistake.

The business wants to identify customers who repeatedly exploited these pricing glitches and caused financial losses.

Your task is to detect customers involved in pricing abuse behavior.

---

## Objective

Identify customer-product combinations where:

- purchases happened during glitch pricing windows
- products were sold below the correct price
- customers repeatedly exploited the incorrect pricing
- the company suffered measurable revenue loss

---

## Dynamic Pricing Logic

Each product has a historical pricing timeline.

For every time interval:

```text
start_time
end_time
```

the product may have:

```text
NORMAL price
OR
GLITCH price
```

The correct active price must always be determined based on:

```text
order_time
```

falling inside the valid price interval.

---

## Glitch Window Definition

A glitch window exists when:

```text
correct_price > charged_price
```

and:

```text
price_status = 'GLITCH'
```

---

## Time Matching Rule

Orders belong to a price window only when:

```text
order_time >= start_time
AND
order_time < end_time
```

---

## Important Boundary Rule

Orders placed exactly at:

```text
glitch_end_time
```

must **NOT** belong to the glitch window.

Reason:

```text
The corrected pricing interval starts immediately at that timestamp.
```

Example:

```text
Glitch Window: 10:00 -> 10:30

10:29:59 -> GLITCH
10:30:00 -> NORMAL PRICE
```

---

## Abuse Detection Logic

A customer is considered suspicious only when the same:

```text
customer_id + product_id
```

has:

```text
at least 2 orders
```

during glitch pricing intervals.

Single accidental purchases should not be treated as abuse.

---

## Output Columns

```text
customer_id
product_id
orders_placed
total_expected_amount
total_paid_amount
total_loss
abuse_sessions
risk_level
```

---

## Column Explanation

### customer_id

Customer who placed orders during glitch pricing windows.

---

### product_id

Product purchased during the pricing glitch.

---

### orders_placed

Total number of valid glitch-window orders for the same:

```text
customer_id + product_id
```

combination.

---

### total_expected_amount

How much the customer **should have paid** using correct pricing.

Calculated as:

```text
correct_price × quantity
```

for all qualifying glitch orders.

---

### total_paid_amount

Actual money paid by the customer.

Calculated as:

```text
SUM(amount_paid)
```

across all qualifying glitch orders.

---

### total_loss

Financial loss suffered by the company.

Formula:

```text
total_expected_amount - total_paid_amount
```

---

### abuse_sessions

Number of separate glitch intervals exploited by the customer.

If a customer abused multiple independent glitch windows:

```text
abuse_sessions > 1
```

In this dataset, each suspicious customer exploits only one glitch window.

---

### risk_level

Risk category is determined using:

```text
orders_placed
AND
total_loss
```

---

## Risk Classification Rules

### HIGH

When:

```text
orders_placed >= 3
OR
total_loss >= 1500
```

This represents aggressive or high-loss abuse behavior.

---

### MEDIUM

When:

```text
orders_placed = 2
```

and HIGH conditions are not satisfied.

---

## Important Business Rules

### 1. Use Correct Historical Price

Price must be determined using the product price interval active at:

```text
order_time
```

---

### 2. Ignore Normal Pricing Windows

Only pricing records where:

```text
price_status = 'GLITCH'
```

should be analyzed.

---

### 3. Correct Price Must Be Greater Than Charged Price

A glitch is valid only when:

```text
correct_price > charged_price
```

---

### 4. Same Customer and Same Product Only

Orders must be grouped by:

```text
customer_id + product_id
```

Orders for different products must never be combined.

---

### 5. Minimum Abuse Threshold

Only include customer-product combinations where:

```text
orders_placed >= 2
```

---

### 6. Boundary Handling

Orders exactly at:

```text
end_time
```

must belong to the next price interval, not the previous glitch interval.

---

### 7. Total Loss Calculation

Loss must be calculated only on qualifying glitch orders.

Normal orders should not contribute to:

```text
total_expected_amount
total_paid_amount
total_loss
```

---

## Edge Cases Covered

This dataset includes:

- multiple glitch windows
- repeated abuse orders
- exact boundary timestamps
- normal purchases outside glitch windows
- large quantity purchases
- mixed-product customers
- single accidental glitch purchases
- high-loss exploitation cases
- same product purchased before and after price correction

---

## Real-World Use Cases

This type of analysis is commonly used in:

- e-commerce fraud detection
- pricing engine monitoring
- marketplace risk analytics
- discount abuse prevention
- revenue leakage monitoring
- dynamic pricing systems
- retail operations analytics

---

## Difficulty Level

```text
EXTREME HARD / REAL-WORLD E-COMMERCE ANALYTICS
```

This problem requires strong understanding of:

- interval joins
- temporal pricing logic
- historical state matching
- financial loss calculations
- behavioral fraud detection
- edge-case handling
- time-based analytics
