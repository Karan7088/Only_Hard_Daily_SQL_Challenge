 with activity_base as (
    select *,
           case 
               when activity_type = 'login' then 1 
               when activity_type = 'cancel' then 3 
               else 2 
           end as activity_flag
    from user_activity
),

daily_summary as (
    select 
        user_id,
        activity_date,
        min(activity_flag) as min_flag,
        max(activity_flag) as max_flag
    from activity_base
    group by user_id, activity_date
),

valid_days as (
    select *,
           date_sub(activity_date,
                    interval row_number() over(partition by user_id order by activity_date) day) as grp_key
    from daily_summary
    where min_flag = 1 
      and max_flag != 3
),

streak_calc as (
    select *,
           min(activity_date) over(partition by user_id, grp_key) as streak_start,
           count(*) over(partition by user_id, grp_key) as streak_len,
           max(grp_key) over(partition by user_id) as latest_grp,
           max(activity_date) over(partition by user_id) as max_date
    from valid_days
),

max_streak as (
    select *,
           max(streak_len) over(partition by user_id) as max_streak_len
    from streak_calc
),

final_calc as (
    select 
        user_id,
        max_streak_len as longest_streak,

        (select min(activity_date)
         from max_streak 
         where a.max_streak_len = streak_len 
           and a.user_id = user_id) as longest_streak_start,

        (select streak_len 
         from max_streak 
         where a.max_date = activity_date 
           and user_id = a.user_id 
         limit 1) as current_streak

    from max_streak a
)

select * 
from final_calc 
where longest_streak_start is not null
group by user_id, longest_streak, longest_streak_start, current_streak

union

select distinct 
    user_id, 
    0, 
    null, 
    0
from user_activity
where user_id not in (
    select distinct user_id from streak_calc
)

order by 1;
