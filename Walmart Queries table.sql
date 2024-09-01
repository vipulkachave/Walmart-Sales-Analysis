create table walmart_sales(
	Invoice_ID varchar(20) Not null,
	Branch varchar(5),
	City varchar (20),
	Customer_type varchar (20), 
	Gender varchar (10),
	Product_line varchar (50),
	Unit_price numeric,
	Quantity Int,
	Tax_5_percent numeric,
	Total numeric,
	Date date,
	Time time,
	Payment varchar (20),
	cogs numeric,
	gross_margin_percentage numeric,
	gross_income numeric,
	Rating Decimal(3,1)
)

SET datestyle TO 'ISO, DMY';


COPY walmart_sales
	FROM 'D:\DATA ANALYTICS\SQL\Mentorness internship\Walmart sales task\WalmartData.csv'
	DELIMITER ',' 
	CSV HEADER;

DROP TABLE walmart_sales;

select * from walmart_sales;

-- 1. Retrieve Total_sales made in all branch (e.g., Branch 'A').
SELECT Branch, SUM(Total) AS Total_sales, COUNT(*) AS Number_of_sales
	FROM walmart_sales
	GROUP BY branch;

--2. Find the total sales for each product line.
SELECT product_line, ROUND(SUM(total),2) AS Total_sales
FROM walmart_sales
GROUP BY product_line;

-- 3. List all sales transactions where the payment method was 'Cash'.
SELECT * FROM walmart_sales
WHERE payment = 'Cash';



/*4. Calculate the total gross income generated in each city.*/


SELECT city,round(SUM(gross_income),2) AS Total_Gross_Income
	FROM walmart_sales
	GROUP BY city
	ORDER BY Total_Gross_Income Desc ;

/*5. Find the average rating given by customers in each branch.*/

SELECT branch,ROUND(AVG(rating),1) AS Avg_rating
	FROM walmart_sales
	GROUP BY Branch;


/*6. Determine the total quantity of each product line sold.*/

SELECT Product_line, SUM(Quantity) AS Quantity
	FROM walmart_sales
	GROUP BY Product_line
	ORDER BY Quantity;

/*7. List the top 5 products by unit price. */

SELECT invoice_id,Product_line,Unit_price
	FROM walmart_sales
	ORDER BY Unit_price DESC 
	LIMIT 5;

8. Find sales transactions with a gross_income greater than 30.

SELECT invoice_id,branch,gross_income 
	FROM walmart_sales 
	WHERE gross_income > 30
	ORDER BY gross_income DESC;

/*9. Retrieve sales transactions that occurred on weekends.*/

SELECT date,total AS Total_sales,
	CASE
		WHEN EXTRACT(DOW FROM DATE )=0 THEN 'Sunday'
		WHEN EXTRACT(DOW FROM DATE )=6 THEN 'Saturday'
	END AS Weekends	
FROM walmart_sales
WHERE EXTRACT (DOW FROM Date) IN (0,6)
	ORDER BY Total_sales desc;


-- 10.Calculate the total sales and gross income for each month. 

SELECT 
    TO_CHAR(DATE_TRUNC('month', date),'Month') AS month_name,
    ROUND(SUM(Total),2) AS total_sales,
    ROUND(SUM(gross_income),2) AS gross_income 
FROM walmart_sales
GROUP BY TO_CHAR(DATE_TRUNC('month', date),'Month'),DATE_TRUNC('month', date)
ORDER BY DATE_TRUNC('month', date);

--11. Find the number of sales transactions that occurred after 6 PM.
SELECT COUNT(*) as Sales_Transaction
FROM walmart_sales
WHERE EXTRACT(HOUR FROM Time)>=18 AND EXTRACT(HOUR FROM Time)<24;

--12. List the sales transactions that have a higher total than the average total of all transactions. 
SELECT product_line,ROUND(total,2)
FROM walmart_sales
WHERE total > (SELECT AVG(total) FROM walmart_sales);

--13. Find customers who made more than 5 purchases in a single month.
SELECT invoice_ID as Customers,Quantity
FROM walmart_sales
WHERE Quantity>5;


--14. Calculate the cumulative gross income for each branch by date.

SELECT branch, date,
	SUM(gross_income) OVER (PARTITION BY branch ORDER BY date) AS cumulative_gross_income
FROM (SELECT branch, date,SUM(gross_income) as gross_income
		FROM walmart_sales
		GROUP BY (branch,date)) 
ORDER BY branch,date;

--15. Find the total cogs for each customer_type in each city.

SELECT  customer_type, city, SUM(cogs) AS cost_of_goods_sold
	FROM walmart_sales
	GROUP BY (customer_type,city);
