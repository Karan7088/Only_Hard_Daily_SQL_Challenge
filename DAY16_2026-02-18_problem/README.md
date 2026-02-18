🧩 Problem Overview
DATE:2026-02-18
We are building a multi-level referral points system.

We have two tables:

1️⃣ Users

This table lists all users:

user_id	name
1	Alice
2	Bob
3	Charlie
4	David
5	Eve

Each user_id is unique.

All users may or may not have referred someone.

2️⃣ Referrals

This table tracks who referred whom:

referrer_id	referee_id	signup_date
1	2	2026-01-01
2	3	2026-01-02
3	4	2026-01-03
2	5	2026-01-05

referrer_id = the person who referred another user

referee_id = the new user who was referred

signup_date = when the referral happened (for ordering, optional in points)

Business Rules for Points

Each user earns points based on the referral network that starts from them:

Level 1 (direct referrals) = 10 points

Example: Alice refers Bob → Alice gets 10 points

Level 2 (referrals of referrals) = 5 points

Example: Bob refers Charlie → Bob gets 10 points, Alice gets 5 points (because Charlie is level 2 for Alice)

Level 3 = 2 points

Level > 3 = 1 point

Example Referral Tree

Let’s trace Alice:

Alice refers Bob → level 1 for Alice → 10 points

Bob refers Charlie → level 2 for Alice → 5 points

Charlie refers David → level 3 for Alice → 2 points

Bob refers Eve → level 2 for Alice → 5 points

Alice’s total points = 10 + 5 + 2 + 5 = 22

Expected Output Columns
Column	Meaning
user_id	The ID of the user earning points
total_referral_points	Total points earned from the entire referral network (direct + indirect referrals)
referral_tree	Ordered list of all referees in the network, with their level in parentheses. Example: 2(L1)→3(L2)→4(L3)→5(L2)
Key Points to Understand

Multi-level network – Not just direct referrals. We have to traverse the referral graph recursively.

Level matters – Points decrease as the referral level goes deeper.

Referral tree string – Shows the chain of influence, not just the points.

Edge cases to handle:

Users with no referrals → points = 0, tree = NULL

Loops (if data is corrupted) → need to avoid infinite recursion

Multiple direct referrals → need to traverse all branches

Visual Representation
Alice(1)
├── Bob(2) → L1
│   ├── Charlie(3) → L2
│   │   └── David(4) → L3
│   └── Eve(5) → L2


Alice’s referral tree: 2(L1)→3(L2)→4(L3)→5(L2)

Points: 10 + 5 + 2 + 5 = 22

✅ Skills You Need to Solve This

Recursive CTE – To traverse the referral network from each user.

Conditional aggregation – To calculate points depending on the level.

String aggregation – To generate the referral tree (GROUP_CONCAT in MySQL).

Edge case handling – No referral users, cycles, or deeper than level 3.