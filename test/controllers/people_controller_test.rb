require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
#  test "try to delete a person without a link" do
#    @controller.log_in(users(:existing_linkedin))
#    assert_raise ActionController::ParameterMissing do
#      delete :destroy, id: nil
#    end
#  end

  test "try to delete a person when not logged in" do
    assert_raise ActionController::RoutingError do
      delete :destroy, params: { id: people(:patient_two) }
    end
  end

  test "try to delete a person when not allowed" do
    @controller.log_in(users(:existing_linkedin))
    assert_raise ActionController::RoutingError do
      delete :destroy, params: { id: people(:patient_one) }
    end
  end

  test "delete a person" do
    @controller.log_in(users(:existing_linkedin))

    @request.env['HTTP_REFERER'] = 'http://localhost:3000/user/edit'

    assert_difference "Person.all.count", -1 do
      delete :destroy, params: { id: people(:patient_two) }
    end
    # FIXME: Removed to get rid of deprecation
    # assert_redirected_to :back
  end

#  test "try to edit a person without a link" do
#    @controller.log_in(users(:existing_linkedin))
#    assert_raise ActionController::ParameterMissing do
#      get :edit, id: nil
#    end
#  end

  test "try to edit a person when not logged in" do
    assert_raise ActionController::RoutingError do
      get :edit, params: { id: people(:patient_two) }
    end
  end

  test "try to edit a person when not allowed" do
    @controller.log_in(users(:existing_linkedin))
    assert_raise ActionController::RoutingError do
      get :edit, params: { id: people(:patient_one) }
    end
  end

  test "edit a person" do
    @controller.log_in(users(:existing_linkedin))

    get :edit, params: { id: people(:patient_two) }
    assert_response :success
    assert_not_nil assigns(:person)
  end

#  test "try to update a person without a link" do
#    @controller.log_in(users(:existing_linkedin))
#    assert_raise ActionController::ParameterMissing do
#      post :update, id: nil
#    end
#  end

  test "try to update a person when not logged in" do
    person = people(:patient_two)
    assert_raise ActionController::RoutingError do
      post :update, params: { id: person.id, person: { name: "New Name" } }
    end
  end

  test "try to update a person when not allowed" do
    @controller.log_in(users(:existing_linkedin))
    person = people(:patient_one)
    assert_raise ActionController::RoutingError do
      post :update, params: { id: person.id, person: { name: "New Name" } }
    end
  end

  test "update a person" do
    @controller.log_in(user = users(:existing_linkedin))

    @request.env['HTTP_REFERER'] = 'http://test.hostperson/edit'

    person = people(:patient_two)
    original_person_name = person.short_name

    post :update, params: { id: person.id, person: { name: "New Name" } }
    assert_redirected_to person_path(person)

    db_person = Person.find(person.id)
    refute_equal original_person_name, db_person.short_name
  end

  test "show page to create a new person" do
    @controller.log_in(user = users(:existing_linkedin))

    get :new, params: { creator_id: user.id }
    assert_response :success
    assert_not_nil assigns(:person)
  end

  test "create a person" do
    @controller.log_in(user = users(:existing_linkedin))

    assert_difference "user.people.count" do
      post :create, params: { person: { name: "New Name", creator_id: user.id } }
      assert_redirected_to person_path(user.people.last)
    end
  end

  test "Format of person dashboard (Matt)" do
    @controller.log_in(user = users(:user_marie))

    subject = people(:patient_matt)
    get :show, params: { id: subject.id }
    assert_response :success

    assert_select 'div#patients h1', "Matt-Patient"
    assert_select '.routines h2', "Routines"
    assert_select '.pending_rewards h2', "Goals and Rewards"

    assert_select '.routines table tbody tr', 4

    assert_select 'div.pending_rewards table' do |d|
      assert_select d[0], 'tbody tr', 3 do |reward|
        assert_select reward[0], 'td', "Time Off"
        assert_select reward[1], 'td', "Nothing"

        assert_select reward[0], "a[href='#{new_award_path(goal_id: subject.goals[0].id)}']"
        assert_select reward[1], "a", 1
      end
    end
  end

  test "Format of person dashboard (Max)" do
    # FIXME: Put this test back in.
    # The documentation says that `assert_select` should match to root node,
    # but clearly the below doesn't work.
    # Actually, it's weirder than that. The failure is moving around with no
    # obvious explanation.
    skip
    @controller.log_in(user = users(:user_marie))

    subject = people(:patient_max)
    get :show, params: { id: subject.id }
    assert_response :success

    assert_select 'div#patients h1', "Max-Patient"

    assert_select '.routines h2', "Routines"
    assert_select '.routines table tbody tr', 3 do |reward|
      puts reward[0]
      assert_select reward[0], 'tr'
      assert_select reward[0], 'td', /^Go to bed.*/
      assert_select reward[0], 'a', 2 do |links|
        puts "Looking for Edit"
        puts @response.body
        puts links
        puts links[0]
        assert_select links[0], 'a', "Edit"
        puts "Looking for New Observations"
        assert_select links[1], 'a', "New Observations"
      end
      assert_select reward[1], 'td', /^Turn off Minecraft.*/
    end
  end

  test "show report of completed routines" do
    @controller.log_in(user = users(:user_sharon))
    patient = people(:person_marty)
    get :reports, params: { id: patient.id }
    assert :success

#    puts @response.body

    assert_select 'tr:nth-of-type(1) th', 4
    assert_select 'tr:nth-of-type(2) th', 4 # Don't count the rowspan
    assert_select 'tr:nth-of-type(1) td', 7 # Even though the : is on the tr, the count is for the whole selector
    assert_select 'tr:nth-of-type(2) td', 7
    assert_select 'tr:nth-of-type(3) td', 7
    assert_select 'tr:nth-of-type(4) td', 7
    assert_select 'tr:nth-of-type(5) td', 7
    assert_select 'tr:nth-of-type(6) td', 7
#    assert_select 'tr.completed_routine', 6 do |row|
#      assert_select row[0], 'td', 4
#      assert_select row[1], 'td', 4
#      assert_select row[2], 'td', 4
#      assert_select row[3], 'td', 4
#      # The following suck because it depends on the order that my test data comes
#      assert_select row[0], 'td:last-of-type tr', 3, "Row 1"
#      assert_select row[1], 'td:last-of-type tr', 3, "Row 2"
#      assert_select row[2], 'td:last-of-type tr', 2, "Row 3"
#      assert_select row[3], 'td:last-of-type tr', 3, "Row 4"

#      assert_select row[0], 'td:nth-of-type(2)', "Not part of routine"
#      assert_select row[0], 'td:nth-of-type(4)', "Not part of routine"
#      assert_select row[1], 'td:nth-of-type(3)', "Not part of routine"
#      assert_select row[2], 'td:nth-of-type(4)', "Not part of routine"
#      assert_select row[3], 'td:nth-of-type(1)', "Not part of routine"
#    end
  end
end
