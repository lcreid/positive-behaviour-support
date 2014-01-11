require 'test_helper'

class RewardDefinitionTest < ActiveSupport::TestCase
  test "two rewards pending" do
    rd = reward_definitions(:matt_one)
    assert_equal 4, rd.completed_routines.size
    assert_equal 2, rd.pending
  end
end
