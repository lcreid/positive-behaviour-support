=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @controller.env = { "omniauth.auth" => 
      {"provider" => users(:existing_twitter).provider, 
      "uid" => users(:existing_twitter).uid, 
      "info" => {"nickname" => users(:existing_twitter).name}},
      "omniauth.params" =>
      {"time_zone" => "Samoa"}
      }
  end
  
  test "log in" do
    assert_no_difference "User.count + Person.count + Link.count" do
      get :create
    end
    assert_redirected_to home_user_path(u = users(:existing_twitter))
    assert_equal "Samoa", u.reload.time_zone
    assert !flash.notice.blank?, "Flash was blank."
  end
  
  test "log out" do
    get :create
    get :destroy
    assert_redirected_to root_url
  end
  
  test "new user gets training patients" do
    @controller.env = { "omniauth.auth" => 
      {"provider" => "Training", 
      "uid" => "1001", 
      "info" => {"nickname" => "New User"}},
      "omniauth.params" =>
      {"time_zone" => "Samoa"}
      }
    assert_difference "User.count", 2 do
      get :create
    end
    u = User.find_by(uid: "1001")
    assert_equal 2, u.patients.size
    assert_equal 3, u.patients[0].routines.size
    assert_equal 1, u.patients[0].routines[0].expectations.size
    assert_equal 1, u.patients[0].routines[1].expectations.size
    assert_equal 2, u.patients[0].routines[2].expectations.size
    assert_equal 2, u.patients[1].routines.size
    assert_equal 2, u.patients[1].routines[0].expectations.size
    assert_equal 3, u.patients[1].routines[1].expectations.size
    assert_equal 1, u.users.size
    assert_redirected_to home_user_path(u)
    assert_equal "Samoa", u.time_zone
    assert !flash.notice.blank?, "Flash was blank."
  end
end
