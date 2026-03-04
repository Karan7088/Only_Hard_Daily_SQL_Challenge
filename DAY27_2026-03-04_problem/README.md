# 🔥 Day 27 – Only Hard SQL Challenge  
📅 Date: 04 March 2026  
💀 Difficulty Level: Hard  
🧠 Concepts Covered: Window Functions, Consecutive Dates Logic, Streak Analysis, Dense Ranking, Advanced CTE Design  

---

🎯 Business Scenario

Company wants to measure:

“Did the user come back within 7 days after their first successful purchase?”


🎯 Objective

For each user:

Identify the first order date

Check whether the user placed another order within 7 days of their first order

Classify users as:

Converted → if second order is within 7 days

Not Converted → otherwise

🎯 WHAT YOU NEED TO FIND (Day 27)

For each user:

Find their first order

Find their second order

Check if second order happened within 7 days of first order

Classify them as:

Converted

Not Converted

🚨 Rules

If user has only 1 order → Not Converted

If second order happens on day 8 → Not Converted

Exactly 7 days difference → Converted

Use proper window functions (no subquery shortcuts 😎)

🧨 NEW RULES (THIS IS WHERE PEOPLE DIE)

1️⃣ Only count successful orders

Ignore:

Cancelled

Refunded

Pending

So your first order must be:

status = 'completed'
2️⃣ If multiple orders on same day

Pick the earliest timestamp.

Not just date.

3️⃣ Second order must also be:

completed

AND from a different transaction_id

AND strictly after first order timestamp

4️⃣ If second order is refunded later?

Ignore it.

You must only count final completed orders.

5️⃣ Retention window

Now change rule:

Not just ≤ 7 days.

Use this logic:

0 < (second_order_datetime - first_order_datetime) <= 7 days

That means:

Same timestamp → invalid

Negative → invalid

Exactly 7 days → valid

📊 FINAL OUTPUT NOW

| user_id | first_success_order | second_success_order | days_diff | retained_flag |

🧠 WHAT TO FIND (CLEAR THINKING)

For each user:

Step 1

Filter only:

status = 'completed'
Step 2

Order by:

order_datetime ASC
Step 3

Assign row numbers per user

Row 1 → first success
Row 2 → second success

Ignore everything else.

Step 4

Calculate:

Days difference

Step 5

Apply retention logic

If:

days_diff > 0 AND days_diff <= 7

→ retained_flag = 1

Else:
→ retained_flag = 0

😈 Now Let’s Make It Even More Typical

Add this extra difficulty:

📌 Cohort Month

Also return:

cohort_month = month(first_success_order)

Now company wants retention by cohort month.

That means:

You must compute first order correctly

Before grouping by cohort

If first order logic wrong → entire dashboard wrong.

📊 FINAL OUTPUT COLUMNS EXPLAINED

You need this output:

| user_id | first_order_date | second_order_date | status |

Now let’s break each column.

🧩 Column 1: user_id
What is it?

The unique user.

How to get it?

Group everything by user.

You analyze one user at a time.

🧩 Column 2: first_order_date
What is it?

The earliest order placed by that user.

How to find it?

Option 1:

Sort orders by date per user

Take the first one

Option 2:

Use MIN(order_date)

But careful ⚠
If you use MIN, you still need ordering logic later.

Correct thinking:

“Order user’s orders by date and pick the first row.”

🧩 Column 3: second_order_date
What is it?

The very next order after the first one.

Important:

Not any order within 7 days

Strictly the second order

How to find it?

After sorting orders per user:

First row = first order

Second row = second order

If user has only one order:

Second order = NULL

🧩 Column 4: status

This is the main logic.

We calculate:

Difference in days between:

second_order_date - first_order_date

If:

≤ 7 → Converted

7 → Not Converted

NULL (no second order) → Not Converted

⚠️ VERY IMPORTANT EDGE RULE

If user has:

First order → Jan 1
Second order → Jan 20
Third order → Jan 5

You must still check SECOND order only.

Even if third order is within 7 days, user is:

❌ Not Converted

Because rule says:

Check second order only.