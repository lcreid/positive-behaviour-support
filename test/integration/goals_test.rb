=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class GoalsTest < ActionDispatch::IntegrationTest
  test "blank name" do
    wrapper do
      fill_in 'Target', with: "2"
    end
    page.must_have_content "Name can't be blank"
  end
  
  test "non-numeric target" do
    wrapper do
      fill_in 'Name', with: "Test name"
      fill_in 'Target', with: "3.2"
    end
    page.must_have_content "Target must be an integer"
  end
  
  test "non-numeric target on existing" do
    user = get_logged_in(:user_sharon)
    marty = people(:person_marty)
    assert_equal person_path(marty), current_path
    click_link("Edit Goal")
    assert_equal edit_goal_path(marty.goals.first), current_path
    fill_in 'Target', with: "3.2"
    click_on "Save"
    page.must_have_content "Target must be an integer"
  end
  
  def wrapper
    user = get_logged_in(:existing_google)
    patient_one = people(:patient_one)
    assert_equal person_path(patient_one), current_path
    click_link("New Goal")
    assert_equal new_person_goal_path(patient_one), current_path
    yield
    click_on "Save"
  end
end

