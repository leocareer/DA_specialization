-- Level 1 Exercise 2
-- Using JOIN you will perform the following queries:

-- List of countries that are shopping
SELECT DISTINCT country 
FROM transactions.company
ORDER BY country;

-- From how many countries the purchases are made
SELECT count(DISTINCT country) 
FROM transactions.company;

-- Identify the company with the highest average sales (solution with 'limit')
SELECT company_name, AVG(amount) AS avg_amount FROM transactions.transaction AS t1
JOIN transactions.company AS t2 
ON t2.id = t1.company_id
GROUP BY t1.company_id
ORDER BY avg_amount DESC
LIMIT 1;

-- Identify the company with the highest average sales (solution without 'limit')
SELECT company_name, avg_amount_t2
FROM (
	SELECT company_id, AVG(amount) AS avg_amount_t2 
    FROM transactions.transaction
    GROUP BY company_id
) AS t2
JOIN company AS t1 ON t1.id = t2.company_id
WHERE avg_amount_t2 = (
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

-- with 'limit'
SELECT sum(amount), DATE(timestamp)
FROM transactions.transaction
GROUP BY DATE(timestamp)
ORDER BY sum(amount) DESC
LIMIT 5;

-- with window function
SELECT sum_amount, date_timestamp
FROM (
	SELECT sum(amount) AS sum_amount, DATE(timestamp) AS date_timestamp,
	ROW_NUMBER() OVER(ORDER BY sum(amount) DESC) AS ind_amount
    FROM transactions.transaction
    GROUP BY date_timestamp
) AS t
WHERE ind_amount <= 5
ORDER BY date_timestamp;

-- Level 2 Exercise 2
-- What is the average sales per country? It presents the results sorted from highest to lowest average.
SELECT AVG(amount) AS country_amount, country
FROM transactions.company AS t1
JOIN transactions.transaction AS t2
ON t1.id = t2.company_id
GROUP BY country
ORDER BY country_amount;

-- Level 2 Exercise 3
-- In your company, a new project is being considered to launch some advertising campaigns to compete with the "Non Institute" company. 
-- For this, they ask you for the list of all transactions carried out by companies that are located in the same country as this company.
-- Display the list by applying JOIN and subqueries.
-- Display the listing by applying only subqueries.

-- with join 
SELECT DISTINCT company_name
FROM transactions.transaction AS t1
JOIN transactions.company AS t2
ON t2.id = t1.company_id
WHERE country = (
	SELECT country FROM transactions.company
    WHERE company_name LIKE 'Non Institute'
)
AND company_name <> 'Non Institute'
ORDER BY company_name;

-- with only subqueries
SELECT company_name
FROM transactions.company AS t1
WHERE country IN (
	SELECT country FROM transactions.company
    WHERE company_name LIKE 'Non Institute'
)
AND company_name <> 'Non Institute'
AND EXISTS (
	SELECT company_id FROM transactions.transaction AS t2
    WHERE t1.id = t2.company_id
)
ORDER BY company_name;

-- Level 3 Exercise 1
-- It presents the name, telephone, country, date and amount of those companies that made transactions with a value between 100 and 200
-- euros and on any of these dates: April 29, 2021, July 20, 2021 and March 13, 2022. Sort the results from highest to lowest amount.
SELECT company_name, phone, country, DATE(timestamp), amount
FROM transactions.company AS t1
JOIN transactions.transaction AS t2
ON t1.id = t2.company_id
WHERE DATE(timestamp) IN ('2021-04-29','2021-07-20','2022-03-13')
AND amount BETWEEN 100 AND 200
ORDER BY amount;

-- Level 3 Exercise 2
-- We need to optimize the allocation of resources and it will depend on the operational capacity that is required, 
-- so they ask you for the information about the amount of transactions that the companies carry out, but the HR department
-- is demanding and wants a list of the companies where you specify if they have more than 4 transactions or less.
SELECT company_name,
	CASE 
		WHEN count(t2.id) > 4 THEN '> 4 transactions'
		ELSE '<= 4 transactions'
	END AS transaction_count
FROM transactions.company AS t1
JOIN transactions.transaction AS t2
ON t1.id = t2.company_id
GROUP BY t1.id
ORDER BY transaction_count DESC;