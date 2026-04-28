DROP TABLE IF EXISTS refunds;
DROP TABLE IF EXISTS orders;
-- 🔻 DROP TABLES
-- 💣 INSERT DATA (Brutal Test Cases)
-- 🏗️ CREATE TABLES

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2)
);

CREATE TABLE refunds (
    refund_id INT PRIMARY KEY,
    order_id INT,
    refund_date DATE,
    refund_amount DECIMAL(10,2)
); 
