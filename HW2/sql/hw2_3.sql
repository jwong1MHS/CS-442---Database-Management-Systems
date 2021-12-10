WITH base AS (
	SELECT prod, quant
	FROM sales
	GROUP BY prod, quant
	ORDER BY prod, quant
),
prod_count AS (
	SELECT base.prod, base.quant, count(sales.quant) ct
	FROM base, sales
	WHERE base.prod = sales.prod AND base.quant >= sales.quant
	GROUP BY base.prod, base.quant
	ORDER BY base.prod, base.quant
),
sales_count AS (
	SELECT prod_count.prod, prod_count.quant, ct
	FROM prod_count, sales
	WHERE prod_count.prod = sales.prod
	AND prod_count.quant = sales.quant
	ORDER BY prod_count.prod, prod_count.quant
),
max_prod AS (
	SELECT prod, max(ct) max_p
	FROM sales_count
	GROUP BY prod
	ORDER BY prod
)
SELECT sales_count.prod product, min(sales_count.quant) "median quant"
FROM sales_count, max_prod
WHERE sales_count.prod = max_prod.prod AND ct >= max_p / 2
GROUP BY sales_count.prod
ORDER BY sales_count.prod