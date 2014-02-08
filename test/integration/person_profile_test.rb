=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class PersonProfileTest < ActionDispatch::IntegrationTest
  test "Add a person" do
    get_logged_in(:user_marie)
    matt = people(:patient_matt)
    
    assert_difference "Link.all.count", 2 do
      click_link('New Team')
      assert_equal new_person_path, current_path
      click_on('Save')
    end
    assert_equal person_path(@user.people.last), current_path
  end
  
  test "Add a person but cancel out" do
    get_logged_in(:user_marie)
    matt = people(:patient_matt)
    
    assert_no_difference "Link.all.count" do
      click_link('New Team')
      assert_equal new_person_path, current_path
      click_link('Cancel')
    end
    assert_equal home_user_path(@user), current_path
  end
end

