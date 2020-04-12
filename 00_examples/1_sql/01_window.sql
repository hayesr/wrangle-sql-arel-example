-- Example 1, ranks alone
-- Shows window functions
SELECT
  donor_id,
  NTILE(100) OVER (ORDER BY SUM(amount)) AS perc
FROM donations
WHERE entered_on BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY 1
;
