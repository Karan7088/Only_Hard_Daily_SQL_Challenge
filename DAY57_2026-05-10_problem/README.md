 # Day 57 - Dynamic Top K Trending Hashtags

## Problem Statement

You are given hashtag usage events from a social media platform.

Each row represents a user using a hashtag at a specific timestamp.

Your task is to generate trending hashtag snapshots every 10 minutes and determine the Top 3 trending hashtags based on activity in the last rolling 1-hour window.

The leaderboard should continuously evolve as new hashtag events arrive and old events expire from the rolling window.

---

# Business Context

Social media platforms continuously monitor trending hashtags in real time.

Trending systems are usually based on:

- Recent activity
- Rolling time windows
- Dynamic ranking
- Frequency spikes
- Real-time engagement patterns

This problem simulates how platforms like:

- Twitter / X
- Instagram
- LinkedIn
- Threads
- TikTok

track and update trending topics internally.

---

# Table

## hashtag_events


event_id
user_id
hashtag
event_time
Snapshot Rule

Generate snapshots every:

10 minutes

Example:

09:00
09:10
09:20
09:30
...
Rolling Window Rule

For every snapshot:

consider only hashtag events
from the LAST 1 HOUR

Example:

For snapshot:

10:00

consider events between:

09:00 -> 10:00

For snapshot:

10:10

consider events between:

09:10 -> 10:10
Trending Logic

For every snapshot:

Count hashtag frequency in the rolling 1-hour window
Rank hashtags by frequency descending
Return only Top 3 hashtags
Ranking Rules

Use:

DENSE_RANK()

ordered by:

usage_count DESC
Tie-Breaking Rule

If multiple hashtags have same usage count:

lexicographically smaller hashtag comes first

Example:

#ai
#python

If both have same count:

#ai ranks higher
Rolling Window Expiration

As time moves forward:

older hashtag events should expire
counts should decrease automatically
rankings may change dynamically

Example:

A hashtag that was trending earlier may completely disappear later.

Dynamic Trend Movement

A hashtag can:

enter trending list
leave trending list
improve rank
drop rank

depending on rolling activity.

Expected Output
snapshot_time
hashtag
usage_count
trend_rank
Expected Output Meaning

For every snapshot:

show Top 3 hashtags
inside rolling 1-hour window

with their:

total usage count
current trend rank
Key Challenges

This problem involves:

Time-series snapshot generation
Rolling 1-hour window aggregation
Dynamic ranking
Temporal filtering
Real-time leaderboard reconstruction
Sliding window analytics
Why This Problem Is Hard

The difficult part is not counting hashtags.

The challenge comes from:

rebuilding rankings at every snapshot
maintaining rolling windows
expiring old events correctly
dynamically recalculating Top K trends

This closely resembles real-time trend engines used in large-scale social media systems.

