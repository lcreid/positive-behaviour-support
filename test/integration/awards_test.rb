=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class AwardsTest < ActionDispatch::IntegrationTest
  test "invalid integer" do
    # FIXME: Removed going to 5.0
    skip
    wrapper do
      fill_in 'number_of_rewards', with: "1.5"
    end
    assert_page_has_content "Number of rewards is not an integer"
  end

  def wrapper
    user = get_logged_in(:user_marie)
    matt = people(:patient_matt)
    click_link matt.short_name
    assert_equal person_path(matt), current_path
    click_link "Give Reward"
    yield
    click_on "Give Reward!"
  end
end
