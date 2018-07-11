# frozen_string_literal: true

require "application_system_test_case"

class CompletedRoutinesTest < ApplicationSystemTestCase
  include ApplicationHelper
  # It appears to be impossible to force the wrong data into the control.
  # test "invalid date" do
  #   wrapper do
  #     fill_in "completed_routine_routine_done_at", with: "02302014\t23:50"
  #   end
  #   assert_content "Routine done at is not a valid datetime"
  # end
  #
  # test "invalid time" do
  #   wrapper do
  #     fill_in "completed_routine_routine_done_at", with: "02282014\t23:61"
  #   end
  #   assert_content "Routine done at is not a valid datetime"
  # end

  test "complete a routine" do
    wrapper do
      within(".#{css_test_class('Get pencils, pens, etc.')}") { choose "Y" }
      within(".#{css_test_class('Put away pencils, pens, etc.')}") { choose "Y" }
    end
  end

  test "edit a routine" do
    get_logged_in(:user_marie)
    completed_routine = completed_routines(:matt_one_one)
    visit edit_completed_routine_path(completed_routine)
    within(".#{css_test_class('Do without reminder')}") do
      choose "N"
    end
    assert_no_difference "CompletedRoutine.count" do
      assert_no_difference "CompletedExpectation.count" do
        click_on "Save"
      end
    end
    assert(completed_routine.reload.completed_expectations.all { |ce| ce.observation == "N" })
  end

  def wrapper
    get_logged_in(:user_marie)
    patient_matt = people(:patient_matt)
    visit new_completed_routine_path(routine_id: patient_matt.routines.find_by(name: "Do homework").id)
    yield
    click_on "Save"
  end
end
