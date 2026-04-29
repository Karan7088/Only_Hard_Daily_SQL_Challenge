with recursive cte as(select *,cast(concat(source,',',destination ) as char(1000)) lst from graph where source='a'
union all
select cte.source,graph.destination,cte.cost+graph.cost cost,concat(lst,',',graph.destination) as lst from cte inner join graph on cte.destination=graph.source and find_in_set(graph.destination ,lst)=0
)
select destination,min(cost) as min_cost,min(replace(lst,',','->')) as path  from cte group by 1 order by 1,2,3
 
