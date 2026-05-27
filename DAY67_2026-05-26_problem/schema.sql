DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_price_history;

CREATE TABLE product_price_history (
    price_id INT,
    product_id VARCHAR(10),
    start_time DATETIME,
    end_time DATETIME,
    correct_price DECIMAL(10,2),
    charged_price DECIMAL(10,2),
    price_status VARCHAR(20)
);

CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    product_id VARCHAR(10),
    order_time DATETIME,
    quantity INT,
    amount_paid DECIMAL(10,2)
);

 
