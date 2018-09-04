# frozen_string_literal: true

require "test_helper"

class CompletedExpectationTest < ActiveSupport::TestCase
  test "completed expectation created from" do
    e = expectations(:more_time)
    ce = CompletedExpectation.new(e.copyable_attributes)
    assert_equal e, ce
    assert_equal ce, e
  end

  test "clean expectations" do
    assert_equal 18, CompletedExpectation.clean.count
    cr = completed_routines(:matt_one_four)
    assert_equal [completed_expectations(:matt_one_four_one)], cr.completed_expectations.clean
    assert_equal [completed_expectations(:matt_one_four_two)], cr.completed_expectations.not_clean
    cr = completed_routines(:matt_one_five)
    assert_equal [completed_expectations(:matt_one_five_one)], cr.completed_expectations.clean
    assert_equal [completed_expectations(:matt_one_five_two)], cr.completed_expectations.not_clean
  end
end
