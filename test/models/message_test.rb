require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "message exists" do
    user = users(:user_invitor)
    assert_equal 1, user.messages.count, "Not on user"
  end
end
