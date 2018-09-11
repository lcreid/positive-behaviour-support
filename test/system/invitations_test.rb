# frozen_string_literal: true

require "application_system_test_case"

class InvitationsTest < ApplicationSystemTestCase
  test "Can click on a message and make it go away" do
    get_logged_in(:user_invitor)
    click_on "Notifications"

    message = messages(:first_message)

    assert_difference "@user.unread_messages.reload.count", -1 do
      within "#message_#{message.id}" do
        click_link "read"
      end
    end
    assert has_no_selector?("#message_#{message.id}"), "Message still there"
  end

  test "accept invitation and connect third-party" do
    get_logged_in(:user_invitee)
    click_on "Notifications"

    message = messages(:invitation)

    assert_difference "@user.people.reload.count" do
      within "#message_#{message.id}" do
        click_link "Accept"
      end
    end
    assert has_no_selector?("#message_#{message.id}"), "Message still there"
  end

  test "ignore invitation" do
    get_logged_in(:user_invitee)
    click_on "Notifications"

    message = messages(:invitation)

    assert_no_difference "@user.people.reload.count" do
      within "#message_#{message.id}" do
        click_link "Ignore"
      end
      assert has_no_selector?("#message_#{message.id}"), "Message still there"
    end
  end

  test "mark invitation as spam" do
    get_logged_in(:user_invitee)
    click_on "Notifications"

    message = messages(:invitation)

    assert_no_difference "@user.people.reload.count" do
      within "#message_#{message.id}" do
        click_link "spam"
      end
      assert has_no_selector?("#message_#{message.id}"), "Message still there"
    end
  end

  test "e-mail invitation to user not logged in" do
    clear_emails

    test_address = "invitee@example.com"

    using_session(:invitor) do
      invitor = get_logged_in(:user_invitor)
      visit(edit_user_path(invitor))
      click_link "Invite"
      assert_equal new_invitation_path, current_path
      fill_in "E-mail", with: test_address
      assert_difference "ActionMailer::Base.deliveries.count" do
        click_button "Send Invitation"
      end
    end

    using_session(:invitee) do
      puts "ALREADY LOGGED IN" if has_link? "Sign out"
      invitee = set_up_omniauth_mock(:user_invitee)
      open_email test_address
      assert_difference "invitee.people.count" do
        current_email.click_on "Accept"
        # assert_equal signin_path, current_path
        click_link "Google"
        assert_text "Profile"
        assert_equal edit_user_path(invitee), current_path
      end
    end
  end

  test "e-mail invitation to logged-in user" do
    clear_emails

    test_address = "invitee@example.com"

    using_session(:invitor) do
      invitor = get_logged_in(:user_invitor)
      visit(edit_user_path(invitor))
      click_link "Invite"
      assert_equal new_invitation_path, current_path
      fill_in "E-mail", with: test_address
      assert_difference "ActionMailer::Base.deliveries.count" do
        click_button "Send Invitation"
      end
    end

    using_session(:invitee) do
      puts "ALREADY LOGGED IN" if has_link? "Sign out"
      invitee = get_logged_in(:user_invitee)
      open_email test_address
      assert_difference "invitee.people.count" do
        current_email.click_on "Accept"
        # assert_equal signin_path, current_path
        assert_text "Profile"
      end
    end
  end
end
