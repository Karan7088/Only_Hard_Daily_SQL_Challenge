
DROP TABLE IF EXISTS plan_changes;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS users;


/* ===============================
   CREATE TABLES
================================ */

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE NOT NULL
);

CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    base_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE plan_changes (
    change_id INT PRIMARY KEY,
    subscription_id INT NOT NULL,
    change_date DATE NOT NULL,
    new_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);


