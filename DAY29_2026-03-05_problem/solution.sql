with base as (
    select slot_id, start_time as tme from campaigns
    union
    select slot_id, end_time as tme from campaigns
),

base2 as (
    select
        slot_id,
        tme as st,
        lead(tme) over(partition by slot_id order by tme) as ed
    from base
),

atomic_tme as (
    select
        slot_id,
        st,
        ed,
        timestampdiff(minute, st, ed) as df
    from base2
    where ed is not null
),

campaign_info as (
    select
        campaign_id,
        slot_id,
        start_time,
        end_time,
        priority,
        budget
    from campaigns
),

active_campaigns as (
    select
        a.slot_id,
        a.st,
        a.ed,
        c.campaign_id,
        c.priority,
        c.budget,
        c.start_time,
        row_number() over(
            partition by a.slot_id, a.st, a.ed
            order by c.priority desc, c.budget desc, c.start_time asc
        ) as rn
    from atomic_tme a
    join campaign_info c
      on a.slot_id = c.slot_id
     and c.start_time <= a.st
     and c.end_time >= a.ed
)

select
    slot_id,
    st as start_time,
    ed as end_time,
    campaign_id
from active_campaigns
where rn = 1
order by slot_id, st;