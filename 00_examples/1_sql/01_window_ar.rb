Donation
  .where(entered_on: Date.new(2019)..Date.new(2019, 12, 31))
  .select(:donor_id, "NTILE(100) OVER (ORDER BY SUM(AMOUNT)) AS perc")
  .group(1)
