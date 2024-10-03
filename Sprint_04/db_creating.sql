-- Creating of the database
CREATE DATABASE commerce;
USE commerce;

-- Сreating tables
CREATE TABLE credit_card (
	id VARCHAR(20) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(34),
    pan VARBINARY(128), 
    pin VARBINARY(64),
    cvv VARBINARY(64),
    track1 VARBINARY(128),
    track2 VARBINARY(128),
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
    birth_date DATE,
    country VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    adress VARCHAR(100)
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
    lat DECIMAL(10,10),
    longitude DECIMAL(10,10),
    FOREIGN KEY (card_id) REFERENCES credit_card(id),
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

SHOW VARIABLES LIKE 'secure_file_priv';