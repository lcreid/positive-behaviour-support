require 'test_helper'

class CompletedExpectationTest < ActiveSupport::TestCase
  test "completed expectation created from" do
    e = expectations(:more_time)
    ce = CompletedExpectation.new(e.copyable_attributes)
    assert_equal e, ce
    assert_equal ce, e
  end
end
