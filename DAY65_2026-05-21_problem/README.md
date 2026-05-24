 2026-05-24 — Day 65 of Only Hard Daily SQL Challenge
Subscription Plan Downgrade Risk Detection
Problem Statement

Subscription-based companies closely monitor customer engagement before renewal dates.

A sudden drop in product usage is often one of the strongest indicators of:

potential churn
subscription downgrade
reduced engagement
cancellation risk
customer dissatisfaction

The business wants to identify customers whose usage behavior dropped significantly before renewal so that retention campaigns or discounts can be triggered proactively.

Your task is to detect customers who are at risk of downgrading or churning based on their recent usage patterns.

Objective

For every active subscription:

analyze customer usage before renewal
compare older usage vs recent usage
calculate percentage drop in engagement
classify customer renewal risk level
Window Logic

The analysis uses:

Last 14 days before renewal date

These 14 days are divided into:

Previous 7-Day Window

Represents:

Day -14 to Day -8 before renewal

Example:

If renewal date is:

2024-01-31

then previous window becomes:

2024-01-17 to 2024-01-23
Latest 7-Day Window

Represents:

Day -7 to Day -1 before renewal

Window becomes:

2024-01-24 to 2024-01-30
Usage Calculation
previous_7_day_usage

Total usage minutes during:

previous 7-day window
latest_7_day_usage

Total usage minutes during:

latest 7-day window
Missing Usage Days

If usage records are missing for certain days:

Treat missing days as 0 usage

This is important because inactive days also indicate churn behavior.

Usage Drop Percentage

The business wants to measure how sharply customer engagement declined.

Formula:

(
previous_7_day_usage - latest_7_day_usage
)
/
previous_7_day_usage
* 100
Negative Percentage Case

If latest usage becomes greater than previous usage:

usage_drop_pct becomes negative

Meaning customer engagement increased.

Example:

Previous = 452
Latest = 673

This indicates improving engagement.

Risk Level Classification
EXTREME_RISK

When:

latest_7_day_usage = 0

Meaning customer completely stopped using the product before renewal.

HIGH_RISK

When:

usage_drop_pct >= 50%

Strong churn or downgrade signal.

MEDIUM_RISK

When:

usage_drop_pct between 20% and 49.99%

Moderate engagement decline.

LOW_RISK

When:

usage_drop_pct < 20%

or usage increased.

Important Business Rules
1. Ignore Cancelled Subscriptions

Subscriptions where:

status = CANCELLED

must not be included.

2. Compare Same Customer Only

Usage analysis must happen individually per customer subscription.

3. Renewal Date Driven Analysis

Both windows must always be calculated relative to:

renewal_date

not current system date.

Output Columns
customer_id
subscription_id
plan_name
renewal_date
previous_7_day_usage
latest_7_day_usage
usage_drop_pct
risk_level
Edge Cases Covered

This dataset includes:

strong usage drops
complete inactivity
stable customers
increasing engagement
exact 50% drop boundary
missing usage days
cancelled subscriptions
partial activity decline
negative drop percentages
Real-World Use Cases

This type of analysis is widely used in:

SaaS platforms
OTT subscriptions
gaming memberships
cloud software products
learning platforms
enterprise subscription systems
product analytics teams
customer retention systems
Difficulty Level
HARD / REAL-WORLD PRODUCT ANALYTICS

This problem requires strong understanding of:

rolling time windows
behavioral analytics
retention analysis
churn prediction logic
date-based aggregation
edge-case handling
engagement trend analysis
