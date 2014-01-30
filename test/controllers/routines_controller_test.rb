require 'test_helper'

class RoutinesControllerTest < ActionController::TestCase
  test "try to delete a routine when not logged in" do
    assert_raise ActionController::RoutingError do
      delete :destroy, id: routines(:clean_up_room)
    end
  end
  
  test "try to delete a routine when not allowed" do
    @controller.log_in(users(:user_marie))
    assert_raise ActionController::RoutingError do
      delete :destroy, id: routines(:routine_index_two)
    end
  end
  
  test "delete a routine" do
    @controller.log_in(users(:user_marie))
    
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/user/edit'
        
    assert_difference "Routine.all.count", -1 do
      delete :destroy, id: routines(:clean_up_room).id
    end
    assert_redirected_to :back
  end

  test "try to edit a routine when not logged in" do
    assert_raise ActionController::RoutingError do
      get :edit, id: routines(:clean_up_room)
    end
  end
  
  test "try to edit a routine when not allowed" do
    @controller.log_in(users(:user_marie))
    assert_raise ActionController::RoutingError do
      get :edit, id: routines(:routine_index_two)
    end
  end
  
  test "edit a routine" do
    @controller.log_in(users(:user_marie))
    
    get :edit, id: routines(:clean_up_room)
    assert_response :success
    assert_not_nil assigns(:routine)
  end

  test "try to update a routine when not logged in" do
    routine = routines(:clean_up_room)
    assert_raise ActionController::RoutingError do
      post :update, id: routine.id, routine: { name: "New Name" }
    end
  end
  
  test "try to update a routine when not allowed" do
    @controller.log_in(users(:user_marie))
    routine = routines(:routine_index_two)
    assert_raise ActionController::RoutingError do
      post :update, id: routine.id, routine: { name: "New Name" }
    end
  end
  
  test "update a routine" do
    @controller.log_in(user = users(:user_marie))
    person = people(:patient_matt)
    routine = routines(:clean_up_room)
    
    expectation = routine.expectations.first
    
    original_routine_name = routine.name
    
    assert_no_difference "person.routines.count" do
      assert_no_difference "Expectation.all.count" do
        post :update, 
          id: routine.id, 
          routine: { name: "New Name",
            expectations_attributes: [{description: "new description", id: expectation.id}] }
      end
    end
    assert_redirected_to edit_person_path(person)
    
    db_routine = Routine.find(routine.id)
    refute_equal original_routine_name, db_routine.name
  end
  
  test "show page to create a new routine" do
    @controller.log_in(user = users(:user_marie))
    person = people(:patient_matt)
    
    get :new, person: { id: person.id }
    assert_response :success
    assert_not_nil assigns(:routine)
  end
  
  test "create a routine" do
    @controller.log_in(user = users(:user_marie))
    person = people(:patient_matt)
    
    assert_difference "person.routines.count" do
      assert_difference "Expectation.all.count" do
        post :create, routine: { name: "New Name", person_id: person.id, expectations_attributes: ["description" => "one"] }
      end
    end
    assert_redirected_to edit_person_path(person)
  end
end
