=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class CompletedRoutineTest < ActiveSupport::TestCase
  test "assignment of routine to completed routine" do
    r = routines(:turn_off_minecraft)
#    puts r.comparable_attributes.to_s
#    puts other.comparable_attributes.to_s
    cr = CompletedRoutine.new(r.copyable_attributes)
    assert_not_same r, cr
    assert_not_same cr, r
    assert_equal r, cr
    assert_equal cr, r
  end
end
