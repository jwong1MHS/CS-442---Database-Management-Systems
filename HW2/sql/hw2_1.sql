WITH base AS (
	SELECT cust, prod, sales.month, sales.state, avg(quant) cust_avg
	FROM sales
	GROUP BY cust, prod, sales.month, sales.state
	ORDER BY cust, prod, sales.month, sales.state
),
other_prod AS (
	SELECT base.cust, base.prod, base.month, base.state,
			avg(sales.quant) other_prod_avg
	FROM base, sales
	WHERE base.cust = sales.cust AND base.prod <> sales.prod AND
			base.month = sales.month AND base.state = sales.state
	GROUP BY base.cust, base.prod, base.month, base.state
),
other_month AS (
	SELECT base.cust, base.prod, base.month, base.state,
			avg(sales.quant) other_month_avg
	FROM base, sales
	WHERE base.cust = sales.cust AND base.prod = sales.prod AND 
			base.month <> sales.month AND base.state = sales.state
	GROUP BY base.cust, base.prod, base.month, base.state
),
other_state AS (
	SELECT base.cust, base.prod, base.month, base.state,
			avg(sales.quant) other_state_avg
	FROM base, sales
	WHERE base.cust = sales.cust AND base.prod = sales.prod AND
			base.month = sales.month AND base.state <> sales.state
	GROUP BY base.cust, base.prod, base.month, base.state
)
SELECT base.cust customer, base.prod product, base.month, base.state, cust_avg, 
		other_prod_avg, other_month_avg, other_state_avg
FROM base NATURAL FULL OUTER JOIN other_prod NATURAL FULL OUTER JOIN
		other_month NATURAL FULL OUTER JOIN other_state