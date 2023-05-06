SELECT *
FROM (
		SELECT date_format(
				from_unixtime(after.created_date_time / 1000000, 'Asia/Singapore'),
				'%Y-%m-%d %h:%i:%s'
			) as creation_date,
			after.created_date_time,
			SUBSTR(
				cast(
					from_unixtime(after.created_date_time / 1000000, 'Asia/Singapore') as VARCHAR
				),
				1,
				10
			) as sg_time,
			-- 	json_extract_scalar(json_extract(after, '$.after'), '$.after') AS user_id
		after.user_id AS user_id,
			after.invoice_number AS invoice_number,
			after.total_amount AS total_amount
		FROM "AwsDataCatalog"."evo-prod-cdc"."evo_lytepay2_invoice" 
		-- WHERE from_unixtime(ts_ms) < '2023_3_25'
		WHERE op = 'r'
	)
WHERE sg_time < SUBSTR(
		cast(
			localtimestamp AT TIME ZONE 'Asia/Singapore' as VARCHAR
		),
		1,
		10
	)
ORDER BY sg_time DESC;