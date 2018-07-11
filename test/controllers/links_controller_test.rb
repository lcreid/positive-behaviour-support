# frozen_string_literal: true

require "test_helper"

class LinksControllerTest < ActionDispatch::IntegrationTest
  #  test "try to delete links without a link" do
  #    controller_test_log_in(users(:user_marie))
  #    assert_raise ActionController::ParameterMissing do
  #      delete link_url(nil)
  #    end
  #  end

  test "try to delete links when not logged in" do
    assert_raise ActionController::RoutingError do
      delete link_url(links(:user_marie_to_matt))
    end
  end

  test "try to delete links when not allowed" do
    controller_test_log_in(users(:user_marie))
    assert_raise ActionController::RoutingError do
      delete link_url(links(:user_to_four))
    end
  end

  test "delete links" do
    controller_test_log_in(users(:user_marie))

    @request.env["HTTP_REFERER"] = "http://localhost:3000/user/edit"

    assert_difference "Link.all.count", -2 do
      delete link_url(links(:user_marie_to_matt))
    end
    # FIXME: Removed to get rid of deprecation
    # assert_redirected_to :back
  end
end
