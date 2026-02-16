with base_events as (
select *,
       date(event_time) as date,
       case
            when event_type in ('purchase','TRANSFER_IN') and quantity < 0
                then quantity * -1
            when event_type = 'adjustment'
                then quantity
            when event_type in ('transfer_out','sale') and quantity > 0
                then quantity * -1
            else quantity
       end as qty
from inventory_events
),

stock_calc as (
select *,
       row_number() over(partition by warehouse_id,product_id order by date,event_time) rn,
       row_number() over(partition by warehouse_id,product_id,date order by event_time desc) as rn2,

       sum(qty) over(
            partition by warehouse_id,product_id
            order by event_time
            rows between unbounded preceding and current row
       ) closing_stock,

       abs(ifnull(sum(case when qty>0 then qty end)
            over(partition by product_id,warehouse_id,date),0)) as total_in,

       abs(ifnull(sum(case when qty<0 then qty end)
            over(partition by product_id,warehouse_id,date),0)) as total_out

from base_events
order by 2,3,4
)

select product_id,warehouse_id,date,
       ifnull(lag(closing_stock) over(
            partition by product_id,warehouse_id
            order by date
       ),0) as opening_stock,
       closing_stock,total_in,total_out,
       case
            when (select min(closing_stock)
                  from stock_calc
                  where product_id = a.product_id
                    and warehouse_id = a.warehouse_id
                    and date = a.date) > 0
            then 0 else 1
       end flag,

       (select min(event_time)
        from stock_calc
        where product_id = a.product_id
          and warehouse_id = a.warehouse_id
          and date = a.date
          and closing_stock < 0) as first_stamp_neg

from stock_calc a
where rn2 = 1;










