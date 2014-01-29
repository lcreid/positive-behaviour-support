=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "get logged in user" do
    user = users(:user_marie)
    uid = user.id
    session[:user_id] = uid
    get :home, {id: @controller.current_user.id}
    assert :success
    
    patient = user.people[0]
    
    assert_select 'div#user-name' do
      assert_select 'h1', "Marie"
    end
    assert_select 'div#top_menu', /.*Marie.*/
    assert_select 'div#patients' do
      assert_select 'div.person', 2 do |pt|
        assert_select pt[0], 'h1', "Matt-Patient"
        assert_select pt[0], 'h2' do |h2|
          assert_select h2[0], 'h2', "Routines"
          assert_select h2[1], 'h2', "Rewards"
        end

        assert_select pt[0], '.routines table tbody tr', 3
      
        assert_select pt[0], 'div.pending_rewards table' do
          assert_select 'tbody tr', 2 do |reward|
            assert_select reward[0], 'td', "Time Off"
            assert_select reward[1], 'td', "Nothing"
            
            assert_select reward[0], "a[href=#{new_award_path(goal_id: patient.goals[0].id)}]"
            assert_select reward[1], "a", false
          end 
        end

        assert_select pt[1], 'h1', "Max-Patient"
        assert_select pt[1], 'h2', "Routines"
        assert_select pt[1], 'tbody tr', 2 do |p|
          assert_select p[0], 'td', /^Go to bed.*/
          assert_select p[0], 'a', "Add New"
          assert_select p[1], 'td', /^Turn off Minecraft.*/
          assert_select p[1], 'a', "Add New"
        end
      end
    end
    assert_select 'div#users' do
      assert_select 'h1', "Connections"
      assert_select 'tbody tr', 2 
    end
  end
  
  test "get not logged in user" do
    uid = users(:existing_twitter).id
    assert_raise ActionController::RoutingError do
      get :home, {id: uid}
    end
  end
  
  test "get other user" do
    uid = users(:existing_twitter).id
    session[:user_id] = uid
    assert_raise ActionController::RoutingError do
      get :home, {id: 0}
    end
  end
  
  test "profile page" do
    uid = users(:user_marie).id
    session[:user_id] = uid
    
    get :edit, id: uid
    
    assert_select '#people'
    assert_select '.link', 4
    assert_select '.link a', 6
  end
end
