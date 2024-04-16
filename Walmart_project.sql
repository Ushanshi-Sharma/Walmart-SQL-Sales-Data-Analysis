USE projects;

-- -------------------- DATA CLEANING ----------------------------------
CREATE TABLE IF NOT EXISTS walmart (
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(35) NOT NULL,
customer_type VARCHAR(35) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(35) NOT NULL,
cogs DECIMAL (10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL (12,4) NOT NULL,
rating FLOAT (2,1) NOT NULL) ; 




-- --------------------------------------------------------------------------------
-- --------------------- FEATURE ENGEENERING ---------------------------------------


-- ---------------------  time of day  ----------------------------------------------



SELECT time,
CASE 
	WHEN time between "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN time between "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening" 
    END as time_of_day
FROM walmart;

ALTER TABLE walmart
ADD COLUMN time_of_day VARCHAR(20);

SELECT * from walmart;

UPDATE walmart
SET time_of_day = (case 
					when time between "00:00:00" and "12:00:00" then "Morning"
					when time between "12:01:00" and "16:00:00" then "Afternoon"
					else "Evening" 
					END);

SET sql_safe_updates = 0;




-- -----------------------    day_name -----------------------------------------

SELECT date,
dayname(date) as Day
FROM walmart;

ALTER TABLE walmart
ADD COLUMN day VARCHAR(20);

UPDATE walmart
SET day = DAYNAME(date);

SELECT * FROM walmart;




-- -----------------------    month_name -----------------------------------------

SELECT date,
MONTHNAME(date)
FROM walmart;

ALTER TABLE walmart
ADD COLUMN month_name VARCHAR(20);

UPDATE walmart
SET month_name = MONTHNAME(date);

SELECT * FROM walmart;




-- --------------------------------------------------------------------------------------
-- --------------------- Exploratory Data Analysis ---------------------------------------



-- -------------------------- Generic Question ------------------------------------------


-- 1) How many unique cities does the data have?
SELECT DISTINCT(city)
FROM walmart;

-- 2) In which city is each branch?
SELECT city,branch
FROM walmart
group by city,branch;




-- -------------------------- Product Based Questions ------------------------------------------

-- How many unique product lines does the data have?
SELECT  DISTINCT(product_line)
FROM walmart;

-- What is the most common payment method?
SELECT payment_method,COUNT(payment_method) as payment_menthod
FROM walmart
GROUP BY payment_method
ORDER BY COUNT(payment_method) DESC
LIMIT 1;


-- What is the total revenue by month?
SELECT month_name as Month, sum(total) as Total_revenue
FROM walmart
GROUP BY month_name;

-- What product line had the largest revenue?
SELECT product_line , sum(total)
FROM walmart
GROUP BY product_line
ORDER BY sum(total) DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT total as Total ,
CASE WHEN total >= (SELECT avg(total) from walmart) THEN "Good"
WHEN total < (SELECT avg(total) from walmart) THEN "Bad"
END  as Sales_rating
FROM walmart;

-- Which branch sold more products than average product sold?
SELECT branch, sum(quantity) as Total_quantity_sold
FROM walmart
GROUP BY branch
HAVING sum(quantity) > ( SELECT AVG(quantity) FROM walmart);

-- What is the most common product line by gender?
SELECT gender,product_line , count(gender) as total_count_by_gender
FROM walmart 
GROUP BY gender,product_line
ORDER BY count(gender) DESC;

-- What is the average rating of each product line?
SELECT product_line ,ROUND(AVG(rating),2) AS avg_rating
FROM walmart
GROUP BY product_line
ORDER BY avg_rating DESC;






-- -------------------------- Sales Based Questions ------------------------------------------



-- Number of sales made in each time of the day per weekday
SELECT day, time_of_day, SUM(total) as total_sales
FROM walmart
GROUP BY day,time_of_day
ORDER BY day;

-- Which of the customer types brings the most revenue?
SELECT customer_type , SUM(total) as total_sales
FROM walmart
GROUP BY customer_type
ORDER BY total_sales DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city,AVG(VAT)
FROM walmart
GROUP BY city
ORDER BY AVG(VAT) DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type , AVG(VAT)
FROM walmart
GROUP BY customer_type
ORDER BY AVG(VAT) DESC;






-- -------------------------- Customers Based Questions ------------------------------------------



SELECT * FROM walmart;
-- How many unique customer types does the data have?
SELECT DISTINCT(customer_type)
FROM walmart;

-- How many unique payment methods does the data have?
SELECT DISTINCT(payment_method)
FROM walmart;

-- What is the gender of most of the customers?
SELECT gender , count(gender)
FROM walmart
GROUP BY gender;

-- What is the gender distribution per branch?
SELECT gender , branch , count(gender) as count_gender
FROM walmart
GROUP BY gender , branch
ORDER BY branch;

-- Which time of the day do customers give most ratings?
SELECT time_of_day , sum(rating) as ratings_given
FROM walmart
GROUP BY time_of_day
ORDER BY ratings_given;

-- Which day for the week has the best avg ratings?
SELECT day , avg(rating)
FROM walmart
GROUP BY day
ORDER BY avg(rating)DESC;

-- Which day of the week has the best average ratings per branch?
SELECT day, count(day) as total_sales
FROM walmart
WHERE branch = "C"
GROUP BY day
ORDER BY total_sales DESC;



-- ------------------------------------- END ---------------------------------------
-- ------------------------------------THANK YOU -----------------------------------






























