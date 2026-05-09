 # Day 56 - Streaming Leaderboard Rank Snapshots

## Problem Statement

You are given a stream of player score events from an online gaming platform.

Each event updates a player’s cumulative score at a particular timestamp.

Your task is to generate leaderboard snapshots at fixed 5-minute intervals and track how player rankings evolve over time.

The leaderboard must reflect the state of all players who have appeared up to that snapshot timestamp.

---

# Business Context

Modern gaming systems continuously update player rankings as score events arrive in real time.

Leaderboards are often recalculated periodically to:

- Show live rankings
- Track rank movement
- Detect rising players
- Analyze competitive trends
- Generate historical leaderboard snapshots

This problem simulates a real-time leaderboard system using SQL.

---

# Core Requirements

For every 5-minute snapshot interval:

- Calculate cumulative score for every player
- Generate leaderboard rankings
- Include all players seen till that timestamp
- Track rank changes compared to the previous snapshot

---

# Snapshot Logic

Snapshots must be generated at:

10:00
10:05
10:10
10:15
...

Only score events that occurred on or before the snapshot time should be considered.

Score Calculation Rules

A player’s total score at a snapshot is:

Sum of all score changes up to that snapshot timestamp

Scores can both increase and decrease.

Example:

+50
+30
-40

Final score becomes:

40
Leaderboard Ranking Rules

Leaderboard ranking should use:

DENSE_RANK()

ordered by:

total_score DESC

This means:

Higher score gets better rank
Same scores receive same rank
No rank gaps should exist

Example:

Score 100 -> Rank 1
Score 100 -> Rank 1
Score 80  -> Rank 2
Player Visibility Rule

At any snapshot, include only players who have appeared at least once up to that timestamp.

Example:

If player 105 appears first at:

10:40

Then:

Player 105 should NOT appear in snapshots before 10:40
Player 105 should appear in all snapshots from 10:40 onward
Rank Change Logic

Track how player rank changed compared to the previous snapshot.

Formula:

rank_change =
previous_rank - current_rank

Interpretation:

Positive  -> Rank improved
Negative  -> Rank dropped
Zero      -> No change

Examples:

4 -> 2 = +2
2 -> 5 = -3
3 -> 3 = 0
First Snapshot Rule

For a player's first appearance:

rank_change = 0

because no previous snapshot exists for comparison.

Expected Output Columns
snapshot_time
player_id
total_score_till_now
rank_at_that_time
rank_change_from_previous_snapshot
Key Challenges

This problem involves several advanced SQL concepts combined together:

Time-series snapshot generation
Running cumulative totals
State reconstruction
Dense ranking
Rank movement tracking
Snapshot comparison
Carry-forward logic
Interval-based analytics
Why This Problem Is Hard

This is not just a ranking problem.

The challenge comes from rebuilding the complete leaderboard state at every snapshot interval while maintaining historical consistency.

The query must correctly:

Carry forward previous scores
Recalculate rankings dynamically
Handle score decreases
Track ranking movement
Preserve historical leaderboard states

This type of logic is commonly used in:

Gaming leaderboards
Fantasy sports platforms
Trading competitions
Live scoring systems
Real-time analytics platforms
