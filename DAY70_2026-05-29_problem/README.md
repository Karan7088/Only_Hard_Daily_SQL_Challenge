Day 70 — Payment Recovery & Revenue Leakage Detection
Problem Statement

A company processes payments through multiple payment gateways. Customers may attempt payment several times for the same order due to gateway failures, network issues, bank timeouts, or payment retries.

The objective is to analyze payment behavior and determine the final payment recovery status for each order.

This challenge focuses on identifying successful recoveries, gateway switches, duplicate payments, revenue leakage scenarios, and orders that never recovered after payment failures.

Business Context

In real-world payment systems, a single order can have multiple payment attempts across different gateways.

Some common situations include:

Payment succeeds on the first attempt.
Initial payment fails but later succeeds.
Customer retries using a different payment gateway.
Payment succeeds after the order has already expired.
Payment succeeds after the order has been cancelled.
Multiple successful payments are recorded for the same order.
Payment attempts never recover and remain failed.

These scenarios are frequently analyzed by Data Analysts, Product Analysts, Risk Teams, and Payment Operations teams.

Classification Rules

Each order must be assigned exactly one final payment recovery status.

FIRST_ATTEMPT_SUCCESS

The very first payment attempt was successful.

RECOVERED_AFTER_FAILURE

The first payment attempt failed, but a later payment attempt succeeded using the same gateway.

RECOVERED_AFTER_GATEWAY_SWITCH

The first payment attempt failed and a later successful payment occurred through a different gateway.

FAILED_NEVER_RECOVERED

No successful payment attempt exists for the order.

This includes:

Failed attempts only
Failed + Pending attempts
Pending-only scenarios
SUCCESS_AFTER_ORDER_EXPIRED

The order received a successful payment after an order expiration event had already occurred.

REVENUE_LEAKAGE

The order was cancelled, but a successful payment was still captured and never reversed.

This represents a potential financial reconciliation issue.

DUPLICATE_SUCCESS

More than one successful payment attempt exists for the same order.

This is treated as the highest priority issue because duplicate collections may lead to customer refunds and financial discrepancies.

Priority Rules

An order may satisfy multiple conditions simultaneously.

To ensure every order receives exactly one final classification, the following priority order must be applied:

DUPLICATE_SUCCESS
REVENUE_LEAKAGE
SUCCESS_AFTER_ORDER_EXPIRED
RECOVERED_AFTER_GATEWAY_SWITCH
RECOVERED_AFTER_FAILURE
FIRST_ATTEMPT_SUCCESS
FAILED_NEVER_RECOVERED

The highest priority matching condition becomes the final status.

Expected Output

For each order return:

Order details
First payment attempt information
First gateway used
Successful payment information
Successful gateway used
Total payment attempts
Failed payment attempts
Successful payment attempts
Final order status
Payment recovery classification
Edge Cases Covered

The dataset includes:

First-attempt success
Multiple failures before recovery
Gateway switching recovery
Duplicate successful payments
Revenue leakage scenarios
Success after expiration
Success followed by reversal
Pending-only orders
Failed + pending combinations
Multiple gateway retries
Orders matching multiple classifications
Concepts Tested

This challenge evaluates:

Event stream analysis
Payment funnel tracking
Recovery analysis
Gateway migration behavior
Revenue leakage detection
Duplicate payment detection
Priority-based business rule implementation
Window functions
Conditional aggregation
Event timeline processing
Real-World Relevance

This type of analysis is commonly performed in:

FinTech companies
Payment gateways
E-commerce platforms
Subscription businesses
Banking systems
Fraud and risk monitoring teams

It reflects real operational reporting used to monitor payment health, recovery rates, customer experience, and revenue protection. 
