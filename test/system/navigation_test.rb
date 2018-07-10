# frozen_string_literal: true

require "application_system_test_case"

# Try to keep the testing of links, aka the path through the app, in here,
# and just visit pages in the other test cases. See if this makes the other
# test cases less fragile when trying different navigation options.
class NavigationTest < ApplicationSystemTestCase
  test "navigation" do
    get_logged_in(:existing_google)
    patient_one = people(:patient_one)
    assert_equal person_path(patient_one), current_path
    click_on "Single team routine"
    assert_equal new_completed_routine_path, current_path
  end

  test "add a routine" do
    get_logged_in(:user_marie)
    subject = @user.people.last
    visit(person_path(subject))
    click_on "Edit Subject"
    click_link("New Routine")
    assert_selector "h4", text: "New Routine"
    click_on "Cancel"
    assert_field "Name", with: subject.name
    click_link("New Routine")
    assert_selector "h4", text: "New Routine"
    # TODO: Fix new routine to be nested then use assert_current_path
    assert_equal new_routine_path, current_path
    click_on "Save"
    assert_field "Name", with: subject.name
    assert_current_path edit_person_path(subject)
  end

  test "add a goal" do
    get_logged_in(:user_marie)
    subject = @user.people.last
    visit(person_path(subject))
    click_on "Edit Subject"
    assert_current_path edit_person_path(subject)
    click_link("New Goal")
    assert_selector "h4", text: "New Goal"
    assert_equal new_person_goal_path(subject), current_path
    click_on "Cancel"
    assert_field "Name", with: subject.name
    assert_current_path edit_person_path(subject)
    click_link("New Goal")
    assert_selector "h4", text: "New Goal"
    fill_in "Goal Name", with: "gol gol gol"
    click_on "Save"
    assert_field "Name", with: subject.name
    assert_current_path edit_person_path(subject)
  end
end
