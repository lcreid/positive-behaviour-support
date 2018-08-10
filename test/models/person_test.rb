# frozen_string_literal: true

require "test_helper"

class PersonTest < ActiveSupport::TestCase
  test "person one has one User link" do
    person = people(:user_one)
    assert_equal 1, person.links.size
    assert_equal "User Two", person.links.first.person_b.short_name
  end

  test "person four has two links" do
    person = people(:user_four)
    assert_equal 2, person.links.size
    assert_equal 1, person.links.joins(:person_b).where("user_id is null").size
    assert_equal 1, person.links.joins(:person_b).where("user_id is not null").size
    assert_equal "Patient Two", person.links.joins(:person_b).where("user_id is null").first.person_b.short_name
    assert_equal "User Three", person.links.joins(:person_b).where("user_id is not null").first.person_b.short_name
  end

  test "person one has one User" do
    person = people(:user_one)
    assert_equal 1, person.people.size
    assert_equal "User Two", person.people.first.short_name
    assert_equal "Two Google", person.users.first.name
  end

  test "person two has one Patient" do
    person = people(:user_five)
    assert_equal 1, person.people.size
    assert_equal "Patient for User Five", person.people.first.short_name
  end

  test "person four has one User and one Patient" do
    person = people(:user_four)
    assert_equal 2, person.people.size
    assert_equal 1, person.users.size
    assert_equal 1, person.patients.size
    assert_equal "Patient Two", person.patients.first.short_name
    assert_equal "Three Yahoo", person.users.first.name
  end

  test "Don't link people already linked" do
    p10 = people(:p10_secondary)
    p20 = people(:p20_secondary)

    assert_no_difference "p10.people.count" do
      p10.linkup(p20)
    end
  end

  test "find dates for all routines for a person" do
    person = people(:person_marty)
    assert_equal 2, person.routines.size
    assert_equal 4, person.routine_dates.size
  end

  test "hash for completed routines detailed overview" do
    Time.use_zone("Samoa") do
      correct_completed_routines_column_layout = [
        Time.zone.parse("2014-01-01T00:00:00"), [
          [Time.zone.parse("2014-01-30T00:00:00"), 1],
          [Time.zone.parse("2014-01-31T00:00:00"), 1]
        ],
        Time.zone.parse("2014-02-01T00:00:00"), [
          [Time.zone.parse("2014-02-01T00:00:00"), 2],
          [Time.zone.parse("2014-02-02T00:00:00"), 2]
        ]
      ]

      person = people(:person_marty)
      hash = person.completed_routines_column_layout
      assert_equal correct_completed_routines_column_layout, hash
    end
  end

  test "routines layout" do
    Time.use_zone("Samoa") do
      correct_hash = {
        routines(:routine_index_one) => {
          Time.zone.local(2014, 1, 30) => [
            completed_routines(:routine_index_one_one)
          ],
          Time.zone.local(2014, 2, 1) => [
            completed_routines(:routine_index_one_two)
          ],
          Time.zone.local(2014, 2, 2) => [
            completed_routines(:routine_index_one_three),
            completed_routines(:routine_index_one_four)
          ]
        },
        routines(:routine_index_two) => {
          Time.zone.local(2014, 1, 31) => [
            completed_routines(:routine_index_two_one)
          ],
          Time.zone.local(2014, 2, 1) => [
            completed_routines(:routine_index_two_two)
          ]
        }
      }
      #    puts "I am a MiniTest #{self.kind_of?(MiniTest::Unit::TestCase)}"
      person = people(:person_marty)
      #    correct_hash.each { |k, v| puts k.id; v.each { |k, v| puts "  #{k} #{k.class}"; v.each { |x| puts "    #{x.id}"}}}
      #    person.routines_layout.each { |k, v| puts k.id; v.each { |k, v| puts "  #{k} #{k.class}"; v.each { |x| puts "    #{x.id}"}}}
      assert_equal correct_hash, person.routines_layout
    end
  end

  test "whole layout" do
    skip "This test is db order dependent, and is probably testing something the app doesn't need to do."
    Time.use_zone("Samoa") do
      correct_hash = {
        routines(:routine_index_one) => {
          expectations(:ri0101) => {
            Time.zone.local(2014, 1, 30) => [
              completed_expectations(:ri0101)
            ],
            Time.zone.local(2014, 2, 1) => [
              completed_expectations(:ri0103)
            ],
            Time.zone.local(2014, 2, 2) => [
              completed_expectations(:ri0106)
            ]
          },
          expectations(:ri0102) => {
            Time.zone.local(2014, 2, 1) => [
              completed_expectations(:ri0104)
            ],
            Time.zone.local(2014, 2, 2) => [
              completed_expectations(:ri0107),
              completed_expectations(:ri0109)
            ].sort
          },
          expectations(:ri0103) => {
            Time.zone.local(2014, 1, 30) => [
              completed_expectations(:ri0102)
            ],
            Time.zone.local(2014, 2, 2) => [
              completed_expectations(:ri010a),
              completed_expectations(:ri0108)
            ].sort
          },
          expectations(:ri0104) => {
            Time.zone.local(2014, 2, 1) => [
              completed_expectations(:ri0105)
            ],
            Time.zone.local(2014, 2, 2) => [
              completed_expectations(:ri010b)
            ]
          }
        },
        routines(:routine_index_two) => {
          expectations(:ri0201) => {
            Time.zone.local(2014, 1, 31) => [
              completed_expectations(:ri0201)
            ],
            Time.zone.local(2014, 2, 1) => [
              completed_expectations(:ri0203)
            ]
          },
          expectations(:ri0202) => {
            Time.zone.local(2014, 1, 31) => [
              completed_expectations(:ri0202)
            ],
            Time.zone.local(2014, 2, 1) => [
              completed_expectations(:ri0204)
            ]
          }
        }
      }

      person = people(:person_marty)
      full_layout = person.full_layout
      assert_equal correct_hash[routines(:routine_index_two)], full_layout[routines(:routine_index_two)]
      assert_equal correct_hash[routines(:routine_index_one)][expectations(:ri0101)].sort,
        full_layout[routines(:routine_index_one)][expectations(:ri0101)].sort
      assert_equal correct_hash[routines(:routine_index_one)][expectations(:ri0102)].sort,
        full_layout[routines(:routine_index_one)][expectations(:ri0102)].sort
      assert_equal correct_hash[routines(:routine_index_one)][expectations(:ri0103)].sort,
        full_layout[routines(:routine_index_one)][expectations(:ri0103)].sort
      assert_equal correct_hash[routines(:routine_index_one)][expectations(:ri0104)].sort,
        full_layout[routines(:routine_index_one)][expectations(:ri0104)].sort
      assert_equal correct_hash[routines(:routine_index_one)].sort, full_layout[routines(:routine_index_one)].sort
      assert_equal correct_hash, full_layout
    end
  end

  test "Connections through secondary IDs" do
    # Test that a person connected only to a user's secondary id shows up in the person's
    # user association.
    p10 = users(:p10)
    p30 = people(:p30)
    assert p30.users.include?(p10)
  end

  #  test "link_to" do
  #    marie = users(:user_marie)
  #    max = people(:patient_max)
  #    stella = people(:person_stella)
  #    not_connected = people(:user_five)
  #
  #    assert_equal 4, marie.people.count
  #    assert_not_nil max.link_to(marie)
  #    assert_not_nil stella.link_to(marie)
  #    assert_nil marie.primary_identity.link_to(not_connected)
  #  end
end
