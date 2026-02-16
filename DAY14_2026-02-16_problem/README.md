📦 Inventory Stock Daily Summary

Date: 16 February 2026

📌 Problem Statement

We are given a table called inventory_events which contains stock movements for different:

product_id

warehouse_id

event_time

event_type

quantity

Our goal is to calculate a daily summary per product per warehouse, including:

Opening Stock

Closing Stock

Total In

Total Out

Negative Flag

First Negative Timestamp

🔄 Step 1: Normalize Quantity (qty)

Different event types affect stock differently.

We convert everything into a signed movement column called qty.

Rules:
Event Type	Stock Effect
PURCHASE	+
TRANSFER_IN	+
SALE	-
TRANSFER_OUT	-
ADJUSTMENT	As is
Example:

If we have:

event_type	quantity
SALE	30

Then:

qty = -30

If:

event_type	quantity
PURCHASE	50

Then:

qty = +50

This makes stock calculation consistent.

📊 Step 2: Calculate Running / Cumulative Stock

Running stock (also called cumulative stock) means:

Stock after every transaction.

SQL logic concept:

running_stock = sum(qty) 
                over(partition by product_id, warehouse_id 
                     order by event_time)
Example

Transactions:

Time	qty
10:00	+100
12:00	-30
14:00	-80

Running stock:

100
70
-10

So stock became negative at 14:00.

📅 Step 3: Daily Calculations

We group by:

product_id
warehouse_id
date
1️⃣ Opening Stock

Opening stock is:

Previous day's closing stock.

SQL concept:

lag(closing_stock) over(...)

If no previous day → opening = 0

Example
Date	Closing
10 Feb	60
11 Feb	35

Opening on 11 Feb = 60

2️⃣ Closing Stock

Closing stock is:

Running stock of the last transaction of that day.

We use:

row_number() over(partition by date order by event_time desc)

Pick last row of the day.

3️⃣ Total In

Sum of all positive qty for that day.

sum(case when qty > 0 then qty end)
Example

Transactions:

+50
+20
-10

Total In = 70

4️⃣ Total Out

Sum of all negative qty for that day (absolute value).

sum(case when qty < 0 then qty end)
Example

Transactions:

-30
-20
+50

Total Out = 50

🚨 Step 4: Negative Flag (3 Possible Rules)

This is the most important logic.

🟢 Rule A – Opening Included

If stock is negative at ANY moment during the day
including opening balance → flag = 1

Example:

Opening = -10
Even if it becomes positive later → flag = 1

🟡 Rule B – Intraday Dip Only (Your Current Logic)

Flag = 1 only if stock becomes negative due to transactions of that same day.

If:

Opening = -10
Then +10 → 0

No new dip that day → flag = 0

But if:

Opening = 10
Then -20 → -10

Dip happened that day → flag = 1

🔴 Rule C – Closing Based

Flag = 1 only if closing_stock < 0

Even if stock went negative during day but recovered → flag = 0

This rule is usually incorrect for operational reporting.

⏱ Step 5: First Negative Timestamp

Definition:

The earliest event_time in a day when running_stock < 0

SQL concept:

min(event_time where running_stock < 0)
Example

Transactions:

Time	Running Stock
10:00	100
12:00	20
14:00	-5

First negative timestamp = 14:00

If stock never goes negative → NULL

📌 Final Output Columns Explained
Column	Meaning
product_id	Product identifier
warehouse_id	Warehouse identifier
date	Transaction date
opening_stock	Previous day closing
closing_stock	End of day stock
total_in	Total inward quantity
total_out	Total outward quantity
flag	Negative indicator
first_stamp_neg	First time stock became negative
🧠 Important Edge Cases

Opening already negative

Multiple dips in same day

Stock goes negative then positive

No transactions for a day

Adjustment events

🏁 Final Understanding

This solution uses:

Window functions

Running totals

Partitioning

First occurrence logic

Daily aggregation

This is real-world warehouse ledger logic used in:

ERP systems

Inventory management systems

Financial reconciliation

Supply chain dashboards