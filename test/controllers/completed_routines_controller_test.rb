# frozen_string_literal: true

require "test_helper"

class CompletedRoutinesControllerTest < ActionController::TestCase
  test "get a new completed routine form to complete" do
    @controller.log_in(users(:user_marie))
    assert_no_difference "CompletedRoutine.count" do
      get :new, params: { routine_id: routines(:turn_off_minecraft) }
    end

    #    puts @response.body

    assert_select "h1", "Turn off Minecraft -- Max-Patient"
    # There are three rows, plus a row for each routine
    assert_select ".new_completed_routine .row", 5
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
      get :new, params: { routine_id: routines(:belongs_to_no_one) }
    end
  end

  test "complete a routine" do
    @controller.log_in(user = users(:user_marie))
    r = routines(:turn_off_minecraft)
    expectations = r.expectations.map(&:description).sort

    good_day = "Good day!"
    completed_routine = {
      completed_routine: {
        routine_id: r.id.to_s,
        person_id: r.person_id,
        name: r.name,
        comment: good_day,
        routine_done_at_date: "2014-01-23",
        routine_done_at_time: "00:30",
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
    }
    assert_difference "CompletedRoutine.count" do
      post :create, params: completed_routine
    end
    assert cr = CompletedRoutine
                .where(routine_id: r.id)
                .order(:updated_at)
                .last, "No completed routines for user #{user.name}"
    assert_redirected_to person_path(cr.person)
    assert_equal r.id, cr.routine_id
    assert_equal r.person_id, cr.person_id
    assert_equal r.name, cr.name
    assert_equal good_day, cr.comment
    assert_equal 2, cr.completed_expectations.size
    assert_equal expectations, cr.completed_expectations.map(&:description).sort
    assert_equal Time.zone.local(2014, 1, 23, 0, 30), cr.routine_done_at
  end
end
