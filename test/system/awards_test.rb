# frozen_string_literal: true

require "application_system_test_case"

class AwardsTest < ApplicationSystemTestCase
  test "invalid integer" do
    skip "The modern number control doesn't let me generate failures here"
    wrapper do
      fill_in "number_of_rewards", with: "1.5"
    end
    # The modern browser controls put up their own validation message, which doesn't appear to be HTML.
    assert_content "Please enter a valid value. The two nearest valid values are 1 and 2."
    # Original assertion
    # assert_content "Number of rewards is not an integer"
  end

  def wrapper
    get_logged_in(:user_marie)
    matt = people(:patient_matt)
    click_link matt.short_name
    assert_equal person_path(matt), current_path
    click_link "Give Reward"
    yield
    click_on "Give Reward!"
  end
end
