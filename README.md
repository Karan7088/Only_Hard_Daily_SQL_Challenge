# Problem 5: Funnel Analysis with Attribution

**Difficulty:** ⭐⭐⭐⭐⭐ (5/5)  
**Date:** 2024-02-07  
**Topic:** Marketing Analytics, Customer Acquisition, Cohort Analysis

---

## Problem Statement

Analyze acquisition channel effectiveness by calculating key marketing metrics for three acquisition channels: `organic`, `paid_ad`, and `referral`.

### Business Context
Understanding which marketing channels bring the most valuable customers is crucial for optimizing marketing spend. This analysis helps identify:
- Which channels convert browsers into buyers fastest
- Which channels generate the most revenue
- Which channels create loyal, returning customers

### Required Metrics

| Metric | Description |
|--------|-------------|
| **First-touch Attribution** | The channel that originally brought the customer |
| **Time to First Purchase** | Days between registration and first completed order |
| **30-Day Conversion Rate** | % of registered users who complete first order within 30 days |
| **Revenue per Channel** | Total net revenue (completed orders only, refunds excluded) |
| **Channel Stickiness** | % of converted customers who make 2nd purchase within 60 days of first |

---

## Expected Output Columns

| Column | Definition |
|--------|------------|
| `channel` | Acquisition channel (organic, paid_ad, referral) |
| `total_registered` | Total customers who registered via this channel |
| `converted_30d` | Customers with first completed order ≤30 days from registration |
| `conversion_rate` | Percentage: (converted_30d / total_registered) × 100 |
| `avg_time_to_first_purchase` | Average days to first completed order (converted customers only) |
| `total_revenue` | Sum of net revenue (order_amount - refund) for all completed orders |
| `sticky_customers` | Customers with 2nd completed order ≤60 days after first completed order |
| `stickiness_rate` | Percentage: (sticky_customers / converted_30d) × 100 |

---

## Formulas (Step-by-Step)

### 1. total_registered
Count all unique customer_ids grouped by acquisition_channel
Copy
**Simple English:** How many people signed up through each channel.

---

### 2. converted_30d
For each customer:
Find first order with status = 'completed'
Calculate days = order_date - registration_date
If days ≤ 30, customer is converted
Count all such customers grouped by channel
Copy
**Simple English:** People who actually bought something within 30 days of signing up.

**Important:** Only `status = 'completed'` counts. Pending, cancelled, or refunded orders do NOT count.

---

### 3. conversion_rate
conversion_rate = (converted_30d / total_registered) × 100
Copy
**Simple English:** What percentage of signups turned into buyers within 30 days.

---

### 4. avg_time_to_first_purchase
For each converted customer:
days_to_first = first_completed_order_date - registration_date
avg_time_to_first_purchase = SUM(days_to_first) / converted_30d
Copy
**Simple English:** On average, how many days did it take for buyers to make their first purchase.

**Note:** Only calculate for customers who converted (converted_30d), not all registered users.

---

### 5. total_revenue
For each completed order:
net_amount = order_amount - refund_amount
total_revenue = SUM(net_amount) for all completed orders in channel
Copy
**Simple English:** Total money actually earned from each channel.

**Important:** 
- Include ALL completed orders (even if customer took >30 days to convert)
- Exclude pending, cancelled, and refunded orders completely
- Subtract refunds from order amount

---

### 6. sticky_customers
For each converted customer with 2+ completed orders:
Find first_completed_order_date
Find second_completed_order_date
Calculate days_between = second_date - first_date
If days_between ≤ 60, customer is sticky
Count all sticky customers grouped by channel
Copy
**Simple English:** Customers who liked us enough to come back and buy again within 2 months of their first purchase.

**Example - Sticky Customer:**
- First order: Jan 10
- Second order: Feb 15 (36 days later)
- 36 ≤ 60 → **STICKY** ✅

**Example - Not Sticky:**
- First order: Jan 10
- Second order: May 1 (111 days later)
- 111 > 60 → **NOT STICKY** ❌

