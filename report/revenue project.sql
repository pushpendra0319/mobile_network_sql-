#count customer of every operator city wise 
select * from operator;
select * from customers_ntr;
select * from recharges;
select count(customer_id) from customers_ntr ;

select count(c.customer_id)as customer_count, o.operator_name from customers_ntr c
inner join Usage_details u on c.customer_id=u.customer_id inner join recharges r on u.recharge_id=r.recharge_id
inner join plans p on r.plan_id=p.plan_id inner join operator o  on p.operator_id=o.operator_id group by 2;

select sum(amount_paid_rs), city,state, dense_rank () over (partition by city order by sum(amount_paid_rs) asc)as revenue from recharges 
inner join customers_ntr using(customer_id) group by 2,3;

#revenue generate
select sum(amount_paid_rs) from recharges;
select operator_name,state,sum(amount_paid_rs)as revenue, dense_rank() 
over (partition by state order by sum(amount_paid_rs) desc) as revenue_no
from customers_ntr c 
inner join Usage_details u on c.customer_id=u.customer_id 
inner join recharges r on u.recharge_id=r.recharge_id
inner join plans p on r.plan_id=p.plan_id inner join operator o  on p.operator_id=o.operator_id group by 1,2;