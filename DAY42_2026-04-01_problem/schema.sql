DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;


-- 🧱 CREATE TABLES
CREATE TABLE Products (
    product_id VARCHAR(10),
    launch_date DATE
);
 CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id VARCHAR(10),
    order_date DATE
);


