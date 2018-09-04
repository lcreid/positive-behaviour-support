# frozen_string_literal: true

require "application_system_test_case"

class UserProfileTest < ApplicationSystemTestCase
  test "Unlink a user" do
    get_logged_in(:user_marie)
    click_link("Profile")
    assert_equal edit_user_path(@user), current_path
    assert has_selector?(".user"), "Missing the links"
    assert_difference "Link.all.count", -2 do
      all("a", text: "Unlink").first.click
      assert_equal edit_user_path(@user), current_path
    end
  end
end
