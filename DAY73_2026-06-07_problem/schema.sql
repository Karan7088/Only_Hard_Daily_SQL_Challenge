 CREATE TABLE product_launches (
    launch_id INT PRIMARY KEY,
    impacted_product_id VARCHAR(10),
    new_product_id VARCHAR(10),
    launch_date DATE
);

CREATE TABLE daily_sales (
    sale_id INT PRIMARY KEY,
    product_id VARCHAR(10),
    sale_date DATE,
    units_sold INT,
    revenue DECIMAL(10,2)
);
