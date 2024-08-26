# Portfolio SQL
## Background
In the rapidly growing e-commerce industry, analyzing transaction data is crucial for understanding customer behavior, optimizing product offerings, and improving overall business operations. This project involves working with a comprehensive dataset from MyStore, an e-commerce platform where users can act as both buyers and sellers. The dataset consists of four main tables: '**users**', '**products**', '**orders**', and '**order_details**'. Each table contains key information that provides insights into user behavior, product performance, and transaction trends.

The following SQL queries were developed to perform various analytical tasks, including counting records, identifying top buyers, detecting inactive users, and analyzing product sales. These queries serve as foundational tools for data-driven decision-making in the e-commerce domain.

## Data Source
_MyStore dataset is_ [here](https://github.com/teguhmprayoga/portoSQL/tree/main/data)

## Objectives
1. Data Exploration and Cleaning:
   - Identify the structure and content of the products and orders tables.
   - Detect and quantify NULL or empty values within these tables to ensure data quality.
   - Determine the number of distinct product categories available in the store.
2. User Behavior Analysis:
   - Calculate the total number of users, those who have engaged in transactions as buyers, sellers, or both, and identify users who have never transacted.
   - Identify the top 5 buyers by total spending and the top 5 frequent buyers who never used discounts.
3. Transactional Insights:
   - Analyze user transaction patterns, focusing on buyers with consistent monthly transactions and high average spending.
   - Extract key transactional metrics such as monthly summaries, largest transactions, and top product categories based on sales volume.

## Task Explanation
Please find [**Queries here**](https://github.com/teguhmprayoga/portoSQL/blob/main/CodeSQL.sql)
1. Number of Columns in the products Table
   - This query retrieves the list of columns present in the products table to understand its schema and structure.
2. Number of Rows in the products Table
   - This query calculates the total number of rows in the products table, providing insight into the dataset’s size.
3. Count of Unique Product Categories
   - This query determines the number of distinct product categories available, which helps in understanding the diversity of the product range.
4. Count of Variables with NULL/Empty Values in products Table
   - This query identifies the number of variables in the products table with NULL or empty values, highlighting potential data quality issues.
5. Number of Columns in the orders Table
   - This query retrieves the columns in the orders table to understand its schema.
6. Number of Rows in the orders Table
   - This query provides the total number of rows in the orders table, offering insights into the volume of transaction data.
7. Count of Variables with NULL/Empty Values in orders Table
   - This query identifies the number of variables in the orders table with NULL or empty values, indicating areas for data cleaning.
8. Count of Numeric Columns in the products Table
   - This query counts the numeric columns in the products table, which are crucial for quantitative analysis.
9. Total Number of Users
   - This query calculates the total number of unique users, providing an overview of the user base.
10. Number of Users Who Have Purchased as Buyers
    - This query identifies how many users have made purchases, offering insights into the buying activity.
11. Number of Users Who Have Sold as Sellers
    - This query reveals the number of users who have sold products, reflecting the selling activity.
12. Number of Users Who Have Both Purchased and Sold
    - This query identifies users who have both bought and sold products, highlighting versatile users.
13. Number of Users Who Have Never Transacted
    - This query counts users who have never engaged in transactions, identifying inactive users.
14. Top 5 Buyers by Total Spending
    - This query lists the top 5 buyers based on total spending, showing the highest-value customers.
15. Top Buyers with No Discount Usage
    - This query identifies top buyers who never used discounts and had the highest number of transactions.
16. Users with Transactions Every Month in 2020 and Average Transaction Amount Over 1 Million
    - This query identifies users who made purchases every month in 2020 with an average transaction amount exceeding 1 million.
17. Email Domains of Sellers
    - This query extracts the unique email domains of sellers, useful for understanding the distribution of seller organizations.
18. Top 5 Products Purchased in December 2019 by Quantity
    - This query identifies the top 5 products by quantity purchased in December 2019.
19. Top 10 Buyers with Highest Average Transaction Value in January 2020
    - This query lists the top 10 buyers with the highest average transaction value who made at least 2 transactions in January 2020.
20. Transactions with Minimum Value of 20,000,000 in December 2019
    - This query retrieves transactions from December 2019 where the transaction value is at least 20,000,000. It joins the orders and users tables to include buyer names, and sorts results alphabetically by buyer name.
21. Top 5 Product Categories by Quantity in 2020
    - This query identifies the top 5 product categories by total quantity sold in 2020, only including transactions that have been delivered. It also calculates total price and orders by quantity.
22. Buyers with More Than 5 Transactions, Each Over 2,000,000
    - This query finds buyers who have made more than 5 transactions, each with a value greater than 2,000,000. It lists buyer names, total number of transactions, and total spending, ordering by total spending.
23. Dropshippers
    - This query identifies buyers who have made at least 10 transactions, each to a unique shipping address, indicating dropshipping behavior. It calculates transaction count, distinct shipping addresses, total spending, and average spending.
24. Offline Resellers
    - This query identifies buyers who have at least 8 transactions with the same shipping address and an average quantity per transaction greater than 10, suggesting they may be offline resellers. It calculates transaction count, total spending, average spending, and average quantity per transaction.
25. Payment Duration Trends
    - This query calculates the average, minimum, and maximum duration between transaction creation and payment, grouped by month. It provides insights into trends over time regarding how quickly transactions are paid after being created.

## Conclusion
The SQL queries developed for MyStore's dataset demonstrate a comprehensive approach to e-commerce data analysis. By leveraging these queries, one can effectively clean data, assess user behaviors, and derive actionable insights to enhance business strategies. This project underscores the importance of data-driven decision-making in the digital commerce landscape, where understanding user and product dynamics is key to maintaining a competitive edge.



