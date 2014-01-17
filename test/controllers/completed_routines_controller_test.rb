=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class CompletedRoutinesControllerTest < ActionController::TestCase
  test "get a new completed routine form to complete" do
    @controller.log_in(users(:user_marie))
    assert_no_difference "CompletedRoutine.count" do
      get :new, { routine_id: routines(:turn_off_minecraft) }
    end
    
#    puts @response.body
    
    assert_select 'div#completed_routine_header', "Turn off Minecraft -- Max-Patient"
    assert_select 'tbody tr', 2
  end
  
  test "try to get a new completed routine without routine_id" do
    @controller.log_in(users(:user_marie))
    assert_raise ActionController::ParameterMissing do
      get :new
    end
  end
  
  test "try to get a new completed routine when not logged in" do
    assert_raise ActionController::RoutingError do
      get :new
    end
  end
  
  test "try to get a new completed routine when not allowed access to the routine" do
    @controller.log_in(users(:user_marie))
    assert_raise ActionController::RoutingError do
      get :new, { routine_id: routines(:belongs_to_no_one) }
    end
  end
  
  test "complete a routine" do
    @controller.log_in(user = users(:user_marie))
    r = routines(:turn_off_minecraft)
    expectations = r.expectations.collect { |e| e.description }
    
    good_day = "Good day!"
    completed_routine = ActionController::Parameters.new(
      completed_routine: {
        routine_id: r.id.to_s, 
        person_id: r.person_id, 
        name: r.name, 
        comment: good_day,
        completed_expectations_attributes: {
          "0" => { 
            observation: "Y", 
            comment: "Yay!", 
            description: expectations[0]
          },
          "1" => { 
            observation: "N", 
            comment: "Boo!", 
            description: expectations[1]
          }
        }
      }
    )
    assert_difference "CompletedRoutine.count" do
      post :create, completed_routine
    end
    assert_redirected_to home_user_path(@controller.current_user)
    assert cr = CompletedRoutine.
      where(routine_id: r.id).
      order(:updated_at).
      last, "No completed routines for user #{user.name}"
    assert_equal r.id, cr.routine_id
    assert_equal r.person_id, cr.person_id
    assert_equal r.name, cr.name
    assert_equal good_day, cr.comment
    assert_equal 2, cr.completed_expectations.size
    assert_equal expectations[0], cr.completed_expectations[0].description
    assert_equal expectations[1], cr.completed_expectations[1].description
  end
  
  test "show index of completed routines" do
    @controller.log_in(user = users(:user_marie))
    
  end
end
