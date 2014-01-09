require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "person one has one User link" do
    person = people(:user_one)
    assert_equal 1, person.links.size
    assert_equal "User Two", person.links.first.person_b.name
  end
  
  test "person two has one Patient link" do
    person = people(:user_two)
    assert_equal 1, person.links.size
    assert_equal "Patient One", person.links.first.person_b.name
  end

  test "person four has two links" do
    person = people(:user_four)
    assert_equal 2, person.links.size
    assert_equal 1, person.links.joins(:person_b).where("user_id is null").size
    assert_equal 1, person.links.joins(:person_b).where("user_id is not null").size
    assert_equal "Patient Two", person.links.joins(:person_b).where("user_id is null").first.person_b.name
    assert_equal "User Three", person.links.joins(:person_b).where("user_id is not null").first.person_b.name
  end

test "person one has one User" do
    person = people(:user_one)
    assert_equal 1, person.people.size
    assert_equal "User Two", person.people.first.name
    assert_equal "User Two", person.users.first.name
  end
  
  test "person two has one Patient" do
    person = people(:user_two)
    assert_equal 1, person.people.size
    assert_equal "Patient One", person.people.first.name
  end

  test "person four has one User and one Patient" do
    person = people(:user_four)
    assert_equal 2, person.people.size
    assert_equal 1, person.users.size
    assert_equal 1, person.patients.size
    assert_equal "Patient Two", person.patients.first.name
    assert_equal "User Three", person.users.first.name
  end
end