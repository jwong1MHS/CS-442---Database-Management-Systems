WITH oct_detail AS
(
	WITH t1 AS
	(
		SELECT cust, prod, max(quant) oct_max
		FROM sales
		WHERE sales.month = 10 AND sales.year >= 2018
		GROUP BY cust, prod
	)
	SELECT t1.cust, t1.prod, oct_max, s.date oct_date
	FROM t1, sales s
	WHERE t1.cust = s.cust AND t1.prod = s.prod 
			AND oct_max = quant AND s.month = 10 AND s.year >= 2018 ),
nov_detail AS
(
	WITH t2 AS
	(
		SELECT cust, prod, min(quant) nov_min
		FROM sales
		WHERE sales.month = 11
		GROUP BY cust, prod
	)
	SELECT t2.cust, t2.prod, nov_min, s.date nov_date
	FROM t2, sales s
	WHERE t2.cust = s.cust AND t2.prod = s.prod 
			AND nov_min = quant AND s.month = 11
),
dec_detail AS
(
	WITH t3 AS
	(
		SELECT cust, prod, min(quant) dec_min
		FROM sales
		WHERE sales.month = 12
		GROUP BY cust, prod
	)
	SELECT t3.cust, t3.prod, dec_min, s.date dec_date
	FROM t3, sales s
	WHERE t3.cust = s.cust AND t3.prod = s.prod 
			AND dec_min = quant AND s.month = 12
)
SELECT o.cust customer, o.prod product, oct_max, oct_date, nov_min,
 		nov_date, dec_min, dec_date
FROM oct_detail o NATURAL FULL OUTER JOIN nov_detail n 
		NATURAL FULL OUTER JOIN dec_detail d
ORDER BY customer, product