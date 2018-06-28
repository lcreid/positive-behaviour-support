# frozen_string_literal: true

require "application_system_test_case"

class PersonProfileTest < ApplicationSystemTestCase
  test "Add a person" do
    get_logged_in(:user_marie)

    assert_difference "Link.count", 2 do
      click_link("New Team")
      assert_equal new_person_path, current_path
      click_on("Save")
    end
    assert_equal person_path(@user.people.last), current_path
  end

  test "Add a person but cancel out" do
    get_logged_in(:user_marie)

    assert_no_difference "Link.count" do
      click_link("New Team")
      assert_equal new_person_path, current_path
      click_link("Cancel")
    end
    assert_equal home_user_path(@user), current_path
  end

  test "Change the short name of a person" do
    get_logged_in(:user_marie)

    assert_no_difference "Link.count" do
      all("li.list-group-item a").first.click
      click_on "Edit Subject"
      fill_in "Short name", with: "New Name"
      click_on("Save")
    end
    # assert_equal home_user_path(@user), current_path
    assert_content "New Name"
  end
end
