WITH total_c AS (
	SELECT cust, prod, sum(quant) total_q
	FROM sales
	GROUP BY cust, prod
	ORDER BY cust, prod
),
month_c AS (
	SELECT cust, prod, sales.month, sum(quant) sum_m
	FROM sales
	GROUP BY cust, prod, sales.month
	ORDER BY cust, prod, sales.month
),
month_agg AS (
	SELECT m1.cust, m1.prod, m1.month, sum(m2.sum_m) sum_q
	FROM month_c m1, month_c m2
	WHERE m1.cust = m2.cust AND m1.prod = m2.prod AND m1.month >= m2.month
	GROUP BY m1.cust, m1.prod, m1.month
	ORDER BY m1.cust, m1.prod, m1.month
)
SELECT month_agg.cust customer, month_agg.prod product, min(month_agg.month) "75% purchased by month"
FROM month_agg, total_c
WHERE month_agg.cust = total_c.cust AND month_agg.prod = total_c.prod
		AND sum_q >= total_q * 0.75
GROUP BY month_agg.cust, month_agg.prod
ORDER BY month_agg.cust, month_agg.prod