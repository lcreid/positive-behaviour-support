# frozen_string_literal: true

require "application_system_test_case"

class GoalsTest < ApplicationSystemTestCase
  test "blank name" do
    wrapper do
      fill_in "Target", with: "2"
    end
    assert_text "Name can't be blank"
  end

  test "non-integer target" do
    skip "Using the numeric control with Chrome prevents user from entering invalid data."
    wrapper do
      fill_in "Name", with: "Test name"
      fill_in "Target", with: "3.2"
    end
    assert_text "Target must be an integer"
  end

  test "non-numeric target on existing" do
    skip "Using the numeric control with Chrome prevents user from entering invalid data."
    get_logged_in(:user_sharon)
    marty = people(:person_marty)
    assert_equal person_path(marty), current_path
    visit edit_goal_path(marty.goals.first)
    fill_in "Target", with: "3.2"
    click_on "Save"
    assert_text "Target must be an integer"
  end

  def wrapper
    get_logged_in(:existing_google)
    patient_one = people(:patient_one)
    assert_equal person_path(patient_one), current_path
    visit new_person_goal_path(patient_one)
    yield
    click_on "Save"
  end
end
