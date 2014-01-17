=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "logged in should get user home" do
    uid = users(:existing_twitter).id
    session[:user_id] = uid
    get :index
    assert_redirected_to(home_user_path(uid))
  end
  
  test "not logged in should get welcome" do
    get :index
    assert_response :success

    assert_select 'div#top_menu', false, message("Found top menu") # When using display: none style, it renders as the div with nothing in it
#		  assert_select 'div#sign-in-with', /.*Already registered? Sign in with.*/, "Missing or wrong sign-in header" do
	  assert_select 'div#sign-in-with', nil, "Missing or wrong sign-in header" do
	    assert_select 'a[href=/auth/twitter]', nil, "Missing link"
	  end
  end
end

