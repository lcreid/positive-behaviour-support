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
    get_logged_in(:user_marie)
    click_on('Profile')
    assert_equal edit_user_path(@user), current_path
    assert has_selector?('.link'), "Missing the links"
    # There are 8 completed routines at this point, but we set the maximum to display to 5.
    assert_difference "Link.all.count", -2 do
      all('a', :text => 'Unlink').first.click
      assert_equal edit_user_path(@user), current_path
    end
    
    all('a', :text => 'Edit').first.click
    assert_equal edit_person_path(@user.people(true).first), current_path
    click_link('Cancel')
    assert_equal edit_user_path(@user), current_path
  end
  
  test "Add a person" do
    get_logged_in(:user_marie)
    click_on('Profile')
    assert_equal edit_user_path(@user), current_path

    assert_difference "Link.all.count", 2 do
      click_link('Add Person')
      assert_equal new_person_path, current_path
      click_on('Save')
    end
    assert_equal edit_user_path(@user), current_path
  end
end

