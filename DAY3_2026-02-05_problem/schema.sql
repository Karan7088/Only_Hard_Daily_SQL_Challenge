-- ============================================
-- CREATE TABLES
-- ============================================
 drop table if exists customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    email VARCHAR(100),
    country VARCHAR(50),
    registration_date DATE,
    acquisition_channel VARCHAR(50),
    INDEX idx_reg_date (registration_date),
    INDEX idx_country (country)
) ENGINE=InnoDB;

drop TABLE if exists orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2),
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('completed', 'refunded', 'cancelled', 'pending') DEFAULT 'completed',
    device_type ENUM('mobile', 'desktop', 'tablet') DEFAULT 'desktop',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_order_date (order_date),
    INDEX idx_customer_date (customer_id, order_date)
) ENGINE=InnoDB;
drop table if exists order_items;
CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_category VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    INDEX idx_category (product_category)
) ENGINE=InnoDB;
