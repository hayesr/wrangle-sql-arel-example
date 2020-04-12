class PercQuery
  attr_reader :range

  def initialize(range:)
    @range = range
  end

  def query
    table
      .project(projection)
      .where(table[:entered_on].between(range))
      .group(1)
  end

  def table
    Donation.arel_table
  end

  def projection
    [
      table[:donor_id],
      percentile(table[:amount].sum)
    ]
  end

  private

  def percentile(expr)
    Arel::Nodes::Over.new(
      Arel::Nodes::NamedFunction.new('NTILE', [100]),
      Arel::Nodes::Window.new.tap do |w|
        w.order(expr)
      end
    )
  end
end
