SELECT *
FROM (
    SELECT
        donor_id,
        date_trunc('month', MIN(entered_on)) as gift0_date,
        1 as gift0
    FROM donations
    GROUP BY 1
) g0
LEFT JOIN LATERAL (
    SELECT 1 as gift1
    FROM donations
    WHERE donations.donor_id = g0.donor_id
    AND (g0.gift0_date + INTERVAL '1 month') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g1 on true
LEFT JOIN LATERAL (
    SELECT 1 as gift2
    FROM donations
    WHERE donations.donor_id = g0.donor_id
    AND (g0.gift0_date + INTERVAL '2 months') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g2 on true
LEFT JOIN LATERAL (
    SELECT 1 as gift3
    FROM donations
    WHERE donations.donor_id = g0.donor_id
    AND (g0.gift0_date + INTERVAL '3 month') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g3 on true
WHERE g0.gift0_date > '2018-12-31'
ORDER BY 1
;
