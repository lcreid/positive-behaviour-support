# frozen_string_literal: true

require "application_system_test_case"

class HomePageTest < ApplicationSystemTestCase
  test "browse to home page" do
    user = users(:existing_twitter)
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new("provider" => "twitter",
                                                                 "uid" => user.uid.to_s,
                                                                 "info" => { "nickname" => user.name })
    visit(root_path)
    click_on("Sign out") if has_link? "Sign out"
    click_on("Twitter")
    sleep 2
    assert_equal home_user_path(user), current_path
  end

  test "browse to home page and review latest routines for patient" do
    get_logged_in(users(:user_marie))
    matt = people(:patient_matt)

    click_link("Matt-Patient")
    assert_equal person_path(matt), current_path
    assert has_selector?("div.completed_routines"), "Missing the completed routines"
    # There are 8 completed routines at this point. The paginator is set to show 15 at a time.
    assert_difference "CompletedRoutine.all.count" do
      assert has_selector?("div.completed_routines tbody tr", count: 8), "Unexpected completed routines"
      within(".routines") { click_on "Brush teeth" }
      assert_equal new_completed_routine_path, current_path
      choose("Y")
      click_button("Save")
      assert_equal person_path(matt), current_path
    end
    # assert has_selector?('div.completed_routines tbody tr', count: before + 1), "Missing completed routine row"
  end
end
