## Sales Analysis Project (Excel | SQL | Tableau) [Dashboard link](https://public.tableau.com/views/SalesAnalysisDashboard_17585307887200/Salesoverview?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Project Overview:
This project analyzes sales performance data to identify trends, growth opportunities, and key contributors to business revenue.
The analysis was carried out using Excel for cleaning, SQL for practice in querying and aggregation, and Tableau for building interactive dashboards.
The aim is to provide clear, data-driven insights that can support better decision-making.

##Problem Statement
A retail company wanted to understand its sales performance across different categories, cities, and customers. The management team asked:
- Are our sales growing month-over-month?
- Which product categories are most profitable?
- Are we meeting our sales targets across months and categories?
- Which cities and customers contribute the most revenue?
- Where are we losing money due to returns or low margins?

##Approach
1. Data Understanding
   - Dataset sourced from Kaggle (Orders, Order_Details, Sales_Target).
   - Explored attributes: order details, sales amount, profit, categories, returns, sales targets.
2. Business Questions → SQL Queries
   Translated the above business problems into SQL queries to create pre-aggregated datasets:
   - Monthly sales and growth trends
   - Profit and profit margin by category
   - Sales vs targets (by category/month)
   - Top 5 cities by revenue
   - Top 5 customers by revenue
3. Visualization in Tableau
   - Created interactive dashboards for decision-makers.
   - Split into clear sections for performance trends, profitability, targets, and customer/city insights

   
## Dataset:

The project uses 6 prepared CSV files, processed from SQL queries

TotalSalesPerMonth.csv → Monthly sales & revenue

MOMSalesGrowth.csv → Month-on-Month sales growth

ProfitMarginByCategory.csv → Profit contribution by product categories

SalesVsTarget.csv → Actual sales vs target sales

TopCities.csv → Revenue contribution by cities

TopCustomers.csv → Revenue contribution by top customers

## SQL Queries

All SQL queries used to clean, transform, and generate business-ready datasets are stored in:

[SQL_queries file](https://github.com/DHINESHKANNA777/Sales-Analysis-Project/blob/main/Sales%20Analysis.sql)

This file includes queries for:

- Calculating **Monthly Sales**
- Computing **Month-over-Month Growth**
- Analyzing **Profit by Category**
- Comparing **Sales vs Target**
- Identifying **Top Cities**
- Listing **Top Customers**



## Dashboards Created:

1. Sales overview

Monthly Sales Trend – Visualizing overall sales performance over time

MoM Growth – Tracking growth rate between months

Sales vs Target – Comparing actual performance with targets

2. Insights& Breakdown

Profit by Category – Distribution of profit across product categories

Top Cities – Highlighting city-level revenue contributions

Top Customers – Showing revenue from top-performing customers


## Key Insights

1. Monthly Sales Trend & MoM Growth

Sales generally showed steady improvement, with some months underperforming.

Strongest growth observed during peak months from oct to mar, suggesting seasonal influence.

Business Note: Seasonal promotions can boost peak periods, while weaker months need additional campaigns.

2. Profit by Category

Clothing (46.6%) and Electronics (43.8%) contribute the majority of profit.

Furniture (9.6%) is the weakest segment.

Business Note: Focus on Clothing & Electronics. Reconsider pricing/marketing strategy for Furniture.

3. Sales vs Target

Several months met or exceeded targets, while a few fell behind.

Business Note: Targets should be more aligned with realistic performance expectations.

4. Top Cities

Indore and Mumbai generate the highest revenue.

Delhi and Bhopal have lower contributions.

Business Note: Increase efforts in high-performing cities, while building strategies to grow weaker ones.

5. Top Customers

Top 5 customers contribute significantly, with Yaanvi & Pooja being the most valuable.

Business Note: Introduce loyalty programs for high-value customers and expand the customer base to reduce dependency.


## Recommendations:

* Prioritize Clothing & Electronics categories.

* Strengthen marketing in Mumbai & Indore, and invest in underperforming regions.

* Launch customer loyalty/reward programs for top customers.

* Reassess Furniture sales strategy to improve profitability.

* Closely monitor month-on-month growth for better forecasting.


## Dashboard Preview:

[Sales overview](https://github.com/DHINESHKANNA777/Sales-Analysis-Project/blob/main/Sales%20Overview.png)
[Insights & Breakdown](https://github.com/DHINESHKANNA777/Sales-Analysis-Project/blob/main/Insights%26breakdown.png)


## Tools Used:

Excel → Data cleaning & preparation

SQL → Clean, transform, and generate business-ready datasets

Tableau Public → Dashboard creation & visualization


This project demonstrates the complete analysis process, from raw data to business insights and visualization, highlighting practical skills in Excel, SQL, and Tableau.
