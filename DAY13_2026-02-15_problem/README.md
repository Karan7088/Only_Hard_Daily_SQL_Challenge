🧾 Day XX – Ledger Transaction Balance Validation

📅 Date: 2026-02-15
📘 Difficulty: Hard
🧠 Topic: Window Functions, Conditional Aggregation, Financial Data Validation
📂 Domain: Finance / Accounting Systems

🧩 Problem Statement

You are given a table ledger_entries that records accounting entries for financial transactions.

Each transaction (txn_id) may contain multiple rows, representing DEBIT and CREDIT entries.

Your task is to:

Compute total debit and credit per transaction.

Count number of debit and credit entries per transaction.

Calculate imbalance amount.

Label each transaction as:

✅ valid → if total debit = total credit

❌ invalid → otherwise

Return only transactions that contain at least one debit AND one credit.