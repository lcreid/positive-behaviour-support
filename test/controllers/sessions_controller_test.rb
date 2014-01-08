require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @controller.env = { "omniauth.auth" => 
      {"provider" => users(:existing_twitter).provider, 
      "uid" => users(:existing_twitter).uid, 
      "info" => {"nickname" => users(:existing_twitter).name}}}
  end
  
  test "log in" do
    assert_no_difference "User.count + Person.count + Link.count" do
      get :create
    end
    assert_redirected_to home_user_path(users(:existing_twitter))
  end
  
  test "log out" do
    get :create
    get :destroy
    assert_redirected_to root_url
  end
  
  test "new user gets training patients" do
    @controller.env = { "omniauth.auth" => 
      {"provider" => "Training", 
      "uid" => "1001", 
      "info" => {"nickname" => "New User"}}}
    assert_difference "User.count", 2 do
      get :create
    end
    u = User.find_by(uid: "1001")
    assert_equal 2, u.patients.size
    assert_equal 1, u.users.size
    assert_redirected_to home_user_path(u)
  end
end
