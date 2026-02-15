INSERT INTO ledger_entries 
(entry_id, txn_id, account_id, entry_type, amount)
VALUES

-- ✅ CASE 1: VALID (Single debit = single credit)
(1, 1001, 10, 'debit', 500.00),
(2, 1001, 20, 'credit', 500.00),

-- ✅ CASE 2: VALID (Multiple debit, single credit)
(3, 1002, 10, 'debit', 300.00),
(4, 1002, 11, 'debit', 200.00),
(5, 1002, 20, 'credit', 500.00),

-- ❌ CASE 3: MISSING CREDIT
(6, 1003, 10, 'debit', 700.00),

-- ❌ CASE 4: MISSING DEBIT
(7, 1004, 20, 'credit', 400.00),

-- ❌ CASE 5: AMOUNT MISMATCH (sum mismatch)
(8, 1005, 10, 'debit', 1000.00),
(9, 1005, 20, 'credit', 900.00),

-- ❌ CASE 6: AMOUNT MISMATCH (multi debit/credit mismatch)
(10, 1006, 10, 'debit', 200.00),
(11, 1006, 11, 'debit', 300.00),
(12, 1006, 20, 'credit', 400.00),
(13, 1006, 21, 'credit', 50.00),

-- ⚠️ CASE 7: Zero Amount (should still validate sum logic)
(14, 1007, 10, 'debit', 0.00),
(15, 1007, 20, 'credit', 0.00),

-- ❌ CASE 8: Debit = Credit but multiple duplicate rows
(16, 1008, 10, 'debit', 250.00),
(17, 1008, 10, 'debit', 250.00),
(18, 1008, 20, 'credit', 500.00),

-- ❌ CASE 9: Credit greater than debit
(19, 1009, 10, 'debit', 100.00),
(20, 1009, 20, 'credit', 200.00),

-- ❌ CASE 10: Large precision mismatch
(21, 1010, 10, 'debit', 100.005),
(22, 1010, 20, 'credit', 100.004);
