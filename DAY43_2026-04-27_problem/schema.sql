 DROP TABLE IF EXISTS product_price_history;
DROP TABLE IF EXISTS orders;

CREATE TABLE product_price_history (
    product_id INT,
    price DECIMAL(10,2),
    start_time DATETIME,
    end_time DATETIME
);

CREATE TABLE orders (
    order_id INT,
    product_id INT,
    order_time DATETIME,
    quantity INT,
    price_charged DECIMAL(10,2)
);
