# frozen_string_literal: true

require "application_system_test_case"

class TeamBuildingTest < ApplicationSystemTestCase
  test "cancel backwards from routine" do
    get_logged_in(:user_marie)

    person = people(:patient_matt)
    visit(home_user_path(@user))
    click_link("Matt-Patient")
    assert_equal person_path(person), current_path
    click_on "Edit Subject"
    click_link("New Routine")
    assert_equal new_routine_path, current_path
    click_link("Cancel")
    assert_equal person_path(person), current_path
  end

  test "save backwards from routine" do
    get_logged_in(:user_marie)

    person = people(:patient_matt)
    visit(edit_person_path(person))
    assert_current_path edit_person_path(person)
    click_link("New Routine")
    assert_equal new_routine_path, current_path
    fill_in "Name", with: "Capy add"
    # Can't add exepctation because I don't have Javascript support in Capybara yet.
    click_link "Add Expectation"
    # puts body
    # puts "Console: #{page.driver.console_messages}"
    # puts "Errors: #{page.driver.error_messages}"
    assert_selector("input[id*='description']")
    find("input[id$=_description]").set("Exp 1")
    assert_difference "Expectation.all.count" do
      assert_difference "person.routines.reload.count" do
        click_button("Save")
        assert_equal person_path(person), current_path
      end
    end
  end

  test "change team" do
    get_logged_in(:user_marie)
    matt = people(:patient_matt)
    click_link(matt.short_name)
    click_link("Edit Subject")
    check("Stella")
    assert_difference "matt.people.count" do
      click_button("Save")
    end
    assert_equal person_path(matt), current_path
    click_link("Edit Subject")
    uncheck("Stella")
    assert_difference "matt.people.count", -1 do
      click_button("Save")
    end
  end
end
