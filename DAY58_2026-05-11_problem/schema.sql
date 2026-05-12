DROP TABLE IF EXISTS inventory_snapshots;

CREATE TABLE inventory_snapshots (
    snapshot_id INT,
    product_id INT,
    snapshot_time DATETIME,
    stock_quantity INT
);

