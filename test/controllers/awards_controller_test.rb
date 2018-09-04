# frozen_string_literal: true

require "test_helper"

class AwardsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_marie)
    @patient = @user.people.find_by(name: "Matt-Patient")
    @goal = @patient.goals.find_by(name: "Time Off")
  end

  test "new award" do
    controller_test_log_in(@user)
    get new_award_url, params: { goal_id: @goal.id }
    assert_response :success
  end

  test "create award" do
    controller_test_log_in(@user)
    # Target is two, so number of completed routines should change by two
    assert_difference "CompletedRoutine.where(awarded: true).count", 2 do
      post awards_url, params: { goal_id: @goal.id }
    end
    assert_redirected_to person_path(@goal.person)
  end

  test "create two awards" do
    controller_test_log_in(@user)
    # Target is two, so number of completed routines should change by four
    assert_difference "CompletedRoutine.where(awarded: true).count", 4 do
      post awards_url, params: { goal_id: @goal.id, number_of_rewards: 2 }
    end
    assert_redirected_to person_path(@goal.person)
  end

  test "try to get a new award without goal_id" do
    controller_test_log_in(@user)
    assert_raise ActionController::ParameterMissing do
      get new_award_url
    end
  end

  test "try to get a new completed routine when not logged in" do
    assert_raise ActionController::RoutingError do
      get new_award_url, params: { goal_id: @goal.id }
    end
  end

  test "try to get a new award when not allowed access to the goal" do
    controller_test_log_in(@user)
    assert_raise ActionController::RoutingError do
      get new_award_url, params: { goal_id: goals(:belongs_to_no_one).id }
    end
  end
end
