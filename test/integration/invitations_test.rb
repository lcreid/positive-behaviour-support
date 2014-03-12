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
    skip # This is for old way of connecting.
    invitee = users(:user_invitee)
    # Send invitation
    using_session(:invitor) do
      invitor = get_logged_in(users(:user_invitor))
      visit(edit_user_path(invitor))
      click_link('Invite')
      assert_equal new_message_path, current_path
      fill_in 'ID', with: invitee.id
      assert_difference "invitee.messages(true).count" do
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

  test "e-mail invitation" do
    clear_emails

    test_address = "invitee@example.com"

    using_session(:invitor) do
      invitor = get_logged_in(:user_invitor)
      visit(edit_user_path(invitor))
      click_link 'Invite'
      assert_equal new_invitation_path, current_path
      fill_in 'E-mail', with: test_address
      assert_difference "ActionMailer::Base.deliveries.count" do
        click_button 'Send Invitation'
      end
    end

    using_session(:invitee) do
      puts "ALREADY LOGGED IN" if has_link? ("Sign out")
      invitee = set_up_omniauth_mock(:user_invitee)
      open_email test_address
      # puts current_email.body
      assert_difference 'invitee.people.count' do
        current_email.click_on 'Accept'
        assert_equal signin_path, current_path
        click_link 'Google'
        assert_equal edit_user_path(invitee), current_path
      end
    end
  end
end

