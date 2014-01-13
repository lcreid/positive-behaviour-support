=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  test "rewards pending" do
    rd = goals(:matt_one)
    assert_equal 6, rd.completed_routines.size
    assert_equal 4, rd.clean_routines.size
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
end
