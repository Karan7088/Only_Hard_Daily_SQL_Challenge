DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id        INT PRIMARY KEY,
    user_id         INT NOT NULL,
    transaction_id  VARCHAR(50) NOT NULL,
    order_datetime  DATETIME NOT NULL,
    status          VARCHAR(20) NOT NULL,   -- completed / cancelled / refunded / pending
    amount          DECIMAL(10,2),
    device_type     VARCHAR(20),            -- ios / android / web
    country         VARCHAR(50)
);

