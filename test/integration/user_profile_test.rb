=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  test "Unlink a user" do
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
    click_on('Google')
    assert_equal home_user_path(user), current_path
    click_on('Profile')
    assert_equal edit_user_path(user), current_path
    assert has_selector?('.link'), "Missing the links"
    # There are 8 completed routines at this point, but we set the maximum to display to 5.
    assert_difference "Link.all.count", -2 do
      all('a', :text => 'Unlink').first.click
      assert_equal edit_user_path(user), current_path
    end
    
    all('a', :text => 'Edit').first.click
    assert_equal edit_person_path(user.people.first)
  end
end

