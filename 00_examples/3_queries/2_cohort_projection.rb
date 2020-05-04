class CohortTableQuery
  # ...

  def projection
    cols = [first_gift_query.gift_date]

    1.upto(months) do |m|
      cols << lateral_query(m).gift_column.sum.as("g#{m}_count")
    end

    cols
  end

  # ...

  def lateral_join_segment(position)
    lateral_query(position).query.lateral("g#{position}")
  end

  def lateral_query(position)
    LateralDonationQuery.new(join_query: first_gift_query, position: position)
  end
end
