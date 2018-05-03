require 'test_helper'

class GoalsControllerTest < ActionController::TestCase
  test "try to delete a goal when not logged in" do
    assert_raise ActionController::RoutingError do
      delete :destroy, params: { id: goals(:matt_one) }
    end
  end

  test "try to delete a goal when not allowed" do
    @controller.log_in(users(:user_marie))
    assert_raise ActionController::RoutingError do
      delete :destroy, params: { id: goals(:marty_one) }
    end
  end

  test "delete a goal" do
    @controller.log_in(users(:user_marie))

    @request.env['HTTP_REFERER'] = 'http://localhost:3000/user/edit'

    assert_difference "Goal.all.count", -1 do
      delete :destroy, params: { id: goals(:matt_one).id }
    end
    # FIXME: Removed to get rid of deprecation
    # assert_redirected_to :back
  end

  test "try to edit a goal when not logged in" do
    assert_raise ActionController::RoutingError do
      get :edit, params: { id: goals(:matt_one) }
    end
  end

  test "try to edit a goal when not allowed" do
    @controller.log_in(users(:user_marie))
    assert_raise ActionController::RoutingError do
      get :edit, params: { id: goals(:marty_one) }
    end
  end

  test "edit a goal" do
    @controller.log_in(users(:user_marie))

    get :edit, params: { id: goals(:matt_one) }
    assert_response :success
    assert_not_nil assigns(:goal)
  end

  test "try to update a goal when not logged in" do
    goal = goals(:matt_one)
    assert_raise ActionController::RoutingError do
      post :update, params: { id: goal.id, goal: { name: "New Name" } }
    end
  end

  test "try to update a goal when not allowed" do
    @controller.log_in(users(:user_marie))
    goal = goals(:marty_one)
    assert_raise ActionController::RoutingError do
      post :update, params: { id: goal.id, goal: { name: "New Name" } }
    end
  end

  test "update a goal" do
    @controller.log_in(user = users(:user_marie))
    person = people(:patient_matt)
    goal = goals(:matt_one)
    original_goal_name = goal.name

    post :update, params: { id: goal.id, goal: { id: goal.id, name: "New Name" } }
    assert_redirected_to edit_person_path(person)

    db_goal = Goal.find(goal.id)
    refute_equal original_goal_name, db_goal.name
  end

  test "show page to create a new goal" do
    @controller.log_in(user = users(:user_marie))
    person = people(:patient_matt)

    get :new, params: { person_id: person.id }
    assert_response :success
    assert_not_nil assigns(:goal)
  end

  test "create a goal" do
    @controller.log_in(user = users(:user_marie))
    person = people(:patient_matt)

    assert_difference "person.goals.count" do
      post :create, params: { person_id: person.id, goal: { name: "New Name", person_id: person.id, expectations_attributes: ["description" => "one"] } }
    end
    assert_redirected_to edit_person_path(person)
  end
end
