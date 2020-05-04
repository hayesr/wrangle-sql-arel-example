initial = <<~SQL
  SELECT
      donor_id,
      date_trunc('month', MIN(entered_on)) as gift0_date,
      1 as gift0
  FROM donations
  GROUP BY 1
SQL

def lateral(num)
  <<~SQL
    LEFT JOIN LATERAL (
        SELECT #{num} as gift#{num}
        FROM donations
        WHERE donations.donor_id = g0.donor_id
        AND (g0.gift0_date + INTERVAL '#{num} month') = date_trunc('month', donations.entered_on)
        LIMIT 1
    ) g#{num} on true
  SQL
end

def build_sql
  output = <<~SQL
    SELECT *
    FROM (
      #{initial}
    ) g0
  SQL

  1.upto(12) do |m|
    output << lateral(m)
  end

  output << "WHERE g0.gift0_date > '2018-12-01'"
  output << "ORDER BY 1"

  output
end
