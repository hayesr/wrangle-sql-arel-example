require 'test_helper'

class LateralDonationQueryTest < ActiveSupport::TestCase
  setup do
    g1 = FirstDonationQuery.new
    @query = LateralDonationQuery.new(join_query: g1, position: 2)
  end

  test "generating sql" do
    assert @query.to_sql.include?('SELECT')
    assert @query.to_sql.include?('FROM "donations"')
  end

  test "building month offset" do
    assert @query.to_sql.include?(%{"g0"."gift0_date" +  INTERVAL '2 months'})
  end

  # test "execution" do
  #   assert_nothing_raised { @query.execute }
  # end
end
