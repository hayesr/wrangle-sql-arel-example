class TimelineDonorQuery
  attr_reader :months, :start_date
  delegate :to_sql, to: :query

  def initialize(months: 12, start_date: nil)
    @months = months
    @start_date = start_date || 1.year.ago.beginning_of_month.to_date
  end

  def execute
    ApplicationRecord.connection.execute(to_sql)
  end

  def donors
    Donor.find_by_sql(to_sql)
  end

  def query
    @query = begin
      manager
        .project(projection)
        .from(first_gift_query.query.as(first_gift_query.table.name))
        .where(first_gift_query.gift_date.gt(start_date))

      1.upto(months) do |m|
        manager.join(lateral_join_segment(m), Arel::Nodes::OuterJoin).on(Arel.sql('true'))
      end

      manager.join(donors_table).on(first_gift_query.table[:donor_id].eq(donors_table[:id]))
    end
  end

  def projection
    [Arel.star]
  end

  private

  def manager
    @manager ||= Arel::SelectManager.new(Arel::Table.engine)
  end

  def donors_table
    Donor.arel_table
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