**Example - Not Sticky (only 1 order):**
- First order: Jan 10
- No second order → **NOT STICKY** ❌

---

### 7. stickiness_rate
stickiness_rate = (sticky_customers / converted_30d) × 100
Copy
**Simple English:** Of all the customers who bought within 30 days, what percentage came back for more within 60 days.

**Note:** Divide by converted_30d (not total_registered), because we're measuring loyalty among actual buyers.

---

## Dataset

### Customers Table (28 customers)
| customer_id | email | country | registration_date | acquisition_channel |
|-------------|-------|---------|-------------------|---------------------|
| 1 | alice@example.com | USA | 2023-01-05 | organic |
| 2 | bob@example.com | UK | 2023-01-15 | paid_ad |
| ... | ... | ... | ... | ... |

### Orders Table (multiple orders per customer)
| order_id | customer_id | order_date | order_amount | refund_amount | status | device |
|----------|-------------|------------|--------------|---------------|--------|--------|
| 101 | 1 | 2023-01-10 | 100.00 | 0.00 | completed | desktop |
| 102 | 1 | 2023-02-15 | 150.00 | 10.00 | completed | mobile |
| ... | ... | ... | ... | ... | ... | ... |

**Order Status Types:**
- `completed` ✅ - Counts for conversion and revenue
- `pending` ❌ - Does NOT count (not yet completed)
- `cancelled` ❌ - Does NOT count (order cancelled)
- `refunded` ❌ - Does NOT count (money returned)

---

## Correct Final Output

Based on detailed recalculation with all edge cases verified:

| channel | total_registered | converted_30d | conversion_rate | avg_time_to_first_purchase | total_revenue | sticky_customers | stickiness_rate |
|---------|------------------|---------------|-----------------|----------------------------|---------------|------------------|-----------------|
| **organic** | 11 | 10 | 90.91% | 8.60 | 3905.00 | 6 | 60.00% |
| **paid_ad** | 8 | 6 | 75.00% | 8.50 | 1565.00 | 3 | 50.00% |
| **referral** | 8 | 8 | 100.00% | 7.38 | 1935.00 | 7 | 87.50% |

---

## Detailed Verification

### Organic Channel (11 registered, 10 converted)

| Customer | Reg Date | First Complete | Days | Converted? | Net Revenue | 2nd Order ≤60d? | Sticky? |
|----------|----------|----------------|------|------------|-------------|-----------------|---------|
| Alice | Jan 5 | Jan 10 | 5 | ✅ | 715.00 | Feb 15 (36d) | ✅ |
| Dave | Feb 20 | Feb 25 | 5 | ✅ | 450.00 | No 2nd order | ❌ |
| Frank | Mar 15 | Mar 20 | 5 | ✅ | 350.00 | Apr 22 (33d) | ✅ |
| Ivy | May 1 | May 20 | 19 | ✅ | 200.00 | No 2nd order | ❌ |
| Kate | Jan 1 | — | — | ❌ | 0.00 | — | — |
| Noah | Jan 20 | Jan 25 | 5 | ✅ | 450.00 | May 1 (96d) | ❌ |
| Peter | Apr 5 | Apr 15 | 10 | ✅ | 150.00 | No 2nd complete | ❌ |
| Sam | Jun 1 | Jun 1 | 0 | ✅ | 690.00 | Jun 2 (1d) | ✅ |
| pending_only | Jan 5 | — | — | ❌ | 0.00 | — | — |
| year_boundary | Dec 1 | Dec 15 | 14 | ✅ | 450.00 | Jan 15 (31d) | ✅ |
| mixed_status | Apr 1 | Apr 10 | 9 | ✅ | 350.00 | Apr 25 (15d) | ✅ |
| zero_dollar | May 1 | May 15 | 14 | ✅ | 100.00 | Jun 15 (31d) | ✅ |

**Totals:** 10 converted, Revenue: 3905.00, Sticky: 6 (Alice, Frank, Sam, year_boundary, mixed_status, zero_dollar)

---

### Paid Ad Channel (8 registered, 6 converted)

