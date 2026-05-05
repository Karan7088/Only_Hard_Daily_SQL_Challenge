 # Day 52 — Only Hard Daily SQL Challenge

## 🧠 Problem Title

**Employee Hierarchy Traversal with Cycle Detection**

---

## 📌 Problem Statement

You are given an employee hierarchy dataset where each employee may report to another employee (their manager). This forms a directed structure that can represent:

* Simple chains (linear hierarchy)
* Trees (branching hierarchy)
* Cycles (invalid or circular reporting)
* Broken links (manager does not exist in dataset)

Your task is to analyze this structure and, for **each employee**, determine:

1. **Root Manager**
2. **Chain Length**
3. **Cycle Detection Flag**

---

## 📊 Definitions

### 🔹 Employee Hierarchy

Each row represents:

* `emp_id` → employee
* `manager_id` → direct manager

---

## 🎯 Expected Output Columns

| Column         | Description                                             |
| -------------- | ------------------------------------------------------- |
| `emp_id`       | Employee ID                                             |
| `root_manager` | Final reachable manager (NULL if cycle or broken chain) |
| `chain_length` | Number of unique nodes traversed                        |
| `has_cycle`    | 1 if cycle exists, else 0                               |

---

## 🧠 Rules & Logic (VERY IMPORTANT)

---

### 1️⃣ Traversal Rule

For each employee:

* Start from `emp_id`
* Move to `manager_id`
* Continue upward recursively

---

### 2️⃣ Chain Termination Conditions

Traversal stops when ANY of the following occurs:

#### ✅ Case A: Root Reached

* `manager_id IS NULL`
* This is a valid hierarchy end

#### ⚠️ Case B: Cycle Detected

* A node repeats in the traversal path
* Example:

  ```
  5 → 6 → 5
  ```
* Once a repeated node is found → stop

#### ⚠️ Case C: Broken Chain (Orphan)

* Manager does not exist in dataset
* Example:

  ```
  33 → 999 (999 not present)
  ```

---

### 3️⃣ Chain Length Definition

> **Chain length = number of UNIQUE nodes visited before termination**

---

#### 🔹 Examples

##### Normal Chain

```
1 → 2 → 3 → NULL
```

Chain length = **3**

---

##### Cycle

```
7 → 8 → 9 → 10 → 8
```

Unique nodes:

```
7, 8, 9, 10
```

Chain length = **4**
❌ Do NOT count repeated `8`

---

##### Self Loop

```
4 → 4
```

Chain length = **1**

---

##### Small Cycle

```
5 → 6 → 5
```

Chain length = **2**

---

##### Broken Chain

```
33 → 999
```

Chain length = **1**

---

### 4️⃣ Root Manager Logic

| Case                                          | Root Manager                          |
| --------------------------------------------- | ------------------------------------- |
| Normal chain                                  | Final node where `manager_id IS NULL` |
| Cycle                                         | NULL                                  |
| Broken chain                                  | NULL                                  |
| Self-managed root (emp = manager = NULL case) | itself                                |

---

### 5️⃣ Cycle Detection Rule

A cycle exists if:

* A node appears more than once in traversal
* OR employee manages themselves (`emp_id = manager_id`)

---

### 6️⃣ Important Constraints

* Each employee must be processed independently
* Traversal must follow **actual hierarchy direction**
* Do NOT count duplicate nodes in chain length
* Cycle detection must NOT break level counting logic
* Ensure recursion terminates properly

---

## ⚠️ Common Pitfalls

❌ Counting repeated node in cycle
❌ Stopping recursion too early
❌ Incorrect root detection in broken chains
❌ Mixing traversal logic with aggregation logic
❌ Assuming tree structure (it’s a graph problem)

---

## 🧨 Key Insight

> This is NOT just a hierarchy problem —
> it is a **graph traversal problem with cycle detection**

---

## 🚀 What This Tests

* Recursive thinking in SQL
* Handling non-ideal data (cycles, missing links)
* Path tracking and state management
* Edge case handling
* Clean aggregation after recursion

---

## 🏁 Final Goal

Build a solution that correctly identifies:

* How far each employee can traverse
* Whether their path is valid or cyclic
* Where their hierarchy ends

---

## 💡 Real-World Relevance

This type of logic is used in:

* Organizational hierarchy validation
* Fraud detection (circular dependencies)
* Supply chain graphs
* Network traversal problems
* Data lineage systems

---

**If you can solve this cleanly, you’re operating at an advanced SQL level.**
