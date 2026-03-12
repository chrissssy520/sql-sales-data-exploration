-- ============================================================
--  SQL PRACTICE PORTFOLIO
--  Dataset: orders_raw (500 rows x 16 columns)
--  Author: Christian Kho Aler
--  Topics: Aggregations, Window Functions, CTEs, Subqueries

-- 1. Total revenue per region (high to low)
SELECT region, SUM(revenue) AS total_revenue 
FROM orders_raw
GROUP BY region
ORDER BY total_revenue DESC;

-- 2. Top 5 products by total revenue
SELECT product_name, SUM(revenue) AS total_revenue 
FROM orders_raw 
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 3. Count of orders per payment method
SELECT payment_method, COUNT(*) AS total 
FROM orders_raw
GROUP BY payment_method
ORDER BY total DESC;

-- 4. Total number of orders in the dataset
SELECT COUNT(*) AS total_orders 
FROM orders_raw;

-- 5. Orders with discount greater than 20%
SELECT * 
FROM orders_raw
WHERE discount > 0.2;



-- 6. Average discount percentage per category
SELECT category, ROUND(AVG(discount) * 100, 0) AS discount_percentage 
FROM orders_raw
GROUP BY category
ORDER BY discount_percentage DESC;

-- 7. Sales rep ranking by total revenue
SELECT 
    sales_rep, 
    SUM(revenue) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM orders_raw
GROUP BY sales_rep
ORDER BY revenue_rank;

-- 8. Orders by status with percentage
SELECT 
    order_status, 
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM orders_raw
GROUP BY order_status
ORDER BY total DESC;

-- 9. Category with the most profit
SELECT category, SUM(profit) AS total_profit 
FROM orders_raw
GROUP BY category
ORDER BY total_profit DESC
LIMIT 1;

-- 10. Orders where revenue is above average
SELECT * FROM (
    SELECT 
        order_id, 
        revenue, 
        ROUND(AVG(revenue) OVER(), 2) AS avg_revenue
    FROM orders_raw
) AS sub
WHERE revenue > avg_revenue;


-- 11. Running total of revenue by date (cumulative)
SELECT 
    order_date,
    SUM(revenue) AS daily_revenue,
    SUM(SUM(revenue)) OVER (ORDER BY order_date) AS running_total
FROM orders_raw
GROUP BY order_date
ORDER BY order_date;

-- 12. Rank products within each category by profit
WITH ranked AS (
    SELECT 
        category, 
        product_name, 
        SUM(profit) AS total_profit,
        RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC) AS profit_rank
    FROM orders_raw
    GROUP BY category, product_name
)
SELECT category, product_name, total_profit
FROM ranked
WHERE profit_rank = 1
ORDER BY total_profit DESC;

-- 13. Average, fastest, slowest delivery per region
SELECT 
    region,
    ROUND(AVG(DATEDIFF(delivery_date, order_date)), 0) AS avg_days,
    MIN(DATEDIFF(delivery_date, order_date))           AS fastest,
    MAX(DATEDIFF(delivery_date, order_date))           AS slowest
FROM orders_raw
WHERE order_status = 'Delivered'
GROUP BY region
ORDER BY avg_days;

-- 14. Top sales rep per region by total revenue
WITH regional_sales AS (
    SELECT 
        sales_rep, 
        region, 
        SUM(revenue) AS total_revenue,
        RANK() OVER (PARTITION BY region ORDER BY SUM(revenue) DESC) AS revenue_rank
    FROM orders_raw
    GROUP BY sales_rep, region
)
SELECT sales_rep, region, total_revenue
FROM regional_sales
WHERE revenue_rank = 1
ORDER BY total_revenue DESC;

-- 15. Monthly revenue totals — best month ranking
WITH monthly AS (
    SELECT 
        MONTH(order_date)     AS month_num,
        MONTHNAME(order_date) AS month_name,
        SUM(revenue)          AS total_revenue,
        RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
    FROM orders_raw
    GROUP BY month_num, month_name
)
SELECT month_name, total_revenue, revenue_rank
FROM monthly
ORDER BY month_num;



-- Day over day revenue change
WITH daily AS (
    SELECT order_date, SUM(revenue) AS daily_revenue
    FROM orders_raw
    GROUP BY order_date
)
SELECT 
    order_date,
    daily_revenue,
    LAG(daily_revenue)  OVER (ORDER BY order_date) AS yesterday_revenue,
    daily_revenue - LAG(daily_revenue) OVER (ORDER BY order_date) AS revenue_change
FROM daily
ORDER BY order_date;