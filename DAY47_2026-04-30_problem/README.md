🔥 Day 46 — Extreme Hard SQL Challenge
Sessionization + Funnel Analysis
🧠 Problem Statement

You are given a dataset of user events representing interactions with a product over time. Each event corresponds to an action such as logging in, viewing a product, adding it to the cart, or making a purchase.

The goal is to analyze user behavior by:

Dividing events into sessions
Tracking funnel progression within each session
Classifying how far each user progressed in the funnel
🎯 Objective

For each user and each session, determine whether the user:

Successfully completed the full funnel
Partially progressed through the funnel
Did not follow the funnel at all
⚙️ Sessionization Logic
Events must be processed in chronological order per user
A session is defined based on time gaps between consecutive events
A new session starts when the gap between two events is greater than 30 minutes
Otherwise, events belong to the same session
🔁 Funnel Definition

The funnel consists of the following ordered steps:

login → view_product → add_to_cart → purchase

📏 Rules to Consider
The order of events is strictly important
Each step must occur after the previous step in the funnel
If a step appears before its required previous step, it should be ignored
Duplicate or repeated events should be treated as noise and ignored
Only the first valid occurrence of each step should be considered
Users may skip steps, but doing so breaks the funnel sequence
📊 Funnel Classification

Each session must be classified into one of the following:

FULL_CONVERSION
All steps in the funnel are completed
Events follow the correct order from start to end
PARTIAL
The funnel has started (login exists)
But not all steps are completed
NO_CONVERSION
The funnel did not properly start
Or the sequence of steps is invalid (e.g., skipping required steps)
🧠 Key Concepts Tested
Time-based sessionization
Sequential event validation
Funnel analytics
Handling noisy and duplicate data
Behavioral analysis across sessions
💀 Why This Problem is Challenging
Requires combining time-based logic with ordered event tracking
Involves careful handling of duplicates and missing steps
Simulates real-world product analytics and user journey analysis
