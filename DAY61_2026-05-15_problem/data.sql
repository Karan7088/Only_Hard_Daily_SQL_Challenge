 with base as(select *,
case  status when 'placed' then 1 when 'accepted' then 2 when 'picked_up' then 3 else 4 end as st,
row_number() over(partition by order_id,status) as dedup from delivery_events order by 2,3)
,cte as(select *,st-lag(st) over(partition by order_id order by event_time) as df from base where dedup=1
)
,cte2 as(select *
,
count(case when status='cancelled' then 1 end) over(partition by order_id) as cancel,
max(ifnull(df,1)) over(partition by order_id) as mx from cte)
,cte3 as(select *,count(*) over(partition by order_id) as c from cte2 where mx=1
)
,cte4 as(select *,
timestampdiff(minute,
lag(event_time) over(partition by order_id order by event_time),event_time)  as tm_df
from cte3 where c=4)
,cte5 as(select *,case when tm_df>10 and status='accepted' then
'PLACED to ACCEPTED' 
when tm_df>30 and status='picked_up' then
'ACCEPTED to PICKED_UP' 
when tm_df>40 and status='delivered' then
'PICKED_UP to DELIVERED'  end as reason 
from cte4 where cancel=0)
-- select * from cte5;
,cte6 as(select order_id,max(case when status='placed' then event_time end ) over(partition by order_id) placed_time  ,
max(case when status='accepted' then event_time end ) over(partition by order_id) accepted_time ,
max(case when status='picked_up' then event_time end) over(partition by order_id) picked_up_time   ,
max(case when status='delivered' then event_time end) over(partition by order_id) delivered_time   ,
reason   breach_stage from cte5 )-- select * from cte6;
 select * ,
 case when breach_stage like '%_accepted%' then TIMESTAMPDIFF(MINUTE, placed_time, accepted_time) - 10
  when breach_stage like '%_picked_up%' then TIMESTAMPDIFF(MINUTE,accepted_time, picked_up_time) -30
  when breach_stage like '%_delivered%' then TIMESTAMPDIFF(MINUTE,picked_up_time, delivered_time) -40 
 end as breach_minutes 
 from cte6 where breach_stage is not null 
