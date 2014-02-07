=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  test "browse to home page" do
    user = users(:existing_twitter)
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      "provider" => 'twitter',
      "uid" => user.uid.to_s,
      "info" => { "nickname" => user.name }
    })
    visit(root_path)
    click_on('Twitter')
    assert_equal home_user_path(user), current_path
  end

  test "browse to home page and review latest routines for patient" do
    user = get_logged_in(users(:user_marie))
    matt = people(:patient_matt)
    
    click_link('Matt-Patient')
    assert_equal person_path(matt), current_path
    assert has_selector?('div.completed_routines'), "Missing the completed routines"
    # There are 8 completed routines at this point, but we set the maximum to display to 5.
    assert_difference "CompletedRoutine.all.count" do
      assert has_selector?('div.completed_routines tbody tr', count: before = 5), "Unexpected completed routines"
      all('a', :text => 'New Observations').first.click
      assert_equal new_completed_routine_path, current_path
      all('tbody tr') do |row|
        row.within {choose('observation_y')}
      end
      click_button('Save')
      assert_equal person_path(matt), current_path
    end
    # assert has_selector?('div.completed_routines tbody tr', count: before + 1), "Missing completed routine row"
  end
end

