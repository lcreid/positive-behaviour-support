=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class TimeFormatTest < ActionView::TestCase
  def startup
    Time.zone = ActiveSupport::TimeZone["Pacific Time (US & Canada)"]
  end
  
  test "current time start of day. should give today" do
    # 2002-04-01 was a Monday (April 1st, 2002).
    [Time.new(2002, 04, 01).beginning_of_day, Time.new(2002, 04, 01).end_of_day].each do |time|
      # From: https://github.com/travisjeffery/timecop
      Timecop.freeze(time) do
        assert_equal "Today 00:00", Time.new(2002, 04, 01, 0, 0, 0).to_s(:humanized_ago)
        assert_equal "Today 00:00", Time.new(2002, 04, 01, 0, 0, 1).to_s(:humanized_ago)
        assert_equal "Today 00:01", Time.new(2002, 04, 01, 0, 1, 0).to_s(:humanized_ago)
        assert_equal "Today 23:59", Time.new(2002, 04, 01, 23, 59, 59).to_s(:humanized_ago)
      end
    end
  end
  
  test "current time start of day. should give yesterday" do
    # 2002-04-01 was a Monday (April 1st, 2002).
    [Time.new(2002, 04, 01).beginning_of_day, Time.new(2002, 04, 01).end_of_day].each do |time|
      Timecop.freeze(time) do
        assert_equal "Yesterday 00:00", Time.new(2002, 03, 31, 0, 0, 0).to_s(:humanized_ago)
        assert_equal "Yesterday 00:00", Time.new(2002, 03, 31, 0, 0, 1).to_s(:humanized_ago)
        assert_equal "Yesterday 00:01", Time.new(2002, 03, 31, 0, 1, 0).to_s(:humanized_ago)
        assert_equal "Yesterday 23:59", Time.new(2002, 03, 31, 23, 59, 59).to_s(:humanized_ago)
      end
    end
  end

  test "current time start of day. should give Saturday" do
    [Time.new(2002, 04, 01).beginning_of_day, Time.new(2002, 04, 01).end_of_day].each do |time|
      Timecop.freeze(time) do
        assert_equal "Sat 00:00", Time.new(2002, 03, 30, 0, 0, 0).to_s(:humanized_ago)
        assert_equal "Sat 00:01", Time.new(2002, 03, 30, 0, 1, 0).to_s(:humanized_ago)
        assert_equal "Sat 23:59", Time.new(2002, 03, 30, 23, 59, 59).to_s(:humanized_ago)
      end
    end
  end

  test "current time start of day. test time start of three days ago" do
    [Time.new(2002, 04, 01).beginning_of_day, Time.new(2002, 04, 01).end_of_day].each do |time|
      Timecop.freeze(time) do
        assert_equal "Fri 00:00", Time.new(2002, 03, 29, 0, 0, 0).to_s(:humanized_ago)
        assert_equal "Fri 00:01", Time.new(2002, 03, 29, 0, 1, 0).to_s(:humanized_ago)
        assert_equal "Fri 23:59", Time.new(2002, 03, 29, 23, 59, 59).to_s(:humanized_ago)
      end
    end
  end

  test "current time start of day. test time start of six days ago" do
    [Time.new(2002, 04, 01).beginning_of_day, Time.new(2002, 04, 01).end_of_day].each do |time|
      Timecop.freeze(time) do
        assert_equal "Tue 00:00", Time.new(2002, 03, 26, 0, 0, 0).to_s(:humanized_ago)
        assert_equal "Tue 00:01", Time.new(2002, 03, 26, 0, 1, 0).to_s(:humanized_ago)
        assert_equal "Tue 23:59", Time.new(2002, 03, 26, 23, 59, 59).to_s(:humanized_ago)
      end
    end
  end

  test "current time start of day. test time start of seven days ago" do
    [Time.new(2002, 04, 01).beginning_of_day, Time.new(2002, 04, 01).end_of_day].each do |time|
      Timecop.freeze(time) do
        assert_equal "02-Mar-25 00:00", Time.new(2002, 03, 25, 0, 0, 0).to_s(:humanized_ago)
        assert_equal "02-Mar-25 00:01", Time.new(2002, 03, 25, 0, 1, 0).to_s(:humanized_ago)
        assert_equal "02-Mar-25 23:59", Time.new(2002, 03, 25, 23, 59, 59).to_s(:humanized_ago)
      end
    end
  end

  test "current time start of day. test time start of tomorrow" do
    [Time.new(2002, 04, 01).beginning_of_day, Time.new(2002, 04, 01).end_of_day].each do |time|
      Timecop.freeze(time) do
        assert_equal "Tomorrow 00:00", Time.new(2002, 04, 02, 0, 0, 0).to_s(:humanized_ago)
        assert_equal "Tomorrow 00:01", Time.new(2002, 04, 02, 0, 1, 0).to_s(:humanized_ago)
        assert_equal "Tomorrow 23:59", Time.new(2002, 04, 02, 23, 59, 59).to_s(:humanized_ago)
      end
    end
  end

  test "current time start of day. Show day after tomorrow" do
    [Time.new(2002, 04, 01).beginning_of_day, Time.new(2002, 04, 01).end_of_day].each do |time|
      Timecop.freeze(time) do
        assert_equal "02-Apr-03 00:00", Time.new(2002, 04, 03, 0, 0, 0).to_s(:humanized_ago)
        assert_equal "02-Apr-03 00:01", Time.new(2002, 04, 03, 0, 1, 0).to_s(:humanized_ago)
        assert_equal "02-Apr-03 23:59", Time.new(2002, 04, 03, 23, 59, 59).to_s(:humanized_ago)
      end
    end
  end
end
