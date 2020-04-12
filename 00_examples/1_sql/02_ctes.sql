-- Ex 2: CTEs
WITH percs AS (
  SELECT
    donor_id,
    NTILE(100) OVER (ORDER BY SUM(amount)) AS perc
  FROM donations
  WHERE entered_on BETWEEN '2019-01-01' AND '2019-12-31'
  GROUP BY 1
)

SELECT *
FROM percs
WHERE perc > 95
;

-- Example 2, arbitrary groups
-- CTEs, CASE
WITH percs AS (
  SELECT
    donor_id,
    NTILE(100) OVER (ORDER BY SUM(amount)) AS perc
  FROM donations
  WHERE entered_on BETWEEN '2019-01-01' AND '2019-12-31'
  GROUP BY 1
)

SELECT *,
  CASE
    WHEN perc < 50 THEN 1
    WHEN perc < 80 THEN 2
    WHEN perc < 95 THEN 3
    WHEN perc < 100 THEN 4
    ELSE 5
  END AS perc_grp
FROM percs
;


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

SELECT *
FROM grouped_percs
WHERE perc_grp = 5
;

-- Use this for graphs or for getting the list of donors

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

SELECT donors.*
FROM grouped_percs
  INNER JOIN donors
  ON grouped_percs.donor_id = donors.id
WHERE perc_grp = 5
;

-- Donor.find_by_sql(sql)
