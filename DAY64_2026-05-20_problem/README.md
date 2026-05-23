2026-05-23 — Day 64 of Only Hard Daily SQL Challenge
Payment Retry Success Attribution
Problem Statement

In real-world payment systems, failed transactions are extremely common because of:

insufficient balance
OTP failures
network issues
card declines
bank timeouts
temporary gateway failures

Most users retry their payment after failure.

The business wants to measure:

How many failed payments were eventually recovered
through a successful retry?

Your task is to identify failed payment attempts that were later recovered by a successful payment retry.

Objective

For every failed payment transaction:

determine whether it was later recovered
identify the successful retry transaction
calculate recovery time
classify payments into:
RECOVERED
or
NOT_RECOVERED
Matching Logic

A failed payment is considered recovered only if:

1. Same user_id
2. Same merchant_id
3. Same amount
4. SUCCESS transaction occurs AFTER failed transaction
5. SUCCESS occurs within 30 minutes
Important Retry Attribution Rule

A single SUCCESS transaction can recover only:

ONE failed transaction

and it must recover:

the nearest previous valid FAILED transaction
Example
Example 1
13:00 FAILED
13:05 FAILED
13:08 SUCCESS

Correct mapping:

13:05 FAILED -> RECOVERED
13:00 FAILED -> NOT_RECOVERED

Reason:

The successful retry is closest to the latest failed attempt.

Recovery Window Rule

Recovery is valid only when:

success_time - failed_time <= 30 minutes
Invalid Recovery Cases

The following situations should NOT be considered recovered:

1. Success After 30 Minutes
11:00 FAILED
11:45 SUCCESS

Not recovered because:

45 minutes > 30 minutes
2. Different Amount
FAILED -> 999
SUCCESS -> 1000

Not recovered because amounts differ.

3. Different Merchant
FAILED -> M8
SUCCESS -> M9

Not recovered because merchant changed.

4. Success Before Failure
SUCCESS -> 15:00
FAILED  -> 15:05

Cannot recover previous success.

Output Columns
failed_txn_id
user_id
merchant_id
amount
failed_time
success_txn_id
success_time
minutes_to_recover
recovery_status
Column Explanation
failed_txn_id

Transaction ID of failed payment.

success_txn_id

Matched successful retry transaction.

If no valid recovery exists:

NULL
minutes_to_recover

Difference between:

failed_time
and
success_time

measured in minutes.

recovery_status
RECOVERED

When valid successful retry exists.

NOT_RECOVERED

When no valid retry exists.

Edge Cases Covered

This dataset includes:

multiple failures before success
multiple success transactions
retry attribution conflicts
exact 30-minute recovery boundary
mismatched amounts
mismatched merchants
success before failure
standalone failures
recovery prioritization logic
Real-World Use Cases

This type of analysis is heavily used in:

fintech systems
payment gateways
subscription billing systems
checkout funnel analytics
retry optimization systems
payment recovery analytics
failed transaction monitoring
banking analytics
Difficulty Level
HARD / REAL-WORLD FINTECH ANALYTICS

This problem requires strong understanding of:

sequential event matching
nearest-event attribution
time-window analysis
edge-case handling
retry recovery logic
transactional behavior analytics
complex self-join conditions 
