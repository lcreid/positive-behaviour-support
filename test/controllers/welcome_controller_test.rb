# frozen_string_literal: true

require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "logged in should get user home" do
    user = users(:existing_twitter)
    controller_test_log_in(user)
    get welcome_index_url
    assert_redirected_to(home_user_path(user))
  end

  test "not logged in should get welcome" do
    get welcome_index_url
    assert_response :success

    # TODO: This sort of check should be in a system test.
    # assert_no_select "nav#test-top-menu", "Found top menu" # When using display: none style, it renders as the div with nothing in it
    # #		  assert_select 'div#sign-in-with', /.*Already registered? Sign in with.*/, "Missing or wrong sign-in header" do
    # assert_select "div#sign_in_with", nil, "Missing or wrong sign-in header" do
    #   assert_select "a[href='/auth/twitter']", nil, "Missing link"
    # end
  end
end
