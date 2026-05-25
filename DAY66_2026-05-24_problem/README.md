2026-05-25 — Day 66 of Only Hard Daily SQL Challenge
Employee Meeting Conflict Chain Detection
Problem Statement

Large organizations often face scheduling chaos where employees get trapped in overlapping meetings throughout the day.

In real-world calendar systems, conflicts are not always direct.

Sometimes meetings overlap indirectly and create long continuous busy blocks that make employees unavailable for hours.

The company wants to identify employees with dangerous meeting overload patterns by detecting continuous overlap chains.

Your task is to detect meeting conflict chains for each employee.

Objective

Find groups of meetings where:

meetings overlap directly or indirectly
employees remain continuously busy
multiple meetings belong to the same connected overlap chain

The goal is to identify employees suffering from excessive scheduling conflicts.

Overlap Definition

Two meetings overlap when:

meeting_1.start_time < meeting_2.end_time
AND
meeting_1.end_time > meeting_2.start_time
Important Boundary Rule

Meetings touching exactly at boundaries are NOT overlaps.

Example:

09:00 - 10:00
10:00 - 11:00

These meetings should NOT belong to the same chain.

Reason:

No actual time intersection exists.
Indirect Overlap Logic

This is the hardest part of the problem.

Example:

Meeting A overlaps Meeting B
Meeting B overlaps Meeting C

Even if:

A does NOT directly overlap C

all three meetings must still belong to the same conflict chain.

This creates recursive connected-chain behavior.

Conflict Chain Logic

A conflict chain represents:

one continuous busy block

for the employee.

The chain continues as long as at least one meeting overlaps with another meeting already inside the chain.

Output Columns
employee_id
conflict_chain_id
chain_start_time
chain_end_time
total_meetings
continuous_busy_minutes
conflict_level
Column Explanation
employee_id

Employee whose meetings are being analyzed.

Each employee must be processed independently.

conflict_chain_id

Unique chain number per employee.

If an employee has multiple independent overlap groups:

1
2
3
...

must be assigned separately.

chain_start_time

Earliest meeting start time inside the chain.

chain_end_time

Latest meeting end time inside the chain.

total_meetings

Total meetings participating in the same overlap chain.

Both direct and indirect overlaps must be counted.

continuous_busy_minutes

Continuous occupied duration between:

chain_start_time
and
chain_end_time

Important:

Do NOT sum individual meeting durations.

Because overlapping durations would duplicate time.

Example

Meetings:

09:00 - 10:00
09:30 - 10:30
10:15 - 11:00

Continuous busy block becomes:

09:00 -> 11:00

Busy duration:

120 minutes

NOT:

60 + 60 + 45
Conflict Level Classification
EXTREME

When:

total_meetings >= 5

Represents severe scheduling overload.

HIGH

When:

total_meetings = 4

Large continuous overlap chain.

LOW

When:

total_meetings = 2 or 3

Small overlap groups.

Important Business Rules
1. Analyze Per Employee Only

Meetings from different employees must never interact.

2. Ignore Isolated Meetings

Single meetings without overlaps should not appear in output.

3. Merge Indirect Overlaps

If overlap relationship is connected indirectly:

A -> B -> C

all meetings belong to same chain.

4. Boundary Touching Is Not Overlap

Example:

10:00 end
10:00 start

No overlap exists.

Edge Cases Covered

This dataset includes:

direct overlaps
indirect overlap chains
nested meetings
exact boundary-touching meetings
isolated meetings
duplicate timing meetings
multiple independent chains
long continuous busy blocks
recursive overlap behavior
Real-World Use Cases

This type of analysis is used in:

calendar scheduling systems
enterprise collaboration tools
productivity analytics
meeting overload monitoring
employee burnout analysis
workforce optimization
resource scheduling systems
Difficulty Level
EXTREME HARD / REAL-WORLD CALENDAR ANALYTICS

This problem requires strong understanding of:

interval overlap logic
recursive chain detection
connected component behavior
continuous time calculations
edge-case handling
event-stream analytics
recursive grouping logic 
