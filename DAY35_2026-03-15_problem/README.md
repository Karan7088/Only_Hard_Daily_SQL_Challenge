 🚀 Day 35 — Netflix Binge Watching Detection (Only Hard Daily SQL Challenge)

📅 Date: 15 March 2026

Streaming platforms analyze user viewing behavior to understand content engagement patterns. One of the most important engagement metrics is binge watching, where users watch multiple episodes of the same show within a short time period.

Detecting binge sessions helps platforms optimize:

Content recommendations

Episode release strategies

User engagement analytics

This challenge focuses on identifying users who binge-watch shows using SQL.

🧠 Problem Statement

You are given a table that records when users watch episodes of different shows.

Each row represents a user watching a specific episode of a show at a particular time.

A user is considered to be binge watching if:

The user watches at least 3 distinct episodes of the same show.

The time gap between consecutive episodes is at most 1 hour (≤ 60 minutes).

Your task is to identify all user–show pairs where a binge session occurred.

📊 Table Schema
watch_history
Column	Type	Description
user_id	INT	Unique identifier of the user
show_id	INT	Unique identifier of the show
episode_id	INT	Episode number
watch_time	DATETIME	Timestamp when the episode was watched
