# 🔍 Fraud Ring Detection Using Recursive CTE (MySQL)
day 23 only hard sql challenge 
date- 1-03-2026
## 📌 Problem Statement

Given a `transactions` table containing money transfers between users, identify suspicious **circular transaction rings** under the following conditions:

1. A ring must form a valid cycle (A → B → C → ... → A).
2. The ring must contain at least **3 unique users**.
3. The total transaction amount across the cycle must be **≥ 50,000**.
4. All transactions in the cycle must occur within **7 days of each other**.
5. If any user in the ring performs **more than 3 transactions within 1 hour**, the entire ring is classified as **"high risk"**.  
   Otherwise, it is **"normal"**.

---

## 🧱 Table Structure

```sql
transactions(
    txn_id INT,
    sender_id INT,
    receiver_id INT,
    amount DECIMAL(10,2),
    txn_date DATETIME
)
🧠 Conceptual Understanding

This is a graph traversal problem solved using SQL.

Each user → Node

Each transaction → Directed Edge

Fraud ring → Directed Cycle in graph

Since SQL is not natively graph-based, we simulate graph traversal using a Recursive CTE.

📚 Prerequisites Before Solving

Before attempting this problem, you must understand:

1️⃣ Recursive CTE

Anchor query

Recursive query

UNION ALL

Level tracking

2️⃣ Graph Theory Basics

Directed Graph

Cycle Detection

Path traversal

Avoiding infinite loops

3️⃣ String Path Tracking

Using comma-separated values

FIND_IN_SET() to prevent revisiting nodes

4️⃣ Window Functions

ROW_NUMBER() for deduplication

5️⃣ Time Filtering

Using DATEDIFF() for 7-day constraint

🛠 Step-by-Step Approach
✅ Step 1: Build Traversal Using Recursive CTE

We start with all valid transactions (excluding self-transfers).

We track:

Current path (lst)

Current level (lvl)

Running total amount

The recursive part joins:

previous.receiver_id = next.sender_id

This builds a path forward in time while:

Preventing self loops

Enforcing 7-day constraint

Accumulating transaction amount

✅ Step 2: Identify Valid Rings

After recursion, filter:

lvl >= 3

amount >= 50000

sender_id = receiver_id → ensures cycle closure

This ensures:

At least 3 users

Valid circular structure

High-value transaction chain

✅ Step 3: Deduplicate Rings

Multiple traversal paths can produce duplicates.

We use:

ROW_NUMBER() OVER (PARTITION BY txn_id ORDER BY lvl DESC)

This keeps only the deepest valid ring per transaction.

✅ Step 4: Risk Classification

We analyze each user independently:

If a user performs more than 3 transactions within 1 hour,
they are marked as:

high risk

Then:

If any user in the ring is high risk → ring = high risk

Otherwise → ring = normal