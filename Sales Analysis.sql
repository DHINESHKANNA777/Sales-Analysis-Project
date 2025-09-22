CREATE TABLE Orders(
	order_id VARCHAR(20) PRIMARY KEY,
	order_date DATE NOT NULL,
	customer_name VARCHAR(50),
	state VARCHAR(20),
	city VARCHAR(20),
	order_month VARCHAR(20)
);

CREATE TABLE Order_Details (
    order_id VARCHAR(20),
    amount NUMERIC(10,2),
    profit NUMERIC(10,2),
    quantity INT,
    category VARCHAR(50),
    subcategory VARCHAR(50),
    profit_margin NUMERIC(10,2),   -- profit ÷ amount
    sale_status VARCHAR(10),       -- "Sale" or "Return"
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
CREATE TABLE Sales_Target ( 
	month VARCHAR(7) NOT NULL, -- Format: YYYY-MM 
	category VARCHAR(50) NOT NULL, 
	target NUMERIC(10,2), 
	PRIMARY KEY (month, category) 
);

COPY Orders(order_id, order_date, customer_name, state,city, order_month)
FROM 'E:\Data sets\Orders_clean.csv'
DELIMITER ','
CSV HEADER;

COPY Order_Details(order_id, amount, profit, quantity, category, subcategory , profit_margin, sale_status)
FROM 'E:\Data sets\Order_details_clean.csv'
DELIMITER ','
CSV HEADER;

COPY Sales_Target(month,category,target)
FROM 'E:\Data sets\Sales_target_clean.csv'
DELIMITER ','
CSV HEADER;

SELECT *
FROM Orders;

SELECT *
FROM Order_Details

SELECT *
FROM Sales_Target


-- 1. Total profit by category

SELECT category, SUM(profit)profit_per_category
FROM Order_Details
GROUP BY category
ORDER BY profit_per_category DESC;

-- 1a. Profit Margin from totals by category

SELECT 
	category, 
	SUM(amount)total_revenue,
	SUM(profit)profit_per_category,
	ROUND((SUM(profit)/SUM(amount))*100,2)|| '%' profit_margin_by_category
FROM Order_Details
GROUP BY category
ORDER BY profit_margin_by_category DESC;


-- 2. Total sales/revenue per category per month

SELECT 
    O.order_month,
    OD.category,
    SUM(OD.amount) AS total_sales
FROM Order_Details OD JOIN Orders O
ON OD.order_id = O.order_id
GROUP BY O.order_month, OD.category
ORDER BY O.order_month, OD.category;

-- 2a. Which categories met/exceeded/not met in sales targets?

SELECT 
ST.month,
ST.category,
ST.target,
COALESCE(SUM(OD.amount),0)AS total_sales,
	CASE 
	WHEN COALESCE(SUM(OD.amount),0) = ST.target
	THEN 'Target met'
	WHEN COALESCE(SUM(OD.amount),0) > ST.target
	THEN 'Target met & exceeded'
	ELSE 'Target not met'
	END AS Target_status
FROM Sales_Target ST LEFT JOIN Orders O
ON ST.month = O.order_month LEFT JOIN Order_Details OD
ON O.order_id = OD.order_id
GROUP BY ST.month,ST.category,ST.target   
ORDER BY ST.month,ST.category;


-- 3. which top 3 months has highest total sales across all categories:

SELECT 
O.order_month,
SUM(OD.amount)total_sales
FROM Orders O JOIN Order_Details OD
ON O.order_id = OD.order_id
GROUP BY O.order_month
ORDER BY total_sales DESC
LIMIT 3;


-- 4. Total sales per month

SELECT O.order_month, SUM(OD.amount)Revenue_per_month
FROM Order_Details OD JOIN Orders O
ON OD.order_id = O.order_id
GROUP BY O.order_month
ORDER BY O.order_month;

-- 4a. Which month has highest sales?

SELECT O.order_month, SUM(OD.amount)Revenue_per_month
FROM Order_Details OD JOIN Orders O
ON OD.order_id = O.order_id
GROUP BY O.order_month
ORDER BY O.order_month DESC
LIMIT 1;

-- 4b. What is the month-over-month sales growth?

WITH month_revenue AS(
	SELECT O.order_month,
	SUM(OD.amount)monthly_revenue
	FROM Order_Details OD JOIN Orders O
	ON OD.order_id = O.order_id
	GROUP BY O.order_month
)
SELECT 
order_month,
monthly_revenue,
LAG(monthly_revenue) OVER (ORDER BY order_month)AS prev_month_sales,
ROUND(
(monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY order_month))*100
/NULLIF(LAG(monthly_revenue) OVER (ORDER BY order_month),0),2
)AS sales_growth_percent
FROM month_revenue
ORDER BY order_month;


-- 5. Top 5 cities by total revenue

SELECT 
	O.city AS Top_cities,
	SUM(OD.amount) AS Total_revenue
