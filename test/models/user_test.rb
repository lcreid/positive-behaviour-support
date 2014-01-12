require 'test_helper'
require 'training'

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
  
  test "user five has one Patient link" do
    user = users(:user_five)
    assert_equal 1, user.links.size
    assert_equal "Patient for User Five", user.links.first.person_b.name
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
  
  test "user five has one Patient" do
    user = users(:user_five)
    assert_equal 1, user.people.size
    assert_equal 1, user.patients.size
    assert_equal "Patient for User Five", user.patients.first.name
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
  
  test "user should be able to access routine" do
    user = users (:user_marie)
    routine = routines(:do_homework)
    assert user.can_complete?(routine), "can_complete returned false, should be true"
  end
  
  test "user shouldn't be able to access routine" do
    user = users (:user_marie)
    routine = routines(:belongs_to_no_one)
    assert ! user.can_complete?(routine), "can_complete returned true, should be false"
  end
  
  test "create training data" do
    user = User.create(name: "Training Data User")
    Training.create(user)
    assert_equal 3, user.people.size
    assert_equal 2, user.patients.size
    pt1 = user.patients[0]
    assert_equal 3, pt1.routines.size
    assert_equal 2, pt1.goals.size
    assert_equal 10, pt1.completed_routines.size
    assert_equal 8, pt1.goals[0].clean_routines.size
    assert_equal 0, pt1.goals[1].clean_routines.size
    assert_equal user, pt1.people.first.user
    pt2 = user.patients[1]
    assert_equal 2, pt2.routines.size
    assert_equal 0, pt2.goals.size
    assert_equal 0, pt2.completed_routines.size
    assert_equal user, pt2.people.first.user
  end
  
  test "link two users" do
    assert_difference "Link.all.count", 2 do
      link_two
    end
  end
  
  test "unlink two users" do
    u1, u2 = link_two
    assert_difference "Link.all.count", -2 do
      u1.unlink(u2)
    end
    u1, u2 = link_two
    assert_difference "Link.all.count", -2 do
      u2.unlink(u1)
    end
  end
  
  def link_two
    friendor = User.create!(name: "Friendor")
    friendee = User.create!(name: "Friendee")
    
    return friendor, friendor.linkup(friendee)
  end
end
