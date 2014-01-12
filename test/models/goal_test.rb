require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  test "two rewards pending" do
    rd = goals(:matt_one)
    assert_equal 6, rd.completed_routines.size
    assert_equal 4, rd.clean_routines.size
    assert_equal 2, rd.pending
  end
end
