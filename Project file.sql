Create database waldb;
use waldb;

select*from walmart_sales;

-- EXPLORATRAY DATA ANALYSIS
-- First 10 records
SELECT* FROM walmart_sales limit 10;

-- Count total records
SELECT count(*) FROM walmart_sales;

/* Count payment methods and number of transactions 
by payment method */
SELECT 
	Payment_method,count(*) as no_transaction
FROM walmart_sales
GROUP BY Payment_method;

-- Count distinct branches
SELECT
	Count(distinct(Branch)) 
FROM Walmart_sales;

-- Minimum quantity sold
SELECT MIN(Quantity) as min_sold_qty FROM walmart_sales;

-- Range of min and max unit price
SELECT
	min(unit_price) as Min_price, max(unit_price) as max_price
FROM walmart_sales;

-- Total Sales for Each Branch
SELECT
	Branch,SUM(Total_sales) AS Total_sales
FROM walmart_sales
GROUP BY Branch
ORDER BY Total_Sales DESC;



-- Business Problem
/* Q1: Find different payment methods, number of transactions,
and quantity sold by payment method */
SELECT
	Payment_method,Count(*) as No_transaction,
    SUM(Quantity) as No_sold_qty
FROM walmart_sales
GROUP BY Payment_method;

-- Q2.Determine the most common payment method used.
SELECT
	Payment_method,count(*) as most_used
FROM walmart_sales
GROUP BY Payment_method
ORDER BY most_used DESC LIMIT 1;

-- Q3.Retrive the month with the highest sales
SELECT 
	Month,SUM(Total_sales) as Highest_sales
FROM walmart_sales
GROUP BY Month
ORDER BY Highest_Sales DESC LIMIT 1;

-- Q4.Retrieve the total profit generated per city.
SELECT 
	City,SUM(Profit) as Total_profit
FROM walmart_sales
GROUP BY City
ORDER BY Total_profit;

-- Q5.Identify the product category with the highest demand.
SELECT
	Category,SUM(Quantity) as high_demanded
FROM walmart_sales
GROUP BY Category
ORDER BY high_demanded DESC LIMIT 1;

-- Q6.Find the total sales for each day of the week.
SELECT 
	Day, SUM(Total_sales) AS Total_Sales 
FROM Walmart_sales 
GROUP BY Day 
ORDER BY Day;

/* Q7: Identify the highest-rated category in each branch
Display the branch, category, and avg rating */
SELECT Branch, Category, Avg_Rating,Rankk
FROM (
    SELECT 
        Branch,
        Category,
        AVG(Rating) AS Avg_Rating,
        RANK() OVER(PARTITION BY Branch ORDER BY AVG(Rating) DESC) AS Rankk
    FROM Walmart_sales
    GROUP BY Branch, Category
) AS RankedCategories
WHERE Rankk = 1;

/* Q8: Identify the busiest day for each branch based 
on the number of transactions */

SELECT branch, day_name, no_transactions,rankk
FROM (
    SELECT 
        branch,
        DAYNAME(date) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rankk
    FROM walmart_sales
    GROUP BY branch, day_name
) AS ranked
WHERE rankk = 1;

-- Q9: Calculate the total quantity of items sold per payment method
SELECT 
	Payment_method,SUM(Quantity) as qty_sold
FROM walmart_sales
GROUP BY Payment_method;

-- Q10: Determine the average, minimum, and maximum rating of categories for each city

SELECT 
	City,Category,AVG(Rating),MIN(Rating),MAX(Rating)
FROM Walmart_sales 
GROUP BY City,Category;
	
-- Q11.Total profit for each category.
SELECT
	Category,SUM(Profit) as Total_profit
FROM walmart_sales
GROUP BY Category
ORDER BY Total_profit DESC;

-- Q12. Determine the most common payment method for each branch

with CTE as 
(
	SELECT Branch,Payment_method,Count(*) as total_trans,
    RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rankk
  FROM walmart_sales
  GROUP BY Branch,Payment_method
)
SELECT * FROM CTE
WHERE rankk=1;

/*  Q13: Categorize sales into Morning, Afternoon, 
and Evening shifts and  Find out each of the shift 
and number of invoices */

SELECT 
	Branch,
    CASE
		WHEN HOUR(TIME(time))<12 THEN "Morning"
        WHEN HOUR(TIME(time)) BETWEEN 12 and 17 THEN "Afternoon"
        ELSE "Evening"
	END AS shift,
    COUNT(*) AS Num_invoices
  FROM Walmart_sales 
  GROUP BY Branch,shift
  ORDER BY Branch,Num_invoices DESC;

-- Q.14.Determine the total profit generated on weekends vs. weekdays.
SELECT
	CASE 
		WHEN DAYOFWEEK(DATE) IN (1,7) THEN 'WEEKEND'
        ELSE 'WEEKDAY'
	END AS Day_type,
	SUM(Profit) as Total_profit
FROM Walmart_sales
GROUP BY Day_type;

-- Q15.Which day of the week generates the highest total sales?
SELECT DAYNAME(Date) AS Weekday, SUM(Total_sales) AS Total_sales
FROM Walmart_sales
GROUP BY Weekday
ORDER BY Total_sales DESC
LIMIT 1;





