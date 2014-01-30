=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class PersonProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_marie)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      "provider" => 'google_oauth2',
      "uid" => @user.uid.to_s,
      "name" => @user.name
    })

    visit(root_path)
    # It looks like if you don't sign out at the end of each test case,
    # the test case will start off still logged in.
    # I guess that's sort of desirable, so you don't have to keep logging in.
    click_on('Sign out') if has_link? ("Sign out")
    assert_equal root_path, current_path
    
    click_on('Google')
    assert_equal home_user_path(@user), current_path
  end
    
  test "Add a routine" do
    visit(edit_person_path(@user.people.last))
    click_link('Add Routine')
    assert_equal new_routine_path, current_path
  end
  
  test "Add a goal" do
    visit(edit_person_path(@user.people.last))
    click_link('Add Goal')
    assert_equal new_goal_path, current_path
  end
end

