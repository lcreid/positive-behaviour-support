=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/email'
require 'capybara/dsl'

# From http://mifsud.me/transactional-tests-ruby-rails/
DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

=begin
Added LCR to bring in capybara.
=end
class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Capybara::Email::DSL

=begin rdoc
Helper to log in a user for integration tests. Sets @user. Returns @user.
Takes a User, or a symbol which will be assumed to be a User fixture.
=end
  def get_logged_in(user)
    @user = set_up_omniauth_mock(user)

    visit(root_path)
    # It looks like if you don't sign out at the end of each test case,
    # the test case will start off still logged in.
    # I guess that's sort of desirable, so you don't have to keep logging in.
    click_on('Sign out') if has_link? ("Sign out")
    sleep 2
    assert_equal root_path, current_path

    click_on('Google')

    # puts page.body
    sleep 2
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

    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      "provider" => user.provider,
      "uid" => user.uid.to_s,
      "name" => user.name
    })

    user
  end
end
