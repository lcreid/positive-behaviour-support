# frozen_string_literal: true

require "test_helper"

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    controller_test_log_in(users(:user_invitor))
    get new_invitation_url
    assert_response :success
  end
end
