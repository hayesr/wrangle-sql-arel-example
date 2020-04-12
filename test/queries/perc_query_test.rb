require 'test_helper'

class PercQueryTest < ActiveSupport::TestCase
  setup do
    range = Date.new(2019)..Date.new(2019, 12, 31)
    @query = PercQuery.new(range: range)
  end

  test "generating sql" do
    assert @query.to_sql.include?('SELECT')
  end
end
