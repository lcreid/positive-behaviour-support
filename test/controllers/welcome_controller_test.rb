# frozen_string_literal: true

require "test_helper"

class WelcomeControllerTest < ActionController::TestCase
  test "logged in should get user home" do
    uid = users(:existing_twitter).id
    session[:user_id] = uid
    get :index
    assert_redirected_to(home_user_path(uid))
  end

  test "not logged in should get welcome" do
    get :index
    assert_response :success

    # TODO: This sort of check should be in a system test.
    # assert_no_select "nav#test-top-menu", "Found top menu" # When using display: none style, it renders as the div with nothing in it
    # #		  assert_select 'div#sign-in-with', /.*Already registered? Sign in with.*/, "Missing or wrong sign-in header" do
    # assert_select "div#sign_in_with", nil, "Missing or wrong sign-in header" do
    #   assert_select "a[href='/auth/twitter']", nil, "Missing link"
    # end
  end
end
