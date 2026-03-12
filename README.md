# SQL Sales Data Exploration

**Author:** Christian Kho Aler
**Dataset:** 500-row synthetic sales orders dataset
**Tool:** MySQL
**Score:** 25/25 ✅

## Overview
A SQL practice project exploring a 500-row sales dataset using 
real-world analytical queries. Covers aggregations, window functions, 
CTEs, and subqueries across 15 challenges + 1 bonus query.

## Skills Used
- Aggregate Functions — SUM, COUNT, AVG, ROUND
- Window Functions — RANK(), SUM() OVER(), LAG()
- CTEs — WITH ... AS ()
- Subqueries
- PARTITION BY, GROUP BY, ORDER BY
- DATEDIFF for delivery time analysis

## Queries

### 🟢 Basic (1–5)
1. Total revenue per region (high to low)
2. Top 5 products by total revenue
3. Count of orders per payment method
4. Total number of orders in the dataset
5. Orders with discount greater than 20%

### 🟡 Intermediate (6–10)
6. Average discount percentage per category
7. Sales rep ranking by total revenue
8. Order status breakdown with percentage
9. Category with the most profit
10. Orders where revenue is above average

### 🔴 Advanced (11–15)
11. Running total of revenue by date (cumulative)
12. Rank products within each category by profit
13. Average, fastest & slowest delivery per region
14. Top sales rep per region by total revenue
15. Monthly revenue totals with best month ranking

### ⭐ Bonus
- Day over day revenue change using LAG()

## Key Concepts Mastered
- `SUM(SUM(x)) OVER()` — aggregate inside window function
- `RANK() OVER (PARTITION BY ...)` — rank within groups
- `LAG()` — compare current row to previous row
- CTE + WHERE rank = 1 — filter top results per group
