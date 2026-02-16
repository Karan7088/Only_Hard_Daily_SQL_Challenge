WITH base AS (
    SELECT
        txn_id,
        entry_type,
        amount,

        -- Total Debit per Transaction
        SUM(CASE WHEN entry_type = 'debit' THEN amount END)
            OVER (PARTITION BY txn_id) AS debit_sum,

        -- Total Credit per Transaction
        SUM(CASE WHEN entry_type = 'credit' THEN amount END)
            OVER (PARTITION BY txn_id) AS credit_sum,

        -- Count of Credit Entries
        COUNT(CASE WHEN entry_type = 'credit' THEN 1 END)
            OVER (PARTITION BY txn_id) AS credit_cnt,

        -- Count of Debit Entries
        COUNT(CASE WHEN entry_type = 'debit' THEN 1 END)
            OVER (PARTITION BY txn_id) AS debit_cnt,

        -- Imbalance Calculation
        SUM(CASE WHEN entry_type = 'debit' THEN amount END)
            OVER (PARTITION BY txn_id)
        -
        SUM(CASE WHEN entry_type = 'credit' THEN amount END)
            OVER (PARTITION BY txn_id) AS imbalance,

        -- Validation Status
        CASE
            WHEN
                SUM(CASE WHEN entry_type = 'debit' THEN amount END)
                    OVER (PARTITION BY txn_id)
                =
                SUM(CASE WHEN entry_type = 'credit' THEN amount END)
                    OVER (PARTITION BY txn_id)
            THEN 'valid'
            ELSE 'invalid'
        END AS status

    FROM ledger_entries
)

SELECT *
FROM base
WHERE credit_cnt > 0
  AND debit_cnt > 0;