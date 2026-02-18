WITH RECURSIVE CTE AS(select *,1 as lvl from Referrals
  union ALL

  select CTE.referrer_id,Referrals.referee_id,Referrals.signup_date ,lvl+1 from CTE  join Referrals 
  on CTE.referee_id=Referrals.referrer_id
  ) 

select referrer_id,sum(case when lvl=1 then 10 when lvl=2 then 5 when lvl=3 then 2 else 1 end) as referral_points
,group_concat(concat(referee_id,'(L',lvl,')') order by lvl,referee_id SEPARATOR '->') as reffer_tree 
from CTE group by 1
  
  union 

  select user_id,0,null from Users   where user_id not in (select dIstinct referrer_id from CTE)
  order by 1;
