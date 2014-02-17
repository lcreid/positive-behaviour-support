=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  def setup
    @user = users(:user_marie)
    @patient = @user.people[0]
    @goal = @patient.goals[0]
  end
  
  test "new award" do
    @controller.log_in(@user)
    get :new, { goal_id: @goal.id }
    assert_response :success
  end
  
  test "create award" do
    @controller.log_in(@user)
    # Target is two, so number of completed routines should change by two
    assert_difference "CompletedRoutine.where(awarded: true).count", 2 do
      put :create, { goal_id: @goal.id }
    end
    assert_redirected_to person_path(@goal.person)
  end

  test "create two awards" do
    @controller.log_in(@user)
    # Target is two, so number of completed routines should change by four
    assert_difference "CompletedRoutine.where(awarded: true).count", 4 do
      put :create, { goal_id: @goal.id, number_of_rewards: 2 }
    end
    assert_redirected_to person_path(@goal.person)
  end

  test "try to get a new award without goal_id" do
    @controller.log_in(@user)
    assert_raise ActionController::ParameterMissing do
      get :new
    end
  end
  
  test "try to get a new completed routine when not logged in" do
    assert_raise ActionController::RoutingError do
      get :new, { goal_id: @goal.id }
    end
  end
  
  test "try to get a new award when not allowed access to the goal" do
    @controller.log_in(@user)
    assert_raise ActionController::RoutingError do
      get :new, { goal_id: goals(:belongs_to_no_one) }
    end
  end
end
