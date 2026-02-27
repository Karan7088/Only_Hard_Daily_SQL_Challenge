# 🔥 Day 22 – Only Hard Daily SQL Challenge
📅 Date: 27 February 2026  
🛒 Problem: Detect High Purchase-Intent Users (Rolling 30-Min Window)

You are given a table:

events(event_id, user_id, event_type, product_id, event_time)

Where:

event_type ∈ ('cart', 'purchase')

Each row represents a user action on a product.

🎯 Objective

Identify users who:

Added at least 3 distinct products to cart
Within any rolling 30-minute window

⚠ Important Clarifications

❌ Do NOT use session segmentation.

❌ Do NOT reset logic after purchase.

❌ Do NOT require carts to be consecutive rows.

✅ Use rolling time window logic.

✅ Consider DISTINCT product_id.

✅ Purchase events do NOT invalidate the window.

✅ The 30-minute window is inclusive.

🧠 Business Meaning

We are trying to detect:

Users showing strong buying intent by rapidly adding multiple different products to cart.

This is typically used for:

Retargeting ads

Coupon triggers

Intent scoring

Fraud detection

📝 Example

If a user has:

10:00 cart (P1)
10:05 purchase (P1)
10:10 cart (P2)
10:15 cart (P3)
10:20 cart (P4)

From 10:10 → 10:20
There are 3 distinct cart products within 30 minutes.

✅ User qualifies.

If a user has:

12:00 cart (P1)
12:10 cart (P2)
12:20 cart (P3)
12:50 purchase

From 12:00 → 12:20
3 distinct carts within 20 minutes.

✅ User qualifies.

📌 Expected Output

Return:

user_id

Users who satisfy the above condition at least once.

💡 Bonus (Hard Mode)

Also return:

Start time of qualifying 30-min window

End time of that window

Count of distinct products in that window

Now THIS is real-world analytics logic 💯