class PercQuery
  attr_reader :range
  delegate :to_sql, to: :query

  def initialize(range:)
    @range = range
  end

  def query
  end
end
