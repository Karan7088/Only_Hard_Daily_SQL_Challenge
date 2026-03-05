🔥 Day 28 – Only Hard SQL Challenge

📅 Date: March 5, 2026
🎯 Difficulty: Hard
🧠 Concepts Covered:

Self Joins

Graph Relationships in SQL

Recommendation Systems

Data Cleaning

Aggregations & Filtering

👥 Problem: Friend Recommendation Based on Strong Mutual Connections

Social media platforms often recommend new connections using algorithms like “People You May Know.”

In this challenge, you will build a simplified recommendation system using SQL.

The platform wants to recommend potential new friendships based on strong mutual connections.

📂 Table Schema
Interactions Table
CREATE TABLE interactions (
user_id INT,
friend_id INT,
interaction_count INT
);
Column Description
Column	Description
user_id	ID of the user
friend_id	ID of the connected user
interaction_count	Number of interactions between users

Interactions represent how frequently two users communicate.

Higher interaction counts indicate stronger relationships.

📊 Problem Statement

The goal is to identify pairs of users who should be recommended to each other as friends.

A recommendation should be generated if all the following conditions are satisfied:

1️⃣ The two users are not already directly connected.

2️⃣ They share at least two mutual friends.

3️⃣ Each mutual friend must have strong interactions (≥ 3) with both users.

4️⃣ Duplicate recommendations such as (A,B) and (B,A) should not appear.

🧠 What You Need To Find

Your task is to write a SQL query that returns:

Column	Description
user1	First user in the recommendation pair
user2	Second user in the recommendation pair
mutual_frnd	Number of strong mutual friends

Only pairs satisfying all recommendation conditions should be returned.

📌 Example Scenario

Consider the following relationships:

User1 → interacts with → User2 and User3  
User4 → interacts with → User2 and User3

If interaction counts are strong (≥3), then:

User1 and User4 share mutual friends:
User2
User3

Therefore:

User1 ↔ User4

should be recommended.

⚠ Challenges in This Problem

This problem may appear simple but contains several hidden difficulties.

1️⃣ Duplicate Relationships

Datasets may contain duplicate interaction rows which can inflate mutual friend counts.

2️⃣ Self Connections

Corrupted data may contain entries like:

(6,6)

A user cannot be their own friend.

3️⃣ Existing Friendships

Users who are already directly connected must not appear in the recommendation output.

4️⃣ Asymmetric Interaction Records

Sometimes only one direction of interaction exists.

Example:

(7,8,5)

But:

(8,7)

does not exist.

5️⃣ Duplicate Recommendation Pairs

Without proper filtering the query may output:

1 4
4 1

Both represent the same recommendation.

🧪 Brutal Test Dataset

The dataset provided for this challenge intentionally includes:

duplicate rows

self connections

missing reverse interactions

weak interaction values

circular connection graphs

Your solution should handle these cases correctly.

🎯 Expected Output

Example output format:

user1	user2	mutual_frnd
1	4	2
12	16	3
💡 Real World Relevance

Problems like this appear in real-world systems such as:

social network friend suggestions

professional networking recommendations

community detection algorithms

Large companies often run graph analytics queries to detect connection opportunities within massive networks.

🚀 Learning Outcomes

After solving this challenge you will better understand:

how SQL can model graph relationships

how to detect mutual connections

how to avoid duplicate pair problems

how to design recommendation logic using joins