=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class InvitationsTest < ActionDispatch::IntegrationTest
  test "Can click on a message and make it go away" do
    get_logged_in(:user_invitor)
    
    message = messages(:first_message)
    
    assert_difference "@user.unread_messages(true).count", -1 do
      within "#message_#{message.id}" do
        click_link 'read'
      end
    end
    assert has_no_selector?("#message_#{message.id}"), "Message still there"
  end  

  test "accept invitation and connect third-party" do
    get_logged_in(:user_invitee)
    
    message = messages(:invitation)
    
    assert_difference "@user.people(true).count" do
      within "#message_#{message.id}" do
        click_link 'Accept'
      end
    end
    assert has_no_selector? "#message_#{message.id}", "Message still there"
  end  
  
  test "ignore invitation" do
    get_logged_in(:user_invitee)
    
    message = messages(:invitation)
    
    assert_no_difference "@user.people(true).count" do
      within "#message_#{message.id}" do
        click_link 'Ignore'
      end
      assert has_no_selector? "#message_#{message.id}", "Message still there"
    end
  end  
  
  test "mark invitation as spam" do
    get_logged_in(:user_invitee)
    
    message = messages(:invitation)
    
    assert_no_difference "@user.people(true).count" do
      within "#message_#{message.id}" do
        click_link 'spam'
      end
      assert has_no_selector? "#message_#{message.id}", "Message still there"
    end
  end  
  
  test "invite, accept, and connect" do
    invitee = users(:user_invitee)
    # Send invitation
    using_session(:invitor) do
      invitor = get_logged_in(users(:user_invitor))
      visit(edit_user_path(invitor))
      click_link('Invite')
      assert_equal new_message_path, current_path
      select('Google')
      fill_in 'Name', with: invitee.name
      assert_difference "invitee.messages.count" do
        click_button('Send')
      end
    end
    
    invitation = invitee.messages(true).order(created_at: :desc).first
    
    # Switch to invitee session and accept invitation
    using_session(:invitee) do
      get_logged_in(invitee)
      visit(home_user_path(invitee))
      assert_difference "invitee.people(true).count" do
        within "#message_#{invitation.id}" do
          click_link 'Accept'
        end
      end
      assert_equal home_user_path(invitee), current_path, "Not on home page"
      assert has_no_selector?("#message_#{invitation.id}"), "Message still there"
    end
    
  end  
  
  def get_logged_in(user)
    user = users(user) unless user.is_a? User
    @user = user
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      "provider" => 'google_oauth2',
      "uid" => @user.uid.to_s,
      "name" => @user.name
    })

    visit(root_path)
    # It looks like if you don't sign out at the end of each test case,
    # the test case will start off still logged in.
    # I guess that's sort of desirable, so you don't have to keep logging in.
    click_on('Sign out') if has_link? ("Sign out")
    assert_equal root_path, current_path
    
    click_on('Google')
    assert_equal home_user_path(@user), current_path
    
    @user
  end
end

