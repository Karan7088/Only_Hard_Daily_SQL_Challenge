drop table if exists ledger_entries;
CREATE TABLE ledger_entries (
    entry_id BIGINT PRIMARY KEY,
    txn_id BIGINT NOT NULL,
    account_id INT NOT NULL,
    entry_type VARCHAR(10) CHECK (entry_type IN ('debit','credit')),
    amount DECIMAL(15,2) NOT NULL,
    entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);