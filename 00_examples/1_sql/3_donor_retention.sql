SELECT *
FROM (
    SELECT
        donor_id,
        date_trunc('month', MIN(entered_on)) as gift1_date,
        1 as gift1
    FROM donations
    GROUP BY 1
)g1
LEFT JOIN LATERAL (
    SELECT 1 as gift2
    FROM donations
    WHERE donations.donor_id = g1.donor_id
    AND (g1.gift1_date + INTERVAL '1 month') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g2 on true
LEFT JOIN LATERAL (
    SELECT 1 as gift3
    FROM donations
    WHERE donations.donor_id = g1.donor_id
    AND (g1.gift1_date + INTERVAL '2 months') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g3 on true
LEFT JOIN LATERAL (
    SELECT 1 as gift4
    FROM donations
    WHERE donations.donor_id = g1.donor_id
    AND (g1.gift1_date + INTERVAL '3 month') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g4 on true
WHERE g1.gift1_date = '2019-01-01'
ORDER BY 1
;
