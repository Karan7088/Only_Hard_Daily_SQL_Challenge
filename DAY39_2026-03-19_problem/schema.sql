 CREATE TABLE orders_raw (
    order_id INT,
    customer_id INT,
    product_ids VARCHAR(255),     -- comma separated
    quantities VARCHAR(255),      -- comma separated
    prices VARCHAR(255)           -- comma separated
);
