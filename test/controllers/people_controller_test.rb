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
    original_person_name = person.short_name
    
    post :update, id: person.id, person: { name: "New Name" }
    assert_redirected_to edit_user_path(user)
    
    db_person = Person.find(person.id)
    refute_equal original_person_name, db_person.short_name
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
  
  test "Format of person dashboard (Matt)" do
    @controller.log_in(user = users(:user_marie))
    
    subject = people(:patient_matt)
    get :show, id: subject.id
    assert_response :success
     
    assert_select 'div#patients' do |pt|
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
          
          assert_select reward[0], "a[href=#{new_award_path(goal_id: subject.goals[0].id)}]"
          assert_select reward[1], "a", false
        end 
      end
    end
  end
  
  test "Format of person dashboard (Max)" do
    @controller.log_in(user = users(:user_marie))
    
    subject = people(:patient_max)
    get :show, id: subject.id
    assert_response :success
     
    assert_select 'div#patients' do |pt|
      assert_select pt[0], 'h1', "Max-Patient"
      assert_select pt[0], 'h2', "Routines"
      assert_select pt[0], 'tbody tr', 2 do |p|
        assert_select p[0], 'td', /^Go to bed.*/
        assert_select p[0], 'a', "Add New"
        assert_select p[1], 'td', /^Turn off Minecraft.*/
        assert_select p[1], 'a', "Add New"
      end
    end
  end
end
