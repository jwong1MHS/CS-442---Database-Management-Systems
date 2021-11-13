WITH base AS (
	SELECT cust, prod, avg(quant) average, sum(quant) total, 
			count(quant) count
	FROM sales
	WHERE year BETWEEN 2016 AND 2020
	GROUP BY cust, prod
),
ct_detail AS (
	SELECT cust, prod, avg(quant) ct_avg
	FROM sales
	WHERE sales.state = 'CT' AND year BETWEEN 2016 AND 2020
	GROUP BY cust, prod
),
ny_detail AS (
	SELECT cust, prod, avg(quant) ny_avg
	FROM sales
	WHERE sales.state = 'NY' AND year BETWEEN 2016 AND 2020
	GROUP BY cust, prod
),
nj_detail AS (
	SELECT cust, prod, avg(quant) nj_avg
	FROM sales
	WHERE sales.state = 'NJ' AND year BETWEEN 2016 AND 2020
	GROUP BY cust, prod
),
pa_detail AS (
	SELECT cust, prod, avg(quant) pa_avg
	FROM sales
	WHERE sales.state = 'PA' AND year BETWEEN 2016 AND 2020
	GROUP BY cust, prod
)
SELECT base.prod product, base.cust customer, ct_avg, ny_avg, nj_avg, 
		pa_avg, average, total, count
FROM ct_detail NATURAL FULL OUTER JOIN ny_detail 
		NATURAL FULL OUTER JOIN nj_detail NATURAL FULL OUTER JOIN
		pa_detail NATURAL FULL OUTER JOIN base
ORDER BY product, customer