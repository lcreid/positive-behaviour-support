require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "new Twitter user" do
    nickname = "Twitter 1001"
    assert_difference("User.count") do
      User.from_omniauth("provider" => 'Twitter', "uid" => 1001, "info" => {"nickname" => nickname})
    end
    assert_equal nickname, User.where(uid: 1001).first.name
  end
  
  test "existing Twitter user" do
    assert_no_difference("User.count") do
      User.from_omniauth("provider" => users(:existing_twitter).provider, 
        "uid" => users(:existing_twitter).uid, 
        "info" => {"nickname" => users(:existing_twitter).name})
    end
  end
end
