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
        routine_done_at_date: "2014-01-23",
        routine_done_at_time: "12:30 AM",
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
    assert_equal Time.zone.local(2014, 01, 23, 00, 30), cr.routine_done_at
  end
  
  test "show report of completed routines" do
    skip # TODO Put this back in.
    @controller.log_in(user = users(:user_sharon))
    patient = people(:person_marty)
    get :report, person_id: patient.id
    assert :success
    
#    puts @response.body

    assert_select 'tr:nth-of-type(1) th', 4
    assert_select 'tr:nth-of-type(2) th', 4 # Don't count the rowspan
    assert_select 'tr:nth-of-type(1) td', 7 # Even though the : is on the tr, the count is for the whole selector
    assert_select 'tr:nth-of-type(2) td', 7 
    assert_select 'tr:nth-of-type(3) td', 7
    assert_select 'tr:nth-of-type(4) td', 7
    assert_select 'tr:nth-of-type(5) td', 7
    assert_select 'tr:nth-of-type(6) td', 7
#    assert_select 'tr.completed_routine', 6 do |row|
#      assert_select row[0], 'td', 4
#      assert_select row[1], 'td', 4
#      assert_select row[2], 'td', 4
#      assert_select row[3], 'td', 4
#      # The following suck because it depends on the order that my test data comes 
#      assert_select row[0], 'td:last-of-type tr', 3, "Row 1"
#      assert_select row[1], 'td:last-of-type tr', 3, "Row 2"
#      assert_select row[2], 'td:last-of-type tr', 2, "Row 3"
#      assert_select row[3], 'td:last-of-type tr', 3, "Row 4"
      
#      assert_select row[0], 'td:nth-of-type(2)', "Not part of routine"
#      assert_select row[0], 'td:nth-of-type(4)', "Not part of routine"
#      assert_select row[1], 'td:nth-of-type(3)', "Not part of routine"
#      assert_select row[2], 'td:nth-of-type(4)', "Not part of routine"
#      assert_select row[3], 'td:nth-of-type(1)', "Not part of routine"
#    end
  end
end
