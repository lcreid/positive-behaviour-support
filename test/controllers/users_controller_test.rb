# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionController::TestCase
  test "get logged in user" do
    user = users(:user_marie)
    uid = user.id
    session[:user_id] = uid
    get :home, params: { id: @controller.current_user.id }
    assert :success

    patient = user.people[0]

    assert_select "div#user-name" do
      assert_select "h1", "Marie"
    end
    assert_select "nav#test-top-menu" # No longer put user name in top bar, text: /.*Marie.*/
    assert_select "div#patients" do
      assert_select "li.person", 2
    end
  end

  test "get not logged in user" do
    uid = users(:existing_twitter).id
    assert_raise ActionController::RoutingError do
      get :home, params: { id: uid }
    end
  end

  test "get other user" do
    uid = users(:existing_twitter).id
    session[:user_id] = uid
    assert_raise ActionController::RoutingError do
      get :home, params: { id: 0 }
    end
  end

  test "profile page" do
    uid = users(:user_marie).id
    session[:user_id] = uid

    get :edit, params: { id: uid }

    assert_select "#people"
    assert_select ".user", 2
    assert_select ".user a", 2
  end
end
