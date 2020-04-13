class FirstDonationQuery
  def query
    @query ||= begin
      donations
        .project(projection)
        .group(1)
    end
  end

  def projection
    [
      donations[:donor_id],
      month_trunc(donations[:entered_on].min).as('gift1_date'),
      Arel.sql(1).as('gift1')
    ]
  end

  private

  def donations
    Donation.arel_table
  end

  def month_trunc(expr)
    Arel::Nodes::NamedFunction.new('date_trunc', [Arel::Nodes.build_quoted('month'), expr])
  end
end
