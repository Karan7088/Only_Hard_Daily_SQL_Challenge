  # 💀 Day 38 – Only Hard Daily SQL Challenge  
📅 Date: 2026-03-18  

## 📌 Problem: Subscription Event Validation System

In this challenge, we are given a `subscriptions_log` table that tracks user subscription lifecycle events.

Each row represents an event such as:
- `start`
- `renewal`
- `pause`
- `resume`
- `cancel`

---

## 🎯 Objective

Determine whether each user's sequence of events is:

- ✅ `valid_user` → follows correct lifecycle rules  
- ❌ `invalid_user` → contains invalid or inconsistent transitions  

---

## 🧠 Business Rules

### 🔹 Lifecycle Rules

- `start` → begins a subscription  
- `renewal` → continues an active subscription (does NOT change state)  
- `pause` → temporarily stops subscription  
- `resume` → resumes from pause  
- `cancel` → permanently ends subscription  

---

### 🔹 Valid Transitions

| Previous State | Allowed Next Event |
|---------------|------------------|
| start         | renewal / pause / cancel |
| renewal       | renewal / pause / cancel |
| pause         | resume |
| resume        | pause / cancel |
| cancel        | start |

---

### 🔹 Invalid Transitions

- resume without pause  
- cancel without active session  
- start while already active  
- pause without active state  
- cancel → renewal  
- resume → start  

---

### 🔹 Special Handling

- `renewal` is ignored in state transitions (used only for continuity)  
- Multiple pause-resume cycles are allowed  
- Events are grouped into lifecycles using `cancel` as boundary  

---

## ⚙️ Approach

### 1. Event Sequencing
Assign numeric sequence to events:
```sql
start = 1, pause = 2, resume = 3, cancel = 4, renewal = 0
