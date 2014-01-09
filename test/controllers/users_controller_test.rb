require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "get logged in user" do
    uid = users(:user_marie).id
    session[:user_id] = uid
    get :home, {id: @controller.current_user.id}
    assert :success
    
    assert_select 'div#user-name' do
      assert_select 'h1', "Marie"
    end
    assert_select 'div#top-menu', /.*Marie.*/
    assert_select 'div#patients' do
      assert_select 'h1', "Routines"
      assert_select 'p', 7 do |p|
        assert_select p[0], 'p', "Matt-Patient"
        assert_select p[4], 'p', "Max-Patient"
        assert_select p[5], 'a', "Go to bed"
        assert_select p[6], 'a', "Turn off Minecraft"
      end
    end
    assert_select 'div#users' do
      assert_select 'h1', "Connections"
      assert_select 'p', 2 
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
end
