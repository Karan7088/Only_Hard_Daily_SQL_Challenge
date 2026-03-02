DROP TABLE IF EXISTS prod;

CREATE TABLE prod (
    product_id INT,
    price INT,
    price_date DATE,
    PRIMARY KEY (product_id, price_date)
);