=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "person one has one User link" do
    person = people(:user_one)
    assert_equal 1, person.links.size
    assert_equal "User Two", person.links.first.person_b.name
  end
  
  test "person two has one Patient link" do
    person = people(:user_five)
    assert_equal 1, person.links.size
    assert_equal "Patient for User Five", person.links.first.person_b.name
  end

  test "person four has two links" do
    person = people(:user_four)
    assert_equal 2, person.links.size
    assert_equal 1, person.links.joins(:person_b).where("user_id is null").size
    assert_equal 1, person.links.joins(:person_b).where("user_id is not null").size
    assert_equal "Patient Two", person.links.joins(:person_b).where("user_id is null").first.person_b.name
    assert_equal "User Three", person.links.joins(:person_b).where("user_id is not null").first.person_b.name
  end

test "person one has one User" do
    person = people(:user_one)
    assert_equal 1, person.people.size
    assert_equal "User Two", person.people.first.name
    assert_equal "User Two", person.users.first.name
  end
  
  test "person two has one Patient" do
    person = people(:user_five)
    assert_equal 1, person.people.size
    assert_equal "Patient for User Five", person.people.first.name
  end

  test "person four has one User and one Patient" do
    person = people(:user_four)
    assert_equal 2, person.people.size
    assert_equal 1, person.users.size
    assert_equal 1, person.patients.size
    assert_equal "Patient Two", person.patients.first.name
    assert_equal "User Three", person.users.first.name
  end
  
  test "find dates for all routines for a person" do
    person = people(:person_marty)
    assert_equal 2, person.routines.size
    assert_equal 4, person.routine_dates.size
  end
  
  test "hash for completed routines detailed overview" do
    Time.zone = 'Samoa'
    correct_hash = {
      DateTime.parse('2014-01-15T00:00:00') => [
        routines(:routine_index_one) => [completed_routines(:routine_index_one_one)]
      ],
      DateTime.parse('2014-01-16T00:00:00') => [
        routines(:routine_index_two) => [completed_routines(:routine_index_two_one)]
      ],
      DateTime.parse('2014-01-17T00:00:00') => [
        routines(:routine_index_one) => [completed_routines(:routine_index_one_one)]
      ],
      DateTime.parse('2014-01-18T00:00:00') => [
        routines(:routine_index_one) => [completed_routines(:routine_index_one_one)]
      ]
    }
    correct_completed_routines_column_layout = [
      Time.zone.parse('2014-01-01T00:00:00'), [
        [Time.zone.parse('2014-01-30T00:00:00'), 1],
        [Time.zone.parse('2014-01-31T00:00:00'), 1]
      ],
      Time.zone.parse('2014-02-01T00:00:00'), [
        [Time.zone.parse('2014-02-01T00:00:00'), 2],
        [Time.zone.parse('2014-02-02T00:00:00'), 2]
      ]
    ]
    
    person = people(:person_marty)
    hash = person.completed_routines_column_layout
    assert_equal correct_completed_routines_column_layout, hash
  end
  
  test "routines layout" do
    Time.zone = 'Samoa'
    correct_hash = {
      routines(:routine_index_one)=> {
        Time.zone.local(2014, 01, 30)=> [
          completed_routines(:routine_index_one_one)
        ],
        Time.zone.local(2014, 02, 01)=> [
          completed_routines(:routine_index_one_two)
        ],
        Time.zone.local(2014, 02, 02)=> [
          completed_routines(:routine_index_one_three),
          completed_routines(:routine_index_one_four)
        ]
      },
      routines(:routine_index_two)=> {
        Time.zone.local(2014, 01, 31)=> [
          completed_routines(:routine_index_two_one)
        ],
        Time.zone.local(2014, 02, 01)=> [
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
  
  test "whole layout" do
    Time.zone = 'Samoa'
    correct_hash = {
      routines(:routine_index_one) => {
        expectations(:ri0101) => {
          Time.zone.local(2014, 01, 30)=> [
            completed_expectations(:ri0101)
          ],
          Time.zone.local(2014, 02, 01)=> [
            completed_expectations(:ri0103)
          ],
          Time.zone.local(2014, 02, 02)=> [
            completed_expectations(:ri0106)
          ]
        },
        expectations(:ri0102) => {
          Time.zone.local(2014, 02, 01)=> [
            completed_expectations(:ri0104)
          ],
          Time.zone.local(2014, 02, 02)=> [
            completed_expectations(:ri0107),
            completed_expectations(:ri0109)
          ]
        },
        expectations(:ri0103) => {
          Time.zone.local(2014, 01, 30)=> [
            completed_expectations(:ri0102)
          ],
          Time.zone.local(2014, 02, 02)=> [
            completed_expectations(:ri0108),
            completed_expectations(:ri010a)
          ]
        },
        expectations(:ri0104) => {
          Time.zone.local(2014, 02, 01)=> [
            completed_expectations(:ri0105)
          ],
          Time.zone.local(2014, 02, 02)=> [
            completed_expectations(:ri010b)
          ]
        }
      },
      routines(:routine_index_two) => {
        expectations(:ri0201) => {
          Time.zone.local(2014, 01, 31)=> [
            completed_expectations(:ri0201)
          ],
          Time.zone.local(2014, 02, 01)=> [
            completed_expectations(:ri0203)
          ]
        },
        expectations(:ri0202) => {
          Time.zone.local(2014, 01, 31)=> [
            completed_expectations(:ri0202)
          ],
          Time.zone.local(2014, 02, 01)=> [
            completed_expectations(:ri0204)
          ]
        }
      }
    }
  
    person = people(:person_marty)
    full_layout = person.full_layout
    assert_equal correct_hash[routines(:routine_index_two)], full_layout[routines(:routine_index_two)]
    assert_equal correct_hash[routines(:routine_index_one)][expectations(:ri0101)], 
      full_layout[routines(:routine_index_one)][expectations(:ri0101)]
    assert_equal correct_hash[routines(:routine_index_one)][expectations(:ri0102)], 
      full_layout[routines(:routine_index_one)][expectations(:ri0102)]
    assert_equal correct_hash[routines(:routine_index_one)][expectations(:ri0103)], 
      full_layout[routines(:routine_index_one)][expectations(:ri0103)]
    assert_equal correct_hash[routines(:routine_index_one)][expectations(:ri0104)], 
      full_layout[routines(:routine_index_one)][expectations(:ri0104)]
    assert_equal correct_hash[routines(:routine_index_one)], full_layout[routines(:routine_index_one)]
    assert_equal correct_hash, full_layout
  end
end
