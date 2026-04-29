# 🔥 Day 46 — Extreme Hard SQL Challenge  
## Shortest Path in Weighted Graph (Recursive CTE)

---

## 🧠 Problem Overview  

This challenge focuses on solving a **graph traversal problem using SQL recursion**.

You are given a dataset representing a **directed weighted graph**, where each connection between nodes has an associated cost.

The goal is to simulate **shortest path computation** using SQL, similar to graph algorithms like Dijkstra — but implemented purely with recursive logic.

---

## 🎯 Objective  

Starting from a given node (`A`), determine:

- The **minimum cost** required to reach each node  
- The **exact path** taken to reach that node  

---

## ⚙️ Key Challenges  

- Handling **recursive traversal** across multiple levels  
- Preventing **infinite loops due to cycles**  
- Tracking full **path history dynamically**  
- Evaluating **multiple competing paths**  
- Selecting the **optimal (lowest cost) path**  

---

## ⚠️ Constraints  

- The graph contains:
  - Cycles  
  - Multiple paths to the same node  
  - Misleading direct edges (higher cost than indirect paths)  

- A node **cannot be revisited within the same path**  

- Paths with higher cost than an already discovered optimal path should be ignored  

---

## 📊 Final Output  

| destination | min_cost | path                  |
|------------|----------|-----------------------|
| B          | 5        | A→B                  |
| C          | 8        | A→B→C               |
| D          | 9        | A→B→C→D            |
| E          | 11       | A→B→C→D→E         |
| F          | 14       | A→B→C→D→E→F      |
| G          | 16       | A→B→C→D→E→F→G   |
| H          | 15       | A→B→C→D→H         |
| I          | 17       | A→B→C→D→H→I      |

---

## 🧨 What This Tests  

- Advanced **Recursive CTE usage**  
- Graph traversal logic in SQL  
- Path construction and tracking  
- Cycle detection and avoidance  
- Optimization using cost-based pruning  

---

## 💡 Key Insight  

This problem demonstrates how SQL can be extended beyond traditional querying into solving **algorithmic problems**, particularly graph-based computations.

---

## 🚀 Difficulty Level  

**Extreme Hard** — typically seen in advanced data engineering or product-based company interviews.

--- 
