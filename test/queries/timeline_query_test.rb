require 'test_helper'

class TimelineQueryTest < ActiveSupport::TestCase
  setup do
    @query = TimelineQuery.new(months: 5)
  end

  test "generating sql" do
    assert @query.to_sql.include?('SELECT *')
  end

  test "including the FirstDonationQuery as a subquery" do
    assert @query.to_sql.include?('FROM (')
    assert @query.to_sql.include?(') g0')
  end

  test "building lateral joins" do
    1.upto(5).each do |i|
      assert @query.to_sql.include?("g#{i} ON true")
    end
  end

  test "execution" do
    assert_nothing_raised { @query.execute }
  end
end
