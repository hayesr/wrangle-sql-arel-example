require 'test_helper'

class FirstDonationQueryTest < ActiveSupport::TestCase
  setup do
    @query = FirstDonationQuery.new
  end

  test "generating sql" do
    assert @query.to_sql.include?('SELECT')
    assert @query.to_sql.include?('FROM "donations"')
  end

  test "building MIN(entered_on)" do
    assert @query.to_sql.include?(%{date_trunc('month', MIN("donations"."entered_on"))})
  end

  test "execution" do
    assert_nothing_raised { @query.execute }
  end
end
