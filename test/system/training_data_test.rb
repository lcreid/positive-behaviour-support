# frozen_string_literal: true

require "application_system_test_case"

class TrainingDataTest < ApplicationSystemTestCase
  test "new user gets training patients" do
    skip "Need to simulate sign-up to test this."
    # FIXME: Put this test back in.
    @controller.env = { "omniauth.auth" =>
      { "provider" => "Training",
        "uid" => "1001",
        "info" => { "nickname" => "New User" } },
                        "omniauth.params" =>
      { "time_zone" => "Samoa" } }
    assert_difference "User.count", 2 do
      get :create
    end
    u = User.find_by(uid: "1001")
    assert_equal 2, u.patients.size
    assert_equal 3, u.patients[0].routines.size
    assert_equal 1, u.patients[0].routines[0].expectations.size
    assert_equal 1, u.patients[0].routines[1].expectations.size
    assert_equal 2, u.patients[0].routines[2].expectations.size
    assert_equal 2, u.patients[1].routines.size
    assert_equal 3, u.patients[1].routines[0].expectations.size
    assert_equal 2, u.patients[1].routines[1].expectations.size
    assert_equal 1, u.users.size
    assert_redirected_to home_user_path(u)
    assert_equal "Samoa", u.time_zone
    assert !flash.notice.blank?, "Flash was blank."
  end
end
