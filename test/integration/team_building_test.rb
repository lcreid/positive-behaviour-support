=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'capybara/rails'
require 'test_helper'

class TeamBuildingTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = false

  def teardown
    DatabaseCleaner.clean
  end

  test "Add a routine" do
    get_logged_in(:user_marie)

    visit(person_path(@user.people.last))
    click_link('New Routine')
    assert_equal new_routine_path, current_path
  end

  test "Add a goal" do
    get_logged_in(:user_marie)

    visit(person_path(@user.people.last))
    click_link('New Goal')
    assert_equal new_person_goal_path(@user.people.last), current_path
  end

  test "cancel backwards from routine" do
    get_logged_in(:user_marie)

    person = people(:patient_matt)
    visit(home_user_path(@user))
    click_link("Matt-Patient")
    assert_equal person_path(person), current_path
    click_link('New Routine')
    assert_equal new_routine_path, current_path
    click_link('Cancel')
    assert_equal person_path(person), current_path
  end

  test "save backwards from routine" do
    skip
    # This test needs Javascript
    Capybara.current_driver = :webkit

    get_logged_in(:user_marie)

    person = people(:patient_matt)
    visit(home_user_path(@user))
    click_link("Matt-Patient")
    assert_equal person_path(person), current_path
    click_link('New Routine')
    assert_equal new_routine_path, current_path
    fill_in 'Name', with: "Capy add"
    # Can't add exepctation because I don't have Javascript support in Capybara yet.
    click_link 'Add Expectation'
    # puts body
    # puts "Console: #{page.driver.console_messages}"
    # puts "Errors: #{page.driver.error_messages}"
    assert has_selector?("input[id*='description']")
    find('input[id$=_description]').set("Exp 1")
    assert_difference "Expectation.all.count" do
      assert_difference "person.routines.reload.count" do
        click_button('Save')
        assert_equal person_path(person), current_path
      end
    end

    # Turn off Javascript
    Capybara.use_default_driver
  end

  test "change team" do
    get_logged_in(:user_marie)
    matt = people(:patient_matt)
    click_link(matt.short_name)
    click_link('Edit Team')
    check('Stella')
    assert_difference "matt.people.reload.count" do
      click_button('Save')
    end
    assert_equal person_path(matt), current_path
    click_link('Edit Team')
    uncheck('Stella')
    assert_difference "matt.people.reload.count", -1 do
      click_button('Save')
    end
  end
end
