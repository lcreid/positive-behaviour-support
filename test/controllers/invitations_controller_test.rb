require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  test "should get new" do
  	@controller.log_in(users(:user_invitor))
    get :new
    assert_response :success
  end
end
