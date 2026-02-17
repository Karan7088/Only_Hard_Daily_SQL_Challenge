# 🔥 Day 20 – Ultra Hard MySQL Challenge  
## 🕵️ Multi-Level Money Laundering Detection Network

### 📅 Difficulty: Extreme  
### 🧠 Topics Covered:
- Recursive CTE
- Graph Traversal
- Window Functions
- Fraud Detection Logic
- Cycle Detection
- Ranking
- Edge Case Handling
- Performance Considerations

---

## 📂 Domain
**FinTech / Fraud Analytics**

You are working for a digital payments company (like PayPal/Stripe).  
Your task is to detect suspicious circular money movement chains that may indicate **money laundering rings**.

---

# 📊 Database Schema

## 1️⃣ users

| Column      | Type                          |
|------------|--------------------------------|
| user_id    | INT (Primary Key)             |
| country    | VARCHAR(50)                   |
| risk_level | ENUM('LOW','MEDIUM','HIGH')   |
| created_at | DATETIME                      |

---

## 2️⃣ transactions

| Column      | Type                          |
|------------|--------------------------------|
| txn_id     | INT (Primary Key)             |
| sender_id  | INT (FK → users.user_id)      |
| receiver_id| INT (FK → users.user_id)      |
| amount     | DECIMAL(12,2)                 |
| status     | ENUM('SUCCESS','FAILED')      |
| txn_time   | DATETIME                      |

---

# 🎯 Fraud Detection Rules

A transaction chain qualifies as a **Money Laundering Ring** if:

1. 🔁 It forms a **circular transaction chain**
   ```
   A → B → C → … → A
   ```

2. 👥 Contains **minimum 3 distinct users**

3. 💰 All transactions:
   - `status = 'SUCCESS'`
   - `amount > 10000`

4. 🚨 At least one user in the chain:
   - `risk_level = 'HIGH'`

5. ⏱ Entire chain completes within:
   - **48 hours**

6. 🔄 No user repeats  
   - Except starting/ending node

7. 🧠 Only unique cycles allowed  
   - Avoid duplicates caused by rotation  
   - Example:  
     ```
     101→205→309→101
     205→309→101→205  ❌ duplicate
     ```

---

# 🧠 Expected Output

| cycle_id | path | total_amount | user_count | has_high_risk | duration_hours |
|----------|------|--------------|------------|---------------|----------------|

### Example:

| 1 | 101→205→309→101 | 45000 | 3 | YES | 32 |

---

# ⚙️ Technical Strategy

### 1️⃣ Recursive CTE
Used to traverse transaction graph and build multi-level chains.

### 2️⃣ Cycle Detection
Detect when:
```
receiver_id = start_user
```

### 3️⃣ Duplicate Removal
Canonical cycle selection:
- Only keep cycle where starting user is minimum ID in cycle.

### 4️⃣ Time Constraint Enforcement
- Enforce chronological growth:
  ```
  txn_time > previous_txn_time
  ```
- Ensure:
  ```
  TIMESTAMPDIFF(HOUR) <= 48
  ```

### 5️⃣ Fraud Risk Validation
Join with `users` table to confirm:
```
risk_level = 'HIGH'
```

### 6️⃣ Ranking
Use:
```
DENSE_RANK() OVER (ORDER BY total_amount DESC)
```

---

# 🚨 Edge Cases Handled

- Negative duration issues
- Backward time traversal
- Infinite recursion
- Rotational duplicate cycles
- Repeated users inside chain
- Sub-chain explosion
- Chains longer than allowed depth
- Failed transactions
- Low-value transactions

---

# 🧪 Performance Considerations

For large datasets (10M+ rows), add:

```sql
CREATE INDEX idx_txn_sender ON transactions(sender_id);
CREATE INDEX idx_txn_receiver ON transactions(receiver_id);
CREATE INDEX idx_txn_time ON transactions(txn_time);
CREATE INDEX idx_txn_status_amount ON transactions(status, amount);
CREATE INDEX idx_user_risk ON users(risk_level);
```

Also:
- Limit recursion depth (e.g., < 6)
- Filter early in base query

---

# 🏆 Skills Demonstrated

- Advanced SQL recursion
- Graph cycle detection in relational databases
- Fraud analytics modeling
- Window function ranking
- Temporal constraint validation
- Data deduplication logic
- Production-level query design

---

# 💡 Real-World Relevance

This type of query is used in:

- AML (Anti-Money Laundering) systems
- Fraud detection engines
- Financial risk analytics
- Regulatory compliance reporting
- Suspicious Activity Report (SAR) generation

---

# 🚀 Author Notes

This challenge simulates real-world financial fraud detection logic  
using pure SQL without external graph engines.

Mastering this level of SQL means you can:

- Build graph logic inside relational systems
- Detect complex fraud rings
- Handle recursive edge cases
- Think like a data engineer + fraud analyst

---

## 🔥 Next Level Ideas

- Detect layered structuring patterns
- Identify high-frequency micro-splitting attacks
- Add country-based cross-border flagging
- Build fraud risk scoring model
- Optimize for billion-row datasets

---

**Happy Querying 🚀**