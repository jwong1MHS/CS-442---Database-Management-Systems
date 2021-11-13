WITH agg AS
(
	SELECT cust, min(quant) min_q, max(quant) max_q, 
			avg(quant) avg_q
	FROM sales
	GROUP BY cust
),
min_detail AS
(
	SELECT agg.cust, min_q, max_q, avg_q, prod, s.date, s.state
	FROM agg, sales s
	WHERE agg.cust = s.cust AND agg.min_q = s.quant
)
SELECT min_d.cust customer, min_q, min_d.prod min_prod, 
		min_d.date min_date, min_d.state st, max_q, 
		s.prod max_prod, s.date max_date, s.state st, avg_q
FROM min_detail min_d, sales s
WHERE min_d.cust = s.cust AND max_q = quant
ORDER BY s.cust