-- Level 1 Exercise 2
-- Using JOIN you will perform the following queries:

-- List of countries that are shopping
SELECT DISTINCT country 
FROM transactions.company;

-- From how many countries the purchases are made
SELECT count(DISTINCT country) 
FROM transactions.company;

-- Identify the company with the highest average sales (solution with 'limit')
SELECT company_name, AVG(amount) FROM transactions.transaction AS tran
JOIN transactions.company AS com ON com.id = tran.company_id
GROUP BY tran.company_id
ORDER BY AVG(amount) DESC
LIMIT 1;

-- Identify the company with the highest average sales (solution without 'limit')
SELECT t1.company_name, t2.avg_amount_t2
FROM (
	SELECT company_id, AVG(amount) AS avg_amount_t2 
    FROM transactions.transaction
    GROUP BY company_id
) AS t2
JOIN company AS t1 ON t1.id = t2.company_id
WHERE t2.avg_amount_t2 = (
		SELECT max(avg_amount_t3) 
        FROM (
			SELECT AVG(amount) AS avg_amount_t3 FROM transactions.transaction
			GROUP BY company_id
		) AS t3
);

-- Level 1 Exercise 3
-- Using only subqueries (without using JOIN):

-- Show all transactions made by companies in Germany
SELECT * 
FROM transactions.transaction
WHERE company_id IN (
	SELECT id FROM transactions.company
    WHERE country = 'Germany'
);

-- List the companies that have made transactions for an amount higher than the average of all transactions
SELECT company_name 
FROM transactions.company
WHERE id IN (
	SELECT company_id 
    FROM transactions.transaction
	GROUP BY company_id
	HAVING sum(amount) > (
		SELECT AVG(comp_amount) 
        FROM (
			SELECT sum(amount) AS comp_amount FROM transactions.transaction
			GROUP BY company_id
		) AS t1
	)
);

-- Companies that do not have registered transactions will be removed from the system, provide the list of these companies
SELECT company_name 
FROM transactions.company
WHERE id NOT IN (
	SELECT company_id FROM transactions.transaction
);


-- Level 2 Exercise 1
-- Identify the five days that generated the largest amount of revenue for the company from sales. 
-- It shows the date of each transaction along with the sales total.

-- Level 2 Exercise 2
-- What is the average sales per country? It presents the results sorted from highest to lowest average.

-- Level 2 Exercise 3
-- In your company, a new project is being considered to launch some advertising campaigns to compete with the "Non Institute" company. 
-- For this, they ask you for the list of all transactions carried out by companies that are located in the same country as this company.
-- Display the list by applying JOIN and subqueries.
-- Display the listing by applying only subqueries.

-- Level 3 Exercise 1
-- It presents the name, telephone, country, date and amount of those companies that made transactions with a value between 100 and 200
-- euros and on any of these dates: April 29, 2021, July 20, 2021 and March 13, 2022. Sort the results from highest to lowest amount.

-- Level 3 Exercise 2
-- We need to optimize the allocation of resources and it will depend on the operational capacity that is required, 
-- so they ask you for the information about the amount of transactions that the companies carry out, but the HR department
-- is demanding and wants a list of the companies where you specify if they have more than 4 transactions or less.

