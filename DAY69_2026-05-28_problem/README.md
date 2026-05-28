 Day 69 — Next Greater Transaction Amount
Problem Statement

You are given a table containing customer transaction history.

For every transaction, find the next future transaction of the same customer where the transaction amount is greater than the current transaction amount.

The goal is to identify the first greater future amount while maintaining the chronological order of transactions.

If no greater future transaction exists, return NULL.

Table Information

The dataset contains:

Transaction ID
Customer ID
Transaction timestamp
Transaction amount

Each customer can have multiple transactions over time.

Rules
1. Same Customer Comparison

Transactions should only be compared within the same customer.

A transaction from another customer must never be considered.

2. Future Transactions Only

Only transactions occurring after the current transaction are valid candidates.

Past transactions must be ignored.

3. First Greater Amount

You must return the first future transaction where:

future amount > current amount

Not the maximum future amount.

4. Equal Amounts Are Not Valid

If the future amount is equal to the current amount, it should not be considered a valid next greater transaction.

Only strictly greater amounts qualify.

5. No Greater Transaction

If no greater future transaction exists for a transaction, return NULL values.

6. Ordering Logic

Transactions should be processed in chronological order using:

transaction time
transaction ID as tie-breaker when timestamps are identical
Expected Output

For every transaction return:

current transaction details
next greater transaction ID
next greater amount
next greater transaction time
Edge Cases Covered

The dataset includes multiple real-world edge cases such as:

continuously decreasing transactions
continuously increasing transactions
duplicate amounts
same timestamp transactions
delayed greater values
customers with no valid greater transaction
skipped intermediate smaller values
Concepts Tested

This problem tests advanced SQL thinking around:

self joins
window logic
future row filtering
nearest greater element logic
ordering and tie-breaking
DSA-style problem solving using SQL
DSA Concept Behind This Problem

This is the SQL adaptation of the classic:

Next Greater Element

commonly solved using a monotonic stack in Data Structures & Algorithms.

The challenge here is implementing similar logic using SQL-based approaches.
