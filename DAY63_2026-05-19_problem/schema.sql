DROP TABLE IF EXISTS inventory_audits;

CREATE TABLE inventory_audits (
    audit_id INT,
    warehouse_id VARCHAR(10),
    product_id VARCHAR(10),
    audit_time DATETIME,
    system_stock INT,
    physical_stock INT,
    adjustment_done VARCHAR(5)
);

