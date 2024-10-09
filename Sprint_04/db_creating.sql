-- Creating of the database
CREATE DATABASE commerce;
USE commerce;

-- Сreating tables
CREATE TABLE credit_cards (
	id VARCHAR(20) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(34),
    pan VARCHAR(20), 
    pin VARCHAR(4),
    cvv VARCHAR(3),
    track1 VARCHAR(50),
    track2 VARCHAR(50),
    expiring_date DATE
);

CREATE TABLE companies (
	company_id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    country VARCHAR(50),
    website VARCHAR(100)
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price VARCHAR(10),
	colour VARCHAR(10),
    weight DECIMAL(2,1),
    warehouse_id VARCHAR(10)
);

CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(20),
    surname VARCHAR(20),
    phone VARCHAR(15),
    email VARCHAR(100),
    birth_date VARCHAR(15),
    country VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    address VARCHAR(100)
);

CREATE TABLE transactions (
    id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(20),
    business_id VARCHAR(15),
    timestamp TIMESTAMP,
    amount DECIMAL(10,2),
    declined TINYINT,
    product_ids VARCHAR(200),
    user_id INT,
    lat DECIMAL(15,10),
    longitude DECIMAL(15,10),
    FOREIGN KEY (card_id) REFERENCES credit_cards(id),
    FOREIGN KEY (business_id) REFERENCES companies(company_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE transaction_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(255),
    product_id INT,
    quantity INT,
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Loading data from CSV
LOAD DATA INFILE '/tmp/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

LOAD DATA INFILE '/tmp/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(@id, @user_id, @iban, @pan, @pin, @cvv, @track1, @track2, @expiring_date)
SET 
	id = TRIM(@id), 
    user_id = TRIM(@user_id),
    iban = TRIM(@iban),
    pan = TRIM(@pan),
    pin = TRIM(@pin),
    cvv = TRIM(@cvv),
    track1 = TRIM(@track1),
    track2 = TRIM(@track2),
    expiring_date = STR_TO_DATE(@expiring_date, '%m/%d/%y');

LOAD DATA INFILE '/tmp/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

LOAD DATA INFILE '/tmp/users_usa.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
	(@id, @name, @surname, @phone, @email, @birth_date, @country, @city, @postal_code, @address)
SET
    id = @id,
    name = @name,
    surname = @surname,
    phone = @phone,
    email = @email,
    birth_date = STR_TO_DATE(@birth_date, '%b %d, %Y'),
    country = @country,
    city = @city,
    postal_code = @postal_code,
    address = @address;
    
LOAD DATA INFILE '/tmp/users_ca.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
	(@id, @name, @surname, @phone, @email, @birth_date, @country, @city, @postal_code, @address)
SET
    id = @id,
    name = @name,
    surname = @surname,
    phone = @phone,
    email = @email,
    birth_date = STR_TO_DATE(@birth_date, '%b %d, %Y'),
    country = @country,
    city = @city,
    postal_code = @postal_code,
    address = @address;
    
LOAD DATA INFILE '/tmp/users_uk.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
	(@id, @name, @surname, @phone, @email, @birth_date, @country, @city, @postal_code, @address)
SET
    id = @id,
    name = @name,
    surname = @surname,
    phone = @phone,
    email = @email,
    birth_date = STR_TO_DATE(@birth_date, '%b %d, %Y'),
    country = @country,
    city = @city,
    postal_code = @postal_code,
    address = @address;

LOAD DATA INFILE '/tmp/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';' 
IGNORE 1 LINES
(@id, @card_id,	@business_id, @timestamp, @amount, @declined, @product_ids, @user_id, @lat, @longitude)
SET
	id = TRIM(@id),
    card_id = TRIM(@card_id),
    business_id = TRIM(@business_id),
    timestamp = TRIM(@timestamp),
    amount = TRIM(@amount),
    declined = TRIM(@declined),
    product_ids = TRIM(@product_ids),
    user_id = TRIM(@user_id),
    lat = TRIM(@lat),
    longitude = TRIM(@longitude);
