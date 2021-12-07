WITH sales_q AS (
	SELECT *
	FROM sales, 
		(SELECT 1 AS Q1)
		AS sales_q1
	WHERE sales.month BETWEEN 1 AND 3
	UNION
	SELECT *
	FROM sales, 
		(SELECT 2 AS Q1)
		AS sales_q2
	WHERE sales.month BETWEEN 4 AND 6
	UNION
	SELECT *
	FROM sales, 
		(SELECT 3 AS Q1)
		AS sales_q3
	WHERE sales.month BETWEEN 7 AND 9
	UNION
	SELECT *
	FROM sales, 
		(SELECT 4 AS Q1)
		AS sales_q4
	WHERE sales.month BETWEEN 10 AND 12
),
base AS (
	SELECT cust, prod, sales_q.state, q1
	FROM sales_q
	GROUP BY cust, prod, sales_q.state, q1
),
b_avg AS (
	SELECT base.cust, base.prod, base.state, base.q1, avg(sales_q.quant) before_avg
	FROM base, sales_q
	WHERE base.cust = sales_q.cust AND base.prod = sales_q.prod AND 
			base.state = sales_q.state AND base.q1 = (sales_q.q1+1)
	GROUP BY base.cust, base.prod, base.state, base.q1
),
a_avg AS (
	SELECT base.cust, base.prod, base.state, base.q1, avg(sales_q.quant) after_avg
	FROM base, sales_q
	WHERE base.cust = sales_q.cust AND base.prod = sales_q.prod AND 
			base.state = sales_q.state AND base.q1 = (sales_q.q1-1)
	GROUP BY base.cust, base.prod, base.state, base.q1
)
SELECT base.cust, base.prod, base.state, base.q1, before_avg, after_avg
FROM base NATURAL FULL OUTER JOIN b_avg NATURAL FULL OUTER JOIN a_avg
ORDER BY base.cust, base.prod, base.state, base.q1