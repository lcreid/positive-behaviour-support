=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'person_helper'

class Person < ActiveRecord::Base
  belongs_to :user
  has_many :links, foreign_key: :person_a_id
  has_many :people, through: :links, source: :person_b
  has_many :routines, -> {order("routines.created_at")}
  has_many :completed_routines, -> {order("completed_routines.created_at")}, through: :routines
  has_many :completed_expectations, through: :completed_routines
  has_many :goals
  accepts_nested_attributes_for :routines
  accepts_nested_attributes_for :goals
  
  include PersonHelper

=begin rdoc
Link a Person to a Person or a User, bidirectionally, so that each entity is connected
to the other.
See: http://stackoverflow.com/questions/2923692/bidirectional-self-referential-associations
for confirmation that this is probably a good way to do it.
=end  
  def linkup(other)
    retval = other
    other = other.primary_identity if other.is_a? User
    people << other
    other.people << self
    retval
  end
    
=begin rdoc
Unlink a Person from another Person or a User, bidirectionally, so that each entity is disconnected
to the other.
=end  
  def unlink(other)
    other = other.primary_identity if other.is_a? User
    people.delete(other)
    other.people.delete(self)
  end

=begin rdoc
Get all the unique expectations, by expectation ID, for completed routines
for this person. These become the column headings (or row headings) for
the display.
=end
  def unique_expectations
    # Select unique expectations that are in completed expectations for this person.
  end

=begin rdoc
Get the unique dates on which this person completed at least one routine.
=end
  def routine_dates
    completed_routines.pluck(:created_at).collect { |d| d.beginning_of_day }.uniq
  end

=begin rdoc
Get arrays of the dates of completed routines and number of columns needed for each date, 
then also grouped by month and year.
=end
  def completed_routines_column_layout
    # select to_date(created_at), count(*) from completed_routines group by to_date(created_at)
    # The date comes out as a string.
    completed_routines
      .group("date(completed_routines.created_at)")
      .pluck("date(completed_routines.created_at), count(*)")
      .collect { |x| [Time.zone.parse(x[0]), x[1]]}
      .group_by { |x| x[0].beginning_of_month }
      .flatten
      # TODO Confirm when I add time zone that this uses time zone
  end
  
=begin rdoc
Get a has of routines containing completed routines grouped by date.
=end
  def routines_layout
    Hash[
      routines.
        map { |r| [r, r.
        completed_routines.
        group_by { |cr| cr.created_at.beginning_of_day }]}
    ]
  end
  
  def full_layout
    layout = completed_expectations.each_with_object(Hash.new) do |ce, o|
#      puts "ce, o: #{ce}, #{o}"
      o[ce.routine] ||= Hash.new
      o[ce.routine][ce.expectation] ||= Hash.new # Cause we want an array next, we have to create a hash but don't return hash as default.'
      o[ce.routine][ce.expectation][ce.completed_routine.created_at.beginning_of_day] ||= []
      o[ce.routine][ce.expectation][ce.completed_routine.created_at.beginning_of_day] << ce
#      puts "layout: #{o.inspect}"
    end
    layout
  end
  
  def completed_expectations_for_day_and_expectation(expectation, day)
    completed_expectations.find_all do |x|
      x.completed_routine.created_at.beginning_of_day == day &&
        x.expectation == expectation
    end
  end
#  def name
#    "#{self.class}: #{super}"
#  end
end
