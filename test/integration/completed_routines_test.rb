=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class CompletedRoutinesTest < ActionDispatch::IntegrationTest
  test "invalid date" do
    wrapper do
      fill_in 'completed_routine_routine_done_at', with: "2014-02-30 23:50"
    end
    assert_page_has_content "Routine done at is not a valid datetime"
  end

  test "invalid time" do
    wrapper do
      fill_in 'completed_routine_routine_done_at', with: "2014-02-28 23:61"
    end
    assert_page_has_content "Routine done at is not a valid datetime"
  end

  def wrapper
    user = get_logged_in(:existing_google)
    patient_one = people(:patient_one)
    assert_equal person_path(patient_one), current_path
    click_link("New Observations")
    yield
    click_on "Save"
#    puts body
  end
end
