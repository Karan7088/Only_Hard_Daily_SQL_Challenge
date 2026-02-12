drop table trans;
CREATE TABLE trans
(
    tx_id INT PRIMARY KEY,
    sender_id INT ,
    receiver_id INT ,
    amount DECIMAL(15,2),
    status VARCHAR(20) CHECK (status IN ('success', 'failed')),
    tx_date DATE NOT NULL
);
