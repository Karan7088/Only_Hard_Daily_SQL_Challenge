  DROP TABLE IF EXISTS subscription_usage;
DROP TABLE IF EXISTS subscriptions;

CREATE TABLE subscriptions (
    subscription_id INT,
    customer_id INT,
    plan_name VARCHAR(20),
    start_date DATE,
    renewal_date DATE,
    status VARCHAR(20)
);

CREATE TABLE subscription_usage (
    usage_id INT,
    customer_id INT,
    usage_date DATE,
    minutes_used INT
);

