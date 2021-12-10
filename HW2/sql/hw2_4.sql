WITH total_count AS (
	SELECT cust, prod, sum(quant)
	FROM sales
	GROUP BY cust, prod
	ORDER BY cust, prod
),
month_count AS (
	SELECT cust, prod, sales.month, sum(quant)
	FROM sales
	GROUP BY cust, prod, sales.month
	ORDER BY cust, prod, sales.month
)
SELECT *
FROm month_count