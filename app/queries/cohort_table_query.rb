class CohortTableQuery
  attr_reader :months, :start_date
  delegate :to_sql, to: :query

  def initialize(months: 12, start_date: nil)
    @months = months
    @start_date = start_date || 1.year.ago.beginning_of_month.to_date
  end

  def execute
    ApplicationRecord.connection.execute(to_sql)
  end

  def query
    @query = begin
      manager
        .project(projection)
        .from(first_gift_query.query.as(first_gift_query.table.name))
        .where(first_gift_query.gift_date.gt(start_date))
        .group(1)
        .order(1)

      1.upto(months) do |m|
        manager.join(lateral_join_segment(m), Arel::Nodes::OuterJoin).on(Arel.sql('true'))
      end

      manager
    end
  end

  def projection
    cols = [first_gift_query.gift_date]

    1.upto(months) do |m|
      cols << lateral_query(m).gift_column.sum.as("g#{m}_count")
    end

    cols
  end

  private

  def manager
    @manager ||= Arel::SelectManager.new(Arel::Table.engine)
  end

  def first_gift_query
    @first_gift_query ||= FirstDonationQuery.new
  end

  def lateral_join_segment(position)
    lateral_query(position).query.lateral("g#{position}")
  end

  def lateral_query(position)
    LateralDonationQuery.new(join_query: first_gift_query, position: position)
  end
end
