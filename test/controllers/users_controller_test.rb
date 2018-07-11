# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "get logged in user" do
    controller_test_log_in(user = users(:user_marie))
    get home_user_url(@controller.current_user)
    assert :success

    assert_select "nav#test-top-menu" # No longer put user name in top bar, text: /.*Marie.*/
    assert_select "div#patients" do
      assert_select "li.person", 2
    end
  end

  test "get not logged in user" do
    uid = users(:existing_twitter).id
    assert_raise ActionController::RoutingError do
      get user_url(uid)
    end
  end

  test "get other user" do
    controller_test_log_in(users(:existing_twitter))
    assert_raise ActionController::RoutingError do
      get user_url(0)
    end
  end

  test "profile page" do
    controller_test_log_in(user = users(:user_marie))

    get edit_user_url(user)

    assert_select "#people"
    assert_select ".user", 2
    assert_select ".user a", 2
  end
end
