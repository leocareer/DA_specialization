-- Level 1 Exercise 2
-- Using JOIN you will perform the following queries:

-- List of countries that are shopping
select distinct country from transactions.company;

-- From how many countries the purchases are made
select count(distinct country) from transactions.company;

-- Identify the company with the highest average sales (solution with 'limit')
select company_name, avg(amount) from transactions.transaction as tran
join transactions.company as com on com.id = tran.company_id
group by tran.company_id
order by avg(amount) desc
limit 1;

-- Identify the company with the highest average sales (solution without 'limit')
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


-- Level 1 Exercise 3
-- Using only subqueries (without using JOIN):

-- Show all transactions made by companies in Germany
select * from transactions.transaction
where company_id in (
	select id from transactions.company
    where country = 'Germany'
);

-- List the companies that have made transactions for an amount higher than the average of all transactions
select company_name from transactions.company
where id in (
	select company_id from transactions.transaction
	group by company_id
	having sum(amount) > (
			select avg(comp_amount) from (
				select sum(amount) as comp_amount from transactions.transaction
				group by company_id
			) as t1
	)
);

-- Companies that do not have registered transactions will be removed from the system, provide the list of these companies
select company_name from transactions.company
where id not in (
	select company_id from transactions.transaction
);
	


