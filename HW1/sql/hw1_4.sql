WITH base AS
(
	SELECT prod, sales.month, sum(quant) total_q
	FROM sales
	GROUP BY prod, sales.month
),
MFM AS
(
	WITH MFMQ AS
	(
		SELECT prod, max(total_q) max_total_q
		FROM base
		GROUP BY prod
	)
	SELECT base.prod, base.month
	FROM MFMQ, base
	WHERE MFMQ.prod = base.prod AND MFMQ.max_total_q = base.total_q
),
LFM AS
(
	WITH LFMQ AS
	(
		SELECT prod, min(total_q) min_total_q
		FROM base
		GROUP BY prod
	)
	SELECT base.prod, base.month
	FROM LFMQ, base
	WHERE LFMQ.prod = base.prod AND LFMQ.min_total_q = base.total_q
)
SELECT MFM.prod product, MFM.month most_fav_mo, LFM.month least_fav_mo
FROM MFM, LFM
WHERE MFM.prod = LFM.prod
ORDER BY product