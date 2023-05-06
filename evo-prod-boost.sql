SELECT *
FROM (
		SELECT date_format(
				from_unixtime(
					after.created_date_time / 1000000,
						'Asia/Singapore'
				),
				'%Y-%m-%d %h:%i:%s'
			) as creation_date,
			after.created_date_time,
			SUBSTR(
				cast(
					from_unixtime(
						after.created_date_time / 1000000,
							'Asia/Singapore'
					) as VARCHAR
				),
				1,
				10
			) as sg_time,
			after.user_id AS user_id,
			after.invoice_id AS invoice_id,
			after.boost_amount AS boost_amount,
			after.currency AS currency
		FROM "evo-prod-cdc"."evo_lytepay2_boost"
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