# frozen_string_literal: true

require "person_helper"

class Person < ActiveRecord::Base
  belongs_to :user, optional: true # if this is an identity of a User
  belongs_to :creator, class_name: "User"
  has_many :links, foreign_key: :person_a_id
  has_many :reverse_links, foreign_key: :person_b_id, class_name: "Link"
  has_many :people, through: :links, source: :person_b
  has_many :users, through: :people, source: :user
  has_many :routines, -> { order("routines.name") }, dependent: :destroy
  has_many :completed_routines, -> { order("completed_routines.routine_done_at") }, through: :routines, dependent: :destroy
  has_many :completed_expectations, through: :completed_routines
  has_many :goals, dependent: :destroy

  has_many :pending_rewards, -> { where(pending_routines.exists?) }, class_name: "Goal"

  accepts_nested_attributes_for :routines
  accepts_nested_attributes_for :goals

  # New
  has_many :person_users, dependent: :destroy
  has_many :caregivers, through: :person_users, class_name: "User", inverse_of: :subjects, source: :user

  validates_presence_of :creator

  include PersonHelper

  # rdoc
  # Return the short_name, if any, or the name.
  # The short name is intended to mask the identity of the subject,
  # so people can't learn who's under care by shoulder surfing.
  def short_name
    super || name
  end

  # rdoc
  # Link a Person to a Person or a User, bidirectionally, so that each entity is connected
  # to the other.
  # See: http://stackoverflow.com/questions/2923692/bidirectional-self-referential-associations
  # for confirmation that this is probably a good way to do it.
  def linkup(other)
    return other if other.people.any? { |p| p == self }
    retval = other
    other = other.primary_identity if other.is_a? User
    people << other
    other.people << self
    retval
  end

  # rdoc
  # Unlink a Person from another Person or a User, bidirectionally, so that each entity is disconnected
  # to the other.
  def unlink(other)
    other = other.primary_identity if other.is_a? User
    people.delete(other)
    other.people.delete(self)
  end

  # rdoc
  # Update links to the person from an array of user ids. The array contains the
  # complete list of users connected to the person.
  # I would prefer to leave them all alone, but the algorithm is harder.
  def update_team(updated_users)
    # An empty array means no users (which should happen either)
    # Nil means don't do anything with existing links.
    return if updated_users.nil?

    # Get rid of the HTML artifact.
    updated_users -= [""]

    # Don't let the app be stupid. Can't ever completely unlink a person.
    logger.warn("update_team called with an empty array.") && return if updated_users.empty?

    updated_users = updated_users.map { |u| User.find(u) }

    # Delete the links that are no longer valid.
    (users - updated_users).each do |u|
      #      puts "Unlinking: #{u.to_yaml}"
      unlink(u)
    end

    # Add the new users.
    (updated_users - users).each do |u|
      #      puts "Linking: #{u.to_yaml}"
      linkup(u)
    end

    # At the moment, no need to do anything else.
    # What happens when I put attributes on the link?
    # TODO Add parent and other atributes to links.
  end

  # rdoc
  # A person is owned by a user if:
  # * The person is the user.
  # * They're a parent of the person, # TODO
  # * If there is no parent, then the creator is the owner
  def is_owned_by?(user)
    user = User.find(user) unless user.is_a?(User)
    return true if self.user == user
    # TODO: Check for parent.
    creator == user
  end

  # rdoc
  # Get all the unique expectations, by expectation ID, for completed routines
  # for this person. These become the column headings (or row headings) for
  # the display.
  def unique_expectations
    # Select unique expectations that are in completed expectations for this person.
  end

  # rdoc
  # Get the unique dates on which this person completed at least one routine.
  def routine_dates
    completed_routines.collect { |d| d.routine_done_at.beginning_of_day }.uniq
  end

  # rdoc
  # Get arrays of the dates of completed routines and number of columns needed for each date,
  # then also grouped by month and year.
  def completed_routines_column_layout
    completed_routines
      .group_by { |cr| cr.routine_done_at.beginning_of_day }
      .collect { |k, v| [k, v.count] }
      .group_by { |x| x[0].beginning_of_month }
      .flatten

    # The date comes out as a string on sqlite and a date on MySql. Crap. Ugliness ahead.
    # More crap. Obviously I can't use a to_date-based query, since the date changes
    # based on the time zone
    #    completed_routines
    #      .group("date(completed_routines.routine_done_at)")
    #      .pluck("date(completed_routines.routine_done_at), count(*)")
    #      .collect { |x| [x[0].kind_of?(String) ? Time.find_zone('UTC').parse(x[0]).in_time_zone : x[0], x[1]]}
    #      .group_by { |x| x[0].beginning_of_month }
    #      .flatten
    # Confirm when I add time zone that this uses time zone Ha Ha. It doesn't
  end

  # rdoc
  # Get a has of routines containing completed routines grouped by date.
  def routines_layout
    Hash[
      routines
      .map do |r|
        [r, r
      .completed_routines
      .group_by { |cr| cr.routine_done_at.beginning_of_day }]
      end
    ]
  end

  def full_layout
    layout = completed_expectations.each_with_object({}) do |ce, o|
      #      puts "ce, o: #{ce}, #{o}"
      o[ce.routine] ||= {}
      o[ce.routine][ce.expectation] ||= {} # Cause we want an array next, we have to create a hash but don't return hash as default.'
      o[ce.routine][ce.expectation][ce.completed_routine.routine_done_at.beginning_of_day] ||= []
      o[ce.routine][ce.expectation][ce.completed_routine.routine_done_at.beginning_of_day] << ce
      #      puts "layout: #{o.inspect}"
    end
    layout
  end

  def completed_expectations_for_day_and_expectation(expectation, day)
    completed_expectations.find_all do |x|
      x.completed_routine.routine_done_at.beginning_of_day == day &&
        x.expectation == expectation
    end
  end
  #  def name
  #    "#{self.class}: #{super}"
  #  end
end
