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
    # It looks like if you don't sign out at the end of each test case,
    # the test case will start off still logged in.
    # I guess that's sort of desirable, so you don't have to keep logging in.
    click_on('Sign out') if has_link? ("Sign out")
    assert_equal root_path, current_path
    
    user = users(:user_marie)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      "provider" => 'google_oauth2',
      "uid" => user.uid.to_s,
      "name" => user.name
    })
    visit(root_path)
    assert page.has_link?("Twitter"), "No Twitter link."
    assert page.has_link?("Google"), "No Google link."
    click_on('Google')
    assert_equal home_user_path(user), current_path
    assert has_selector?('div.completed_routines'), "Missing the completed routines"
    assert has_selector?('div.completed_routines tbody tr', count: before = 8), "Unexpected completed routines"
    all('a', :text => 'Add New').first.click
    assert_equal new_completed_routine_path, current_path
    all('tbody tr') do |row|
      row.within {choose('observation_y')}
    end
    click_button('Create')
    assert_equal home_user_path(user), current_path
    assert has_selector?('div.completed_routines tbody tr', count: before + 1), "Missing completed routine row"
  end
end

