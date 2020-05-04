class LateralDonationQuery
  attr_reader :join_query, :position
  delegate :to_sql, to: :query

  def initialize(join_query:, position:)
    @join_query = join_query
    @position = position
  end

  def query
    @query ||= begin
      donations
        .project(projection)
        .where(donations[:donor_id].eq(join_query.table[:donor_id]))
        .where(month_offset.eq(month_trunc(donations[:entered_on])))
        .take(1)
    end
  end

  def projection
    [Arel.sql(1.to_s).as("gift#{position}")]
  end

  def table
    Arel::Table.new("g#{position}")
  end

  def gift_column
    table["gift#{position}"]
  end

  private

  def donations
    Donation.arel_table
  end

  # g1.gift1_date + INTERVAL '1 month'
  def month_offset
    join_query.gift_date + interval("#{position} months")
  end

  def interval(str)
    Arel::Nodes::UnaryOperation.new('INTERVAL', Arel::Nodes.build_quoted(str))
  end

  def month_trunc(expr)
    Arel::Nodes::NamedFunction.new(
      'date_trunc', [Arel::Nodes.build_quoted('month'), expr]
    )
  end
end
