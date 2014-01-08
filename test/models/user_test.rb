require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "new Twitter user" do
    nickname = "Twitter 1001"
    assert ! User.from_omniauth_exists?("provider" => 'Twitter', "uid" => 1001, "info" => {"nickname" => nickname})
    assert_difference("User.count") do
      User.from_omniauth_or_create("provider" => 'Twitter', "uid" => 1001, "info" => {"nickname" => nickname})
    end
    assert_equal nickname, User.where(uid: 1001).first.name
  end
  
  test "existing Twitter user" do
    assert_no_difference("User.count") do
      User.from_omniauth_or_create("provider" => users(:existing_twitter).provider, 
        "uid" => users(:existing_twitter).uid, 
        "info" => {"nickname" => users(:existing_twitter).name})
    end
  end

  test "user one has one User link" do
    user = users(:existing_twitter)
    assert_equal 1, user.identities.size
    assert_equal 1, user.links.size
    assert_equal "User Two", user.links.first.person_b.name
  end
  
  test "user two has one Patient link" do
    user = users(:existing_google)
    assert_equal 1, user.links.size
    assert_equal "Patient One", user.links.first.person_b.name
  end

  test "user four has two links" do
    user = users(:existing_linkedin)
    assert_equal 2, user.links.size
  end

  test "user one has one User" do
    user = users(:existing_twitter)
    assert_equal 1, user.people.size
    assert_equal 1, user.users.size
    assert_equal "User Two", user.users.first.name
  end
  
  test "user two has one Patient" do
    user = users(:existing_google)
    assert_equal 1, user.people.size
    assert_equal 1, user.patients.size
    assert_equal "Patient One", user.patients.first.name
  end

  test "user four has one User and one Patient" do
    user = users(:existing_linkedin)
    assert_equal 2, user.people.size
    assert_equal 1, user.patients.size
    assert_equal 1, user.users.size
    assert_equal "Patient Two", user.patients.first.name
    assert_equal "User Three", user.users.first.name
  end
  
  test "user five has two identities and four people" do
    user = users (:user_marie)
    assert_equal 2, user.identities.size
    assert_equal 2, user.patients.size
    assert user.people.one? { |p| p.name == "Max-Patient" }
    assert user.people.one? { |p| p.name == "Matt-Patient" }
    assert_equal 2, user.users.size
    assert user.people.one? { |p| p.name == "Nick-User" }
    assert user.people.one? { |p| p.name == "Stella-User" }
    assert_equal 4, user.people.size
  end
end
