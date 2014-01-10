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
