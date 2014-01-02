require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @controller.env = { "omniauth.auth" => 
      {"provider" => users(:existing_twitter).provider, 
      "uid" => users(:existing_twitter).uid, 
      "info" => {"nickname" => users(:existing_twitter).name}}}
  end
  
  test "log in" do
    get :create
    assert_redirected_to home_user_path(users(:existing_twitter))
  end
  
  test "log out" do
    get :create
    get :destroy
    assert_redirected_to root_url
  end
end
