 2026-05-27 — Day 68 of Only Hard Daily SQL Challenge
Sports Tournament Momentum Shift Detection
Problem Statement

In sports tournaments, team performance often changes over time.

Some teams start poorly but gradually improve and dominate later matches.

Other teams begin strongly but lose momentum as the tournament progresses.

The analytics team wants to detect:

performance momentum shifts

throughout the tournament.

Your task is to compare early tournament performance against later tournament performance and classify each team's momentum trend.

Objective

For every qualifying team:

analyze first 3 matches
analyze last 3 matches
compare points and score performance
identify whether team performance:
improved
declined
or remained stable
Match Conversion Logic

Each match contains:

team_a
team_b

But momentum analysis must happen:

team-wise

Therefore:

Each match should be converted into
one row per team.

Example:

T1 vs T2

becomes:

T1 row
T2 row
Team Inclusion Rule

Only include teams having:

at least 6 matches

Reason:

The problem compares:

first 3 matches
vs
last 3 matches

Minimum required matches:

3 + 3 = 6

Teams with fewer than 6 matches must be excluded.

Match Ordering Rule

Matches must be ordered using:

match_date

for each team individually.

Early Matches

Represents:

first 3 matches

played by the team.

Late Matches

Represents:

last 3 matches

played by the team.

Points System
WIN
3 points
DRAW
1 point
LOSS
0 points
Score Difference Logic

Measures overall scoring dominance.

Formula:

goals_scored - goals_conceded
Example

If team scored:

5 goals

and conceded:

2 goals

then:

score_diff = +3

Negative score difference means the team conceded more than it scored.

Output Columns
team_id
early_matches
late_matches
early_points
late_points
early_score_diff
late_score_diff
momentum_status
Column Explanation
team_id

Team being analyzed.

early_matches

Count of first 3 matches used for early performance analysis.

late_matches

Count of last 3 matches used for late performance analysis.

early_points

Total points earned during:

first 3 matches
late_points

Total points earned during:

last 3 matches
early_score_diff

Net scoring performance during first 3 matches.

Formula:

total_goals_scored
-
total_goals_conceded
late_score_diff

Net scoring performance during last 3 matches.

momentum_status

Final performance classification.

Possible values:

MOMENTUM_GAIN
MOMENTUM_DROP
CONSISTENT
Momentum Classification Rules
MOMENTUM_GAIN

When:

late_points - early_points >= 6
AND
late_score_diff > early_score_diff

Meaning team significantly improved in later matches.

MOMENTUM_DROP

When:

early_points - late_points >= 6
AND
late_score_diff < early_score_diff

Meaning team performance collapsed later in tournament.

CONSISTENT

When neither strong improvement nor strong decline exists.

Important Business Rules
1. Analyze Per Team

Momentum must always be calculated separately for each team.

2. Match Date Ordering Matters

Early and late matches must be determined strictly using:

match_date
3. Minimum Match Requirement

Teams with fewer than 6 matches must not appear in output.

4. Score Difference Matters Alongside Points

Points alone are not enough.

A team may:

win narrowly
or
lose heavily

Therefore score difference is also required to measure performance quality.

5. Same Match Contributes To Both Teams

Every match affects statistics for:

team_a
AND
team_b
Edge Cases Covered

This dataset includes:

strong momentum gains
severe momentum drops
stable teams
exact performance boundaries
close score differences
mixed wins/losses/draws
incomplete teams
negative score differences
improving offensive performance
collapsing defensive performance
Real-World Use Cases

This type of analysis is used in:

sports analytics
tournament performance analysis
betting analytics
fantasy sports systems
team ranking systems
match prediction engines
coaching performance analysis
Difficulty Level
HARD / SPORTS ANALYTICS

This problem requires strong understanding of:

event-to-entity transformation
ranking and ordering logic
conditional aggregation
behavioral trend analysis
score-difference calculations
performance classification
edge-case handling
