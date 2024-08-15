-- Create database and use it
CREATE DATABASE IF NOT EXISTS shop_db;
USE shop_db;

-- Create tables
CREATE TABLE IF NOT EXISTS customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(255),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    stock_quantity INT
);

CREATE TABLE IF NOT EXISTS sales (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    customer_id INT,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS transaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_date DATE,
    amount DECIMAL(10, 2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Customer', 'Admin') NOT NULL,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- Insert sample data into `customer` table
INSERT INTO customer (username, password, email) VALUES 
('Alice Johnson', SHA2('password1', 256), 'alice.johnson@example.com'),
('Bob Smith', SHA2('password2', 256), 'bob.smith@example.com'),
('Carol Davis', SHA2('password3', 256), 'carol.davis@example.com'),
('David Lee', SHA2('password4', 256), 'david.lee@example.com'),
('Eva Adams', SHA2('password5', 256), 'eva.adams@example.com');

-- Insert sample data into `users` table
INSERT INTO users (email, password, role) VALUES 
('admin@example.com', SHA2('admin123', 256), 'Admin'),
('alice.johnson@example.com', SHA2('password1', 256), 'Customer'),
('bob.smith@example.com', SHA2('password2', 256), 'Customer'),
('carol.davis@example.com', SHA2('password3', 256), 'Customer'),
('david.lee@example.com', SHA2('password4', 256), 'Customer'),
('eva.adams@example.com', SHA2('password5', 256), 'Customer');

-- Link users to customers
UPDATE users SET customer_id = (SELECT customer_id FROM customer WHERE email = 'alice.johnson@example.com') WHERE email = 'alice.johnson@example.com';
UPDATE users SET customer_id = (SELECT customer_id FROM customer WHERE email = 'bob.smith@example.com') WHERE email = 'bob.smith@example.com';
UPDATE users SET customer_id = (SELECT customer_id FROM customer WHERE email = 'carol.davis@example.com') WHERE email = 'carol.davis@example.com';
UPDATE users SET customer_id = (SELECT customer_id FROM customer WHERE email = 'david.lee@example.com') WHERE email = 'david.lee@example.com';
UPDATE users SET customer_id = (SELECT customer_id FROM customer WHERE email = 'eva.adams@example.com') WHERE email = 'eva.adams@example.com';

-- Insert sample data into `product` table
INSERT INTO product (product_name, price, stock_quantity) VALUES 
('Smartphone X', 699.99, 50),
('Laptop Pro', 1299.99, 30),
('Headphones Plus', 199.99, 100),
('Smartwatch 3', 299.99, 75),
('Tablet Ultra', 399.99, 60);

-- Insert dummy records into `sales` table in date order from January 2024 to August 2024
INSERT INTO sales (order_date, product_id, quantity, price, customer_id) VALUES 
-- January 2024
('2024-01-05', 1, 1, 699.99, 1),
('2024-01-15', 2, 1, 1299.99, 2),
('2024-01-20', 3, 1, 399.98, 3),
('2024-01-25', 4, 1, 299.99, 4),
('2024-01-30', 5, 1, 399.99, 5),

-- February 2024
('2024-02-02', 1, 1, 1399.98, 1),
('2024-02-12', 2, 1, 1299.99, 2),
('2024-02-18', 3, 1, 199.99, 3),
('2024-02-22', 4, 1, 599.98, 4),
('2024-02-28', 5, 1, 1199.97, 5),

-- March 2024
('2024-03-03', 1, 1, 799.99, 1),
('2024-03-09', 2, 1, 1499.99, 2),
('2024-03-14', 3, 1, 499.98, 3),
('2024-03-21', 4, 1, 349.99, 4),
('2024-03-29', 5, 1, 409.99, 5),

-- April 2024
('2024-04-01', 1, 1, 1399.98, 1),
('2024-04-10', 2, 1, 1299.99, 2),
('2024-04-15', 3, 1, 299.98, 3),
('2024-04-20', 4, 1, 249.99, 4),
('2024-04-27', 5, 1, 399.99, 5),

-- May 2024
('2024-05-05', 1, 1, 1199.97, 1),
('2024-05-11', 2, 1, 1299.99, 2),
('2024-05-16', 3, 1, 199.99, 3),
('2024-05-23', 4, 1, 599.98, 4),
('2024-05-30', 5, 1, 1199.97, 5),

-- June 2024
('2024-06-02', 1, 1, 799.99, 1),
('2024-06-08', 2, 1, 1499.99, 2),
('2024-06-13', 3, 1, 399.98, 3),
('2024-06-19', 4, 1, 349.99, 4),
('2024-06-25', 5, 1, 409.99, 5),

-- July 2024
('2024-07-04', 1, 1, 1399.98, 1),
('2024-07-12', 2, 1, 1299.99, 2),
('2024-07-18', 3, 1, 199.99, 3),
('2024-07-22', 4, 1, 599.98, 4),
('2024-07-30', 5, 1, 1199.97, 5),

-- August 2024
('2024-08-01', 1, 1, 699.99, 1),
('2024-08-02', 2, 1, 1299.99, 2),
('2024-08-03', 3, 2, 399.98, 3),
('2024-08-04', 4, 1, 299.99, 4),
('2024-08-05', 5, 1, 399.99, 5);

-- Insert dummy records into `transaction` table in date order from January 2024 to August 2024
INSERT INTO transaction (transaction_date, amount, customer_id) VALUES 
-- January 2024
('2024-01-05', 699.99, 1),
('2024-01-15', 1299.99, 2),
('2024-01-20', 399.98, 3),
('2024-01-25', 299.99, 4),
('2024-01-30', 399.99, 5),

-- February 2024
('2024-02-02', 1399.98, 1),
('2024-02-12', 1299.99, 2),
('2024-02-18', 199.99, 3),
('2024-02-22', 599.98, 4),
('2024-02-28', 1199.97, 5),

-- March 2024
('2024-03-03', 799.99, 1),
('2024-03-09', 1499.99, 2),
('2024-03-14', 499.98, 3),
('2024-03-21', 349.99, 4),
('2024-03-29', 409.99, 5),

-- April 2024
('2024-04-01', 1399.98, 1),
('2024-04-10', 1299.99, 2),
('2024-04-15', 299.98, 3),
('2024-04-20', 249.99, 4),
('2024-04-27', 399.99, 5),

-- May 2024
('2024-05-05', 1199.97, 1),
('2024-05-11', 1299.99, 2),
('2024-05-16', 199.99, 3),
('2024-05-23', 599.98, 4),
('2024-05-30', 1199.97, 5),

-- June 2024
('2024-06-02', 799.99, 1),
('2024-06-08', 1499.99, 2),
('2024-06-13', 399.98, 3),
('2024-06-19', 349.99, 4),
('2024-06-25', 409.99, 5),

-- July 2024
('2024-07-04', 1399.98, 1),
('2024-07-12', 1299.99, 2),
('2024-07-18', 199.99, 3),
('2024-07-22', 599.98, 4),
('2024-07-30', 1199.97, 5),

-- August 2024
('2024-08-01', 699.99, 1),
('2024-08-02', 1299.99, 2),
('2024-08-03', 399.98, 3),
('2024-08-04', 299.99, 4),
('2024-08-05', 399.99, 5);

-- Select all records from `transaction` and `sales` tables
SELECT * FROM transaction;
SELECT * FROM sales;

-- Query to get total sales for the current year by month
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month, 
    SUM(quantity * price) AS total_sales
FROM 
    sales
WHERE 
    YEAR(order_date) = YEAR(CURDATE())
GROUP BY 
    DATE_FORMAT(order_date, '%Y-%m')
ORDER BY 
    month;
    
select * from users;