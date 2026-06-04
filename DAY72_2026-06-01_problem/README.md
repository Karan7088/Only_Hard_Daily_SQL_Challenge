 Day 72 – Employee Badge Sharing & Impossible Travel Detection
Business Context

A company tracks employee activity using three independent systems:

Office Badge System
Records when employees enter and exit offices.
Corporate VPN System
Records the city from which employees access company resources.
Meeting Room Booking/Access System
Records attendance in office meeting rooms.

Security teams suspect that some employees may be:

Sharing badges with coworkers.
Sharing VPN credentials.
Logging in from multiple locations simultaneously.
Using company resources from locations where they physically cannot be present.
Creating suspicious activity patterns indicating unauthorized access.

Your task is to reconstruct employee movement timelines and identify employees whose activity is physically impossible or highly suspicious.

Important Assumptions
Assumption 1

An employee can only be in one city at a time.

Example:

09:00 Badge Entry → Delhi
09:05 VPN Login  → Mumbai

This is impossible because a person cannot travel from Delhi to Mumbai in 5 minutes.

Assumption 2

Meeting room attendance implies physical presence.

If an employee appears in a meeting room located in Delhi:

09:10 Meeting Room → Delhi

the employee must physically be in Delhi at that time.

Assumption 3

VPN activity represents the employee's working location.

For this problem assume VPN city is accurate and not masked through VPN tunneling.

Assumption 4

All timestamps are recorded correctly.

No clock synchronization issues exist.

Goal

Identify employees whose activity timeline contains contradictions.

Output Columns
employee_id

Employee being investigated.

issue_start_time

The earliest timestamp involved in the suspicious sequence.

Example:

09:00 Delhi Badge Entry
09:05 Mumbai VPN Login

Start time:

09:00
issue_end_time

Latest timestamp participating in the suspicious sequence.

Example:

09:00 Delhi Badge Entry
09:05 Mumbai VPN Login
09:10 Delhi Meeting

End time:

09:10
involved_cities

Distinct cities participating in the conflict.

Example:

Delhi
Mumbai

Output:

Delhi,Mumbai

Example:

Bangalore
Delhi
Chennai

Output:

Bangalore,Delhi,Chennai
issue_type

Type of anomaly detected.

Rules for Classification
Rule 1 — IMPOSSIBLE_LOCATION

Occurs when activities from different systems place an employee in different cities within a very short time window.

Example:

09:00 Badge Entry → Delhi
09:05 VPN Login → Mumbai

Since both events happen almost simultaneously:

IMPOSSIBLE_LOCATION
Another Example
23:40 Badge Entry → Delhi
00:10 VPN Login → Mumbai
00:20 Meeting → Delhi

Employee appears in:

Delhi
Mumbai
Delhi

within 40 minutes.

Result:

IMPOSSIBLE_LOCATION
Rule 2 — IMPOSSIBLE_TRAVEL

Employee legitimately exits one city and appears in another city before realistic travel is possible.

Example:

12:00 Delhi Exit
12:20 Mumbai Entry

Travel time:

20 minutes

Delhi → Mumbai cannot happen in 20 minutes.

Result:

IMPOSSIBLE_TRAVEL
Another Example
09:30 Delhi Exit
09:45 Mumbai VPN
09:50 Mumbai Meeting

Travel time:

15 minutes

Result:

IMPOSSIBLE_TRAVEL
Rule 3 — MULTI_CITY_CONFLICT

Employee simultaneously appears in three or more cities during the same suspicious window.

Example:

08:55 Bangalore Badge
09:10 Delhi VPN
09:20 Chennai VPN
09:25 Delhi Meeting

Cities involved:

Bangalore
Delhi
Chennai

Result:

MULTI_CITY_CONFLICT

This has higher severity than a simple two-city conflict.

Events That Should NOT Be Flagged
Normal Workday
09:00 Delhi Entry
10:00 Delhi VPN
11:00 Delhi Meeting
18:00 Delhi Exit

Same city throughout.

No issue.

Legitimate Travel
09:00 Delhi Exit
15:00 Mumbai Entry

Several hours passed.

Travel is possible.

No issue.

Duplicate Same-City Activity
09:00 Chennai VPN
09:05 Chennai VPN
09:20 Chennai Meeting

Same city.

No issue.

Edge Cases

Your solution must handle:

Missing Exit Records
ENTRY exists
EXIT missing

Still use available events.

Missing Entry Records
EXIT exists
ENTRY missing

Still analyze timeline.

Overnight Activity
23:40 Delhi
00:10 Mumbai

Date change should not reset analysis.

Multiple VPN Logins
Delhi
Delhi
Delhi

No issue.

Multiple Badge Entries
09:00 Entry
09:02 Entry

Do not automatically flag.

Only flag if location contradiction exists.

What Makes This Hard

This is not a simple aggregation problem.

You must:

Combine three different event streams.
Build a unified timeline per employee.
Infer physical presence.
Detect impossible movement patterns.
Compare cities across neighboring events.
Handle missing events.
Handle overnight transitions.
Produce one consolidated anomaly record per suspicious chain.

This resembles real-world security analytics, badge fraud detection, insider-threat monitoring, and corporate access audit systems.
