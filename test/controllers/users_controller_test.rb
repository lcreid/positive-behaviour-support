require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "get logged in user" do
    uid = users(:existing_twitter).id
    session[:user_id] = uid
    get :home, {id: @controller.current_user.id}
    assert :success
    
    assert_select 'div#user-name', "One Twitter"
    assert_select 'div#top-menu', /.*One Twitter.*/
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
