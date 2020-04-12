-- Example 3, donations in a period
-- JOIN against CTEs, keep table names consistent
WITH percs AS (
  SELECT
    donor_id,
    NTILE(100) OVER (ORDER BY SUM(amount)) AS perc
  FROM donations
  WHERE entered_on BETWEEN '2019-01-01' AND '2019-12-31'
  GROUP BY 1
),
grouped_percs AS (
  SELECT *,
    CASE
      WHEN perc < 50 THEN 1
      WHEN perc < 80 THEN 2
      WHEN perc < 95 THEN 3
      WHEN perc < 100 THEN 4
      ELSE 5
    END AS perc_grp
  FROM percs
)

SELECT
  grouped_percs.donor_id,
  SUM(donations.amount)
FROM grouped_percs
  INNER JOIN donations
  ON grouped_percs.donor_id = donations.donor_id
WHERE grouped_percs.perc_grp = 5
  AND donations.entered_on BETWEEN '2020-01-01' AND '2020-04-31'
GROUP BY 1
ORDER BY 2 desc
;
