# frozen_string_literal: true

require "test_helper"

class GoalTest < ActiveSupport::TestCase
  test "rewards pending" do
    rd = goals(:matt_one)
    assert_equal 6, rd.completed_routines.size
    assert_equal 4, rd.completed_routines.clean.size
    assert_equal 2, rd.pending
  end

  test "give reward" do
    rd = goals(:matt_one)
    assert_difference "rd.pending", -1 do
      rd.award
    end
  end

  test "try to give reward when not enough pending" do
    rd = goals(:matt_one)
    assert_no_difference "rd.pending" do
      rd.award(3)
    end
  end

  test "pending rewards" do
    assert_equal [matt_ones_goal = goals(:matt_one), goals(:marty_one)], Goal.pending_rewards.sort
    matt_ones_goal.award(2)
    assert_equal [goals(:marty_one)], Goal.pending_rewards.sort
  end
end
