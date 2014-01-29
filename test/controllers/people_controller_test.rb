require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
#  test "try to delete a person without a link" do
#    @controller.log_in(users(:existing_linkedin))
#    assert_raise ActionController::ParameterMissing do
#      delete :destroy, id: nil
#    end
#  end
  
  test "try to delete a person when not logged in" do
    assert_raise ActionController::RoutingError do
      delete :destroy, id: people(:patient_two)
    end
  end
  
  test "try to delete a person when not allowed" do
    @controller.log_in(users(:existing_linkedin))
    assert_raise ActionController::RoutingError do
      delete :destroy, id: people(:patient_one)
    end
  end
  
  test "delete a person" do
    @controller.log_in(users(:existing_linkedin))
    
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/user/edit'
        
    assert_difference "Person.all.count", -1 do
      delete :destroy, id: people(:patient_two)
    end
    assert_redirected_to :back
  end

#  test "try to edit a person without a link" do
#    @controller.log_in(users(:existing_linkedin))
#    assert_raise ActionController::ParameterMissing do
#      get :edit, id: nil
#    end
#  end
  
  test "try to edit a person when not logged in" do
    assert_raise ActionController::RoutingError do
      get :edit, id: people(:patient_two)
    end
  end
  
  test "try to edit a person when not allowed" do
    @controller.log_in(users(:existing_linkedin))
    assert_raise ActionController::RoutingError do
      get :edit, id: people(:patient_one)
    end
  end
  
  test "edit a person" do
    @controller.log_in(users(:existing_linkedin))
    
    get :edit, id: people(:patient_two)
    assert_response :success
    assert_not_nil assigns(:person)
  end

#  test "try to update a person without a link" do
#    @controller.log_in(users(:existing_linkedin))
#    assert_raise ActionController::ParameterMissing do
#      post :update, id: nil
#    end
#  end
  
  test "try to update a person when not logged in" do
    person = people(:patient_two)
    assert_raise ActionController::RoutingError do
      post :update, id: person.id, person: { name: "New Name" }
    end
  end
  
  test "try to update a person when not allowed" do
    @controller.log_in(users(:existing_linkedin))
    person = people(:patient_one)
    assert_raise ActionController::RoutingError do
      post :update, id: person.id, person: { name: "New Name" }
    end
  end
  
  test "update a person" do
    @controller.log_in(user = users(:existing_linkedin))
    
    @request.env['HTTP_REFERER'] = 'http://test.hostperson/edit'
    
    person = people(:patient_two)
    original_person_name = person.name
    
    post :update, id: person.id, person: { name: "New Name" }
    assert_redirected_to edit_user_path(user)
    
    db_person = Person.find(person.id)
    refute_equal original_person_name, db_person.name
  end
  
  test "show page to create a new person" do
    @controller.log_in(user = users(:existing_linkedin))
    
    get :new, creator_id: user.id
    assert_response :success
    assert_not_nil assigns(:person)
  end
  
  test "create a person" do
    @controller.log_in(user = users(:existing_linkedin))
    
    assert_difference "user.people.count" do
      post :create, person: { name: "New Name", creator_id: user.id }
      assert_redirected_to edit_user_path(user)
    end
  end
end
