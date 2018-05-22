# frozen_string_literal: true

require "application_system_test_case"

class CompletedRoutinesTest < ApplicationSystemTestCase
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
  #
  # def wrapper
  #   get_logged_in(:existing_google)
  #   patient_one = people(:patient_one)
  #   assert_equal person_path(patient_one), current_path
  #   click_link("New Observations")
  #   yield
  #   click_on "Save"
  # end
end
