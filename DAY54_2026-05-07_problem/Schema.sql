create table delivery_orders(
order_id int,
driver_id int,
customer_id int,
restaurant_id int,
order_time datetime,
delivery_time datetime,
delivery_status varchar(20),
order_amount decimal(10,2)
);
