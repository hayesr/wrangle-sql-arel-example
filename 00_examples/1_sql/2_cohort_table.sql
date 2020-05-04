SELECT
   gift1_date,
   SUM(g1.gift1) as g1_count,
   SUM(g2.gift2) as g2_count,
   SUM(g3.gift3) as g3_count
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
    AND (g1.gift1_date + INTERVAL '1 months') = date_trunc('month', donations.entered_on)
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
    AND (g1.gift1_date + INTERVAL '3 months') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g4 on true
LEFT JOIN LATERAL (
    SELECT 1 as gift5
    FROM donations
    WHERE donations.donor_id = g1.donor_id
    AND (g1.gift1_date + INTERVAL '4 months') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g5 on true
LEFT JOIN LATERAL (
    SELECT 1 as gift6
    FROM donations
    WHERE donations.donor_id = g1.donor_id
    AND (g1.gift1_date + INTERVAL '5 months') = date_trunc('month', donations.entered_on)
    LIMIT 1
) g6 on true
WHERE g1.gift1_date = '2019-01-01'
GROUP BY 1
ORDER BY 1
;