| Customer | Reg Date | First Complete | Days | Converted? | Net Revenue | 2nd Order ≤60d? | Sticky? |
|----------|----------|----------------|------|------------|-------------|-----------------|---------|
| Bob | Jan 15 | Mar 5 | 49 | ❌ | 120.00 | — | — |
| Eve | Mar 10 | Mar 12 | 2 | ✅ | 190.00 | Mar 18 (6d) | ✅ |
| Henry | Apr 15 | Apr 20 | 5 | ✅ | 410.00 | Sep 10 (143d) | ❌ |
| Leo | Jan 10 | Jan 15 | 5 | ✅ | 45.00 | No 2nd order | ❌ |
| Olivia | Mar 1 | — | — | ❌ | 0.00 | — | — |
| Rachel | Dec 15 | Dec 20 | 5 | ✅ | 250.00 | Jan 5 (16d) | ✅ |
| same_day | Jan 10 | Jan 20 | 10 | ✅ | 200.00 | No 2nd order | ❌ |
| refunded_then_done | Mar 1 | Mar 25 | 24 | ✅ | 350.00 | Apr 25 (31d) | ✅ |

**Totals:** 6 converted, Revenue: 1565.00, Sticky: 3 (Eve, Rachel, refunded_then_done)

---

### Referral Channel (8 registered, 8 converted)

| Customer | Reg Date | First Complete | Days | Converted? | Net Revenue | 2nd Order ≤60d? | Sticky? |
|----------|----------|----------------|------|------------|-------------|-----------------|---------|
| Carol | Feb 1 | Feb 12 | 11 | ✅ | 170.00 | May 15 (92d) | ❌ |
| Grace | Apr 1 | Apr 5 | 4 | ✅ | 105.00 | May 5 (30d) | ✅ |
| Jack | May 20 | May 31 | 11 | ✅ | 400.00 | Jun 1 (1d) | ✅ |
| Mia | Feb 5 | Feb 10 | 5 | ✅ | 250.00 | Feb 10 (0d) | ✅ |
| Quinn | Jan 31 | Jan 31 | 0 | ✅ | 160.00 | Feb 28 (28d) | ✅ |
| Tina | Jul 1 | Jul 5 | 4 | ✅ | 50.00 | Jul 10 (5d) | ✅ |
| pending_first | Feb 1 | Feb 25 | 24 | ✅ | 350.00 | Mar 25 (28d) | ✅ |
| month_boundary | Jan 31 | Jan 31 | 0 | ✅ | 450.00 | Feb 1 (1d) | ✅ |

**Totals:** 8 converted, Revenue: 1935.00, Sticky: 7 (Grace, Jack, Mia, Quinn, Tina, pending_first, month_boundary)

---

## Key Insights

| Insight | Finding |
|---------|---------|
| **Best Conversion** | Referral (100%) - everyone who came via referral bought within 30 days |
| **Fastest to Purchase** | Referral (7.38 days avg) - referral customers decide quickest |
| **Highest Revenue** | Organic ($3,905) - organic customers spend the most |
| **Most Loyal Customers** | Referral (87.5% stickiness) - referral customers come back most often |
| **Worst Performer** | Paid Ads (50% stickiness, 75% conversion) - expensive and less loyal |

---

## Business Recommendations

1. **Invest more in Referral programs** - highest conversion, fastest purchase, most loyal
2. **Optimize Paid Ads** - high cost but low stickiness; investigate ad quality
3. **Maintain Organic efforts** - highest revenue per customer despite slower conversion

---

## Common Mistakes to Avoid

| Mistake | Why Wrong | Correct Approach |
|---------|-----------|----------------|
| Counting pending/cancelled orders | These aren't real purchases | Only `status = 'completed'` |
| Including Bob (49 days) in converted | 49 > 30, so not converted | Strictly ≤ 30 days |
| Forgetting Mia's same-day 2nd order | 0 days is valid (≤60) | Count as sticky |
| Using total_registered for stickiness rate | Should be % of buyers, not all signups | Divide by converted_30d |
| Missing year_boundary's Jan 2024 order | Cross-year orders still count | Include all dates |

