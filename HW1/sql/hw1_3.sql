WITH base AS
(
	SELECT sales.month, prod, sum(quant) total_q
	FROM sales
	GROUP BY sales.month, prod
),
MPP AS
(
	WITH MPPQ AS
	(
		SELECT base.month, max(total_q) max_total_q
		FROM base
		GROUP BY base.month	
	)
	SELECT base.month, base.prod, MPPQ.max_total_q
	FROM MPPQ, base
	WHERE MPPQ.month = base.month AND MPPQ.max_total_q = base.total_q
),
LPP AS
(
	WITH LPPQ AS
	(
		SELECT base.month, min(total_q) min_total_q
		FROM base
		GROUP BY base.month
	)
	SELECT base.month, base.prod, LPPQ.min_total_q
	FROM LPPQ, base
	WHERE LPPQ.month = base.month AND LPPQ.min_total_q = base.total_q
)
SELECT MPP.month, MPP.prod most_popular_prod, MPP.max_total_q most_pop_total_q, 
		LPP.prod least_popular_prod, LPP.min_total_q least_pop_total_q
FROM MPP, LPP
WHERE MPP.month = LPP.month
ORDER BY MPP.month