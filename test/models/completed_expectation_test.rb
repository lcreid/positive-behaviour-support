=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class CompletedExpectationTest < ActiveSupport::TestCase
  test "completed expectation created from" do
    e = expectations(:more_time)
    ce = CompletedExpectation.new(e.copyable_attributes)
    assert_equal e, ce
    assert_equal ce, e
  end
end
