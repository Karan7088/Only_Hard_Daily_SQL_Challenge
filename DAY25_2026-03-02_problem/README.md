🔥 Day 25 – Only Hard SQL Challenge

📅 Date: 2 March 2026
📊 Topic: Price Volatility Analysis using Window Functions

🧠 Problem Statement

Given a prod table containing:

product_id

price

price_date

Calculate:

Price change between consecutive dates

Volatility of each product

Maximum price jump

Return Top 3 most volatile products

🚀 Core Concept – What is Volatility?

Volatility measures how much values fluctuate over time.

Mathematically, volatility = Standard Deviation of price changes

📐 Step 1 – Calculate Price Change

We compute day-to-day difference using:

price - LAG(price) OVER (PARTITION BY product_id ORDER BY price_date)

This gives:

price_change = current_price - previous_price
📊 Step 2 – How to Calculate Volatility?

Volatility is calculated using Population Standard Deviation.



SQL provides two options:

Function	Meaning	When to Use
STDDEV_POP()	Population Standard Deviation	When you have complete dataset
STDDEV_SAMP()	Sample Standard Deviation	When data is a sample of larger population
✅ Why We Use STDDEV_POP() Here?

Because:

We are analyzing all available price records

Not estimating from a sample

We want actual volatility of the dataset

If this were stock market modelling using limited observations → use STDDEV_SAMP().

🧮 Step 3 – Maximum Jump

To measure biggest shock:

MAX(ABS(price_change)) OVER (PARTITION BY product_id)

This tells highest single-day movement.