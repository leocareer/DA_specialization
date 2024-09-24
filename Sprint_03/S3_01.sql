-- Level 1 Exercise 1
/* Your task is to design and create a table called "credit_card" that stores crucial details about 
credit cards. The new table must be able to uniquely identify each card and establish an appropriate 
relationship with the other two tables ("transaction" and "company"). After creating the table, 
you will need to enter the information from the document called "data_introduir_credit". 
Remember to show the diagram and make a brief description of it. */

-- Creating a table
CREATE TABLE credit_card (
    id VARCHAR(10) NOT NULL,
    iban VARCHAR(34) NOT NULL,
    pan VARBINARY(128) NOT NULL,
    pin VARBINARY(64) NOT NULL,
    cvv VARBINARY(64) NOT NULL,
    expiring_date DATE NOT NULL,
    PRIMARY KEY (id)
);

-- View the table
SELECT * FROM transactions.credit_card;

-- Setting up a secret key to encrypt data
SET @encryption_key = UNHEX('5f7972d647ab04a55ea4daa7c314bdbf');

-- View data to check if loading is correct
SELECT 
    id, 
    iban, 
    CAST(AES_DECRYPT(pan, @encryption_key) AS CHAR(16)) AS pan, 
    CAST(AES_DECRYPT(pin, @encryption_key) AS CHAR(4)) AS pin, 
    CAST(AES_DECRYPT(cvv, @encryption_key) AS CHAR(3)) AS cvv, 
    expiring_date
FROM credit_card;

-- View data to check encryption is working
SELECT 
    id, 
    iban, 
    CAST(pan AS CHAR(16)) AS pan, 
    CAST(pin AS CHAR(4)) AS pin, 
    CAST(cvv AS CHAR(3)) AS cvv, 
    expiring_date
FROM credit_card;

-- View all indexed columns
SELECT *
FROM information_schema.statistics
WHERE TABLE_SCHEMA = 'transactions';

-- Сreating an index
CREATE INDEX idx_credit_card_id ON transaction(credit_card_id);

-- Сheck that the index has been created
SHOW INDEX FROM transaction;

-- Сreating a foreign key
ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

-- Level 1 Exercise 2
/* The Human Resources department has identified an error in the account number of the user 
with ID CcU-2938. The information to be displayed for this record is: R323456312213576817699999. 
Remember to show that the change was made. */

-- Update tuple with identifier CcU-2938 and change IBAN to new one
UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';

-- Checking for changes
SELECT id, iban, expiring_date,
    CAST(AES_DECRYPT(pan, @encryption_key) AS CHAR(16)) AS pan, 
    CAST(AES_DECRYPT(pin, @encryption_key) AS CHAR(4)) AS pin, 
    CAST(AES_DECRYPT(cvv, @encryption_key) AS CHAR(3)) AS cvv 
FROM credit_card
WHERE id = 'CcU-2938';

-- Level 1 Exercise 3
/* In the 'transaction' table, enter a new user with the following information: 
Id: 108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id: CcU-9999
company_id: b-9999
user_id: 9999
lat: 829.999
longitude: -117.999
amount: 111.11
declined: 0	*/

-- Adding a record to company with custom data
INSERT INTO company (id, company_name, phone, email, country, website)
VALUES (
    'b-9999',
    'Temp',
    '11 11 11 11 11',
    'temp@temp.temp',
    'Temp',
    'https://temp.temp'
);

-- Adding a record to credit_card with custom data
INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date)
VALUES (
    'CcU-9999',
    'TEMP1111111111111111111111',
    '11111111111111111111',
    '1111',
    '111',
    '2030-12-31'
);

-- Adding a record to the transaction with the requested data
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES (
    '108B1D1D-5B23-A76C-55EF-C568E49A99DD',
    'CcU-9999',
    'b-9999',
    '9999',
    829.999,
    -117.999,
    111.11,
    0
);

-- View added entry
SELECT * FROM transactions.transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

-- Level 1 Exercise 4
/* From human resources you are asked to delete the "pan" column from the credit_*card table. 
Remember to show the change made. */

ALTER TABLE credit_card
DROP COLUMN pan;

-- Level 2 Exercise 1
/* Delete the record with ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 from the transaction table
in the database. */

-- Viewing a record that requires deletion
SELECT * FROM transactions.transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

-- View table information to see storage type
SHOW TABLE STATUS LIKE 'transaction';

-- Deleting a record
START TRANSACTION;
DELETE FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';
ROLLBACK;
COMMIT;

-- View all indexed columns
SELECT *
FROM information_schema.statistics
WHERE TABLE_SCHEMA = 'transactions';

-- Level 2 Exercise 2
/* The marketing department wants to have access to specific information to perform analysis and 
effective strategies. Requested to create a view that provides key details about companies and their 
transactions. You will need to create a view called VistaMarketing that contains the following 
information: Company name. Contact phone number. Country of residence Average purchase made by each
company. Presents the created view, sorting the data from highest to lowest purchase average. */

-- Сreating a view
CREATE VIEW VistaMarketing AS
SELECT company_name, phone, country, AVG(amount)
FROM company
JOIN transaction
ON company.id = transaction.company_id
GROUP BY company_id
ORDER BY AVG(amount) DESC;

-- View the view
SELECT * FROM VistaMarketing;

-- Level 2 Exercise 3
/* Filter the VistaMarketing view to show only companies that have their country of 
residence in "Germany" */

SELECT * FROM VistaMarketing
WHERE country = 'Germany';

-- Level 3 Exercise 1
/* Next week you will have another meeting with the marketing managers. A colleague on your team 
made changes to the database, but he doesn't remember how he made them. He asks you to help him 
leave the commands executed to obtain the following diagram (look in repository) */

-- Deleting the entry with ‘user_id’ = 9999 in the ‘transaction’ table (to correctly create a foreign key)
DELETE FROM transaction
WHERE user_id = '9999';

-- Changing the name of the column ‘email’ to ‘personal_email’ in the table ‘user’
ALTER TABLE user
RENAME COLUMN email TO personal_email;

-- Removing the column ‘website’ from the table ‘company’
ALTER TABLE company
DROP COLUMN website;

-- Adding the column ‘fecha_actual’ of type DATE to the table ‘credit_card’
ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE;

-- Changing the data type for ‘expiring_date’ to VARCHAR(10)
ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(10);

-- Increasing the memory for ‘id’ in ‘credit_card’ from (10) to (20)
ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20);

-- Renaming table 'user' to 'data_user'
RENAME TABLE user TO data_user;

-- Level 3 Exercise 2
/* The company also asks you to create a view called "Technical Report" that contains 
the following information:
- Transaction ID;
- Name of the user;
- Surname of the user;
- IBAN of the credit card used;
- Name of the company of the transaction carried out;
- Be sure to include relevant information from both tables and use aliases to rename columns as needed;
Display the results of the view, sort the results in descending order based on
the transaction ID variable. */












