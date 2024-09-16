-- 2)

select distinct country from transactions.company;

select count(distinct country) from transactions.company;

select company_id, avg(amount) from transactions.transaction
group by company_id;

select company_name, avg(amount) from transactions.transaction as tran
join transactions.company as com on com.id = tran.company_id
group by tran.company_id
order by avg(amount) desc
limit 1;

select t1.company_name, t2.avg_amount_t2
from (
	select company_id, avg(amount) as avg_amount_t2 from transactions.transaction
    group by company_id
) as t2
join company as t1 on t1.id = t2.company_id
where t2.avg_amount_t2 = (
    select max(avg_amount_t3) from (
        select avg(amount) as avg_amount_t3 from transactions.transaction
		group by company_id
    ) as t3
);
