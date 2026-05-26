2026-05-26 — Day 67 of Only Hard Daily SQL Challenge
Dynamic Pricing Abuse Detection
Problem Statement

Modern e-commerce platforms continuously update product prices using dynamic pricing systems.

Sometimes pricing engines fail temporarily and products become available at extremely incorrect prices for a short period of time.

These temporary incorrect prices are called:

GLITCH PRICES

Fraudulent or opportunistic customers may quickly place multiple orders before the pricing system corrects the mistake.

The business wants to identify customers who repeatedly exploited these pricing glitches and caused financial losses.

Your task is to detect customers involved in pricing abuse behavior.

Objective

Identify customer-product combinations where:

purchases happened during glitch pricing windows
products were sold below correct price
customers repeatedly exploited the incorrect pricing
the company suffered measurable revenue loss
Dynamic Pricing Logic

Each product has a historical pricing timeline.

For every time interval:

start_time
end_time

the product may have:

NORMAL price
OR
GLITCH price

The correct active price must always be determined based on:

order_time

falling inside the valid price interval.

Glitch Window Definition

A glitch window exists when:

correct_price > charged_price

and:

price_status = 'GLITCH'
Time Matching Rule

Orders belong to a price window only when:

order_time >= start_time
AND
order_time < end_time
Important Boundary Rule

Orders placed exactly at:

glitch_end_time

must NOT belong to the glitch window.

Reason:

The corrected pricing interval starts immediately at that timestamp.
Example

If glitch window is:

10:00 -> 10:30

then:

10:29:59 -> GLITCH
10:30:00 -> NORMAL PRICE
Abuse Detection Logic

A customer is considered suspicious only when:

same customer
+
same product

has:

at least 2 orders

during glitch pricing intervals.

Single accidental purchases should not be treated as abuse.

Output Columns
customer_id
product_id
orders_placed
total_expected_amount
total_paid_amount
total_loss
abuse_sessions
risk_level
Column Explanation
customer_id

Customer who placed orders during glitch pricing windows.

product_id

Product purchased during the pricing glitch.

orders_placed

Total number of valid glitch-window orders for the same:

customer + product

combination.

total_expected_amount

How much the customer SHOULD have paid using correct pricing.

Calculated using:

correct_price × quantity

for all qualifying glitch orders.

total_paid_amount

Actual money paid by the customer.

Calculated using:

SUM(amount_paid)

across all qualifying orders.

total_loss

Financial loss suffered by the company.

Formula:

total_expected_amount
-
total_paid_amount
abuse_sessions

Number of separate glitch intervals exploited by the customer.

If a customer abused multiple independent glitch windows:

abuse_sessions > 1
risk_level

Determined using:

orders_placed
AND
total_loss
Risk Classification Rules
HIGH

When:

orders_placed >= 3
OR
total_loss >= 1500

Represents aggressive or high-loss abuse behavior.

MEDIUM

When:

orders_placed = 2

and HIGH conditions are not satisfied.

Important Business Rules
1. Use Correct Historical Price

Price must be determined using:

order_time

inside correct historical interval.

2. Ignore Normal Pricing Windows

Only:

price_status = 'GLITCH'

should be analyzed.

3. Same Product Only

Orders for different products must never combine together.

4. Multiple Orders Matter

Repeated exploitation behavior is more suspicious than a single accidental purchase.

5. Prevent Incorrect Boundary Inclusion

Orders exactly at:

end_time

must belong to next price interval.

Edge Cases Covered

This dataset includes:

multiple glitch windows
repeated abuse orders
exact boundary timestamps
overlapping pricing intervals
normal purchases
large quantity purchases
mixed-product customers
single accidental purchases
high-loss exploitation cases
Real-World Use Cases

This type of analysis is commonly used in:

e-commerce fraud detection
pricing engine monitoring
marketplace risk analytics
discount abuse prevention
revenue leakage monitoring
dynamic pricing systems
retail operations analytics
Difficulty Level
EXTREME HARD / REAL-WORLD E-COMMERCE ANALYTICS

This problem requires strong understanding of:

interval joins
temporal pricing logic
historical state matching
financial loss calculations
behavioral fraud detection
edge-case handling
time-based analytics 
