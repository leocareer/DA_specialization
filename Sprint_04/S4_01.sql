-- Level 1 Exercise 1
-- Perform a subquery that displays all users with more than 30 transactions using at least 2 tables.
SELECT name, surname
FROM users
WHERE id IN (
    SELECT user_id
    FROM transactions
    GROUP BY user_id
    HAVING COUNT(id) > 30
);

-- Level 1 Exercise 2
-- Show the average amount by IBAN of the credit cards in the Donec Ltd company, use at least 2 tables.
SELECT iban, ROUND(AVG(amount),2) 'average amount'
FROM transactions
JOIN credit_cards
ON transactions.card_id = credit_cards.id
WHERE business_id = (
	SELECT company_id 
    FROM companies
    WHERE company_name = 'Donec Ltd'
)
GROUP BY iban;

-- Level 2 Exercise 1
-- Create a new table that reflects the credit card status based on whether the last three transactions were declined and generate the following query: how many cards are active?

CREATE TABLE card_status (
    card_id VARCHAR(20) PRIMARY KEY,
    activity TINYINT,
    FOREIGN KEY (card_id) REFERENCES credit_cards(id)
);

INSERT INTO card_status (card_id, activity)
SELECT
    t1.card_id,
    CASE
        WHEN COUNT(t1.id) >= 3 AND SUM(t1.declined) = 3 THEN 0
        ELSE 1
    END AS activity
FROM (
    SELECT card_id, declined, id
    FROM transactions
    ORDER BY timestamp DESC
) t1
GROUP BY t1.card_id;

SELECT COUNT(activity) 'how many cards are active'
FROM card_status
WHERE activity = 1;

-- Level 3 Exercise 1
-- Create a table with which we can join the data from the new products.csv file with the created database, taking into account that from transaction you have product_ids. Generate the following query: we need to know the number of times each product has been sold.
SELECT product_id, COUNT(transaction_id) AS how_many_times_sold
FROM transaction_items
JOIN transactions ON transaction_items.transaction_id = transactions.id
JOIN products ON products.id = transaction_items.product_id
WHERE declined = 0
GROUP BY product_id
ORDER BY how_many_times_sold DESC;