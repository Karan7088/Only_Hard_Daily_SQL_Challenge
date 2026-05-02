DROP TABLE IF EXISTS price_logs;

CREATE TABLE price_logs (
    product_id INT,
    price INT,
    start_time DATETIME,
    end_time DATETIME
);
