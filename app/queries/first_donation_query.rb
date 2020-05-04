class FirstDonationQuery
  delegate :to_sql, to: :query

  def execute
    ApplicationRecord.connection.execute(to_sql)
  end

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
      month_trunc(donations[:entered_on].minimum).as('gift0_date'),
      Arel.sql(1.to_s).as('gift0')
    ]
  end

  def table
    Arel::Table.new(:g0)
  end

  def gift_date
    table[:gift0_date]
  end

  private

  def donations
    Donation.arel_table
  end

  def month_trunc(expr)
    Arel::Nodes::NamedFunction.new(
      'date_trunc', [Arel::Nodes.build_quoted('month'), expr]
    )
  end
end
