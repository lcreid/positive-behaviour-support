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
end
