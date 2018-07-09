# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "capybara/email"
require "capybara/dsl"

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Added LCR to bring in capybara.
class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Capybara::Email::DSL

  # rdoc
  # Helper to log in a user for integration tests. Sets @user. Returns @user.
  # Takes a User, or a symbol which will be assumed to be a User fixture.
  def get_logged_in(user)
    @user = set_up_omniauth_mock(user)

    visit(root_path)
    # It looks like if you don't sign out at the end of each test case,
    # the test case will start off still logged in.
    # I guess that's sort of desirable, so you don't have to keep logging in.
    # I think this may only get triggered on some tests that use two sessions.
    # There should be a better way to work that.
    if has_link?("Sign out")
      click_on("Sign out")
      sleep 2
    end
    assert_equal root_path, current_path
    click_on("Google")
    assert_text @user.subjects.first.name unless @user.subjects.empty?
    # puts "@user.subjects.count: #{@user.subjects.count}"

    if @user.subjects.count != 1
      assert_equal home_user_path(@user), current_path
    else
      assert_equal person_path(@user.subjects.first), current_path
    end

    @user
  end

  def set_up_omniauth_mock(user)
    user = users(user) unless user.is_a? User

    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new("provider" => user.provider,
                                                                       "uid" => user.uid.to_s,
                                                                       "name" => user.name)

    user
  end
end