FROM Orders O JOIN Order_Details OD
	ON O.order_id = OD.order_id
GROUP BY O.city
ORDER BY Total_revenue DESC
LIMIT 5;



-- 6a. Top 5 customers by revenue:

SELECT 
	O.customer_name AS Top_5_customers,
	SUM(OD.amount) AS Revenue
FROM Orders O JOIN Order_Details OD
	ON O.order_id = OD.order_id
GROUP BY O.customer_name
ORDER BY Revenue DESC
LIMIT 5;

-- 6b. Top 5 customers by returns

SELECT
	O.customer_name,
	COUNT(*) FILTER(WHERE sale_status = 'Return')AS Return_orders
FROM Orders O JOIN Order_Details OD
	ON O.order_id = OD.order_id
GROUP BY O.customer_name
HAVING COUNT(*) FILTER(WHERE sale_status = 'Return') > 0
ORDER BY Return_orders DESC
LIMIT 5;


-- Export Orders table
COPY Orders TO 'E:\TableauExports\Orders.csv' DELIMITER ',' CSV HEADER;

-- Export Order_Details table
COPY Order_Details TO 'E:\TableauExports\Order_Details.csv' DELIMITER ',' CSV HEADER;

-- Export Sales_Target table
COPY Sales_Target TO 'E:\TableauExports\Sales_Target.csv' DELIMITER ',' CSV HEADER;



-- Exporting pre-aggregated queries to tableau

-- 1b. Profit Margin from totals by category

COPY(SELECT 
	category, 
	SUM(amount)total_revenue,
	SUM(profit)profit_per_category,
	ROUND((SUM(profit)/SUM(amount))*100,2)|| '%' profit_margin_by_category
FROM Order_Details
GROUP BY category
ORDER BY profit_margin_by_category DESC
)TO 'E:\TableauExports\ProfitMarginByCategory.csv'
DELIMITER ','
CSV HEADER;


-- 2b. Which categories met/exceeded/not met in sales targets?

COPY(SELECT 
	ST.month,
	ST.category,
	ST.target,
	COALESCE(SUM(OD.amount),0)AS total_sales,
		CASE 
			WHEN COALESCE(SUM(OD.amount),0) = ST.target
			THEN 'Target met'
			WHEN COALESCE(SUM(OD.amount),0) > ST.target
			THEN 'Target met & exceeded'
		ELSE 'Target not met'
		END AS Target_status
FROM Sales_Target ST LEFT JOIN Orders O
	ON ST.month = O.order_month LEFT JOIN Order_Details OD
	ON O.order_id = OD.order_id
GROUP BY ST.month,ST.category,ST.target   
ORDER BY ST.month,ST.category
)TO 'E:\TableauExports\SalesVsTarget.csv'
DELIMITER ','
CSV HEADER;


-- 4a. Total sales per month

COPY(SELECT 
	O.order_month, 
	SUM(OD.amount)Revenue_per_month
FROM Order_Details OD JOIN Orders O
	ON OD.order_id = O.order_id
GROUP BY O.order_month
ORDER BY O.order_month
)TO 'E:\TableauExports\TotalsalesPerMonth.csv'
DELIMITER ','
CSV HEADER;


-- 4b. What is the month-over-month sales growth?

COPY(WITH month_revenue AS(
	SELECT O.order_month,
		SUM(OD.amount)monthly_revenue
	FROM Order_Details OD JOIN Orders O
		ON OD.order_id = O.order_id
	GROUP BY O.order_month
)
SELECT 
	order_month,
	monthly_revenue,
	LAG(monthly_revenue) OVER (ORDER BY order_month)AS prev_month_sales,
	ROUND(
	(monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY order_month))*100
	/NULLIF(LAG(monthly_revenue) OVER (ORDER BY order_month),0),2
	)AS sales_growth_percent
FROM month_revenue
ORDER BY order_month
)TO 'E:\TableauExports\MOMSalesGrowth.csv'
DELIMITER ','
CSV HEADER;


-- 5. Top 5 cities by total revenue

COPY(SELECT 
	O.city AS Top_cities,
	SUM(OD.amount) AS Total_revenue
FROM Orders O JOIN Order_Details OD
	ON O.order_id = OD.order_id
GROUP BY O.city
ORDER BY Total_revenue DESC
LIMIT 5
)TO 'E:\TableauExports\TopCities.csv'
DELIMITER ','
CSV HEADER;


-- 6a. Top 5 customers by revenue:

COPY(SELECT 
	O.customer_name AS Top_5_customers,
	SUM(OD.amount) AS Revenue
FROM Orders O JOIN Order_Details OD
	ON O.order_id = OD.order_id
GROUP BY O.customer_name
ORDER BY Revenue DESC
LIMIT 5
)TO 'E:\TableauExports\TopCustomers.csv'
DELIMITER ','
CSV HEADER;



