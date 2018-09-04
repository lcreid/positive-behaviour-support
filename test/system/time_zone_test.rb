# frozen_string_literal: true

require "application_system_test_case"

class TimeZoneTest < ApplicationSystemTestCase
  test "Use user time zone" do
    skip "No user currently has a time zone."
    get_logged_in(:existing_twitter)
    u = users(:existing_twitter)
    assert_equal "Samoa", u.time_zone
    assert !flash.notice.blank?, "Flash was blank."
  end

  test "Use browser time zone" do
    skip "Figure out how to set browser time zone (some say set ENV in test_helper.rb)."
  end
end
