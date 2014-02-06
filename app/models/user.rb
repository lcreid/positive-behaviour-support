=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'person_helper'

class User < ActiveRecord::Base
  has_many :identities, class_name: "Person"
  has_many :links, through: :identities
  has_many :people, through: :links, :source => :person_b
  has_many :users, through: :people
  has_many :messages, foreign_key: :to_id # These are received messages
  has_many :sent_messages, foreign_key: :from_id, class_name: Message

#  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map(&:name), allow_nil: true, allow_blank: true
  validate :validate_time_zone
  
  after_create :add_primary_identity
  
  include PersonHelper

=begin rdoc
Find the user based on the information provided by Omniauth,
or create a User based on the information provided by Omniauth if
it doesn't exist.
=end
  def self.from_omniauth_or_create(auth)
    from_omniauth(auth) || create_from_omniauth(auth)
  end
  
=begin rdoc
Find the user based on the information provided by Omniauth.
=end
  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first
  end

=begin rdoc
Return true if the user already exists, based on the information
provided by Omniauth, false otherwise.
=end
  def self.from_omniauth_exists?(auth)
    from_omniauth(auth)? true: false
  end

=begin rdoc
Create a User based on the information provided by Omniauth.
=end
  def self.create_from_omniauth(auth)
    user = create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      case user.provider
      when 'twitter', 'Training', 'facebook', 'yahoo'
        user.name = auth["info"]["nickname"]
      when 'google_oauth2'
        user.name = auth["info"]["name"] 
      else
        raise "Shouldn't happen."
      end
    end
  end

  private

  @@provider = {
      "Google" => "google_oauth2",
      "Twitter" => "twitter",
      "Testing" => "Testing"
    }

  public
  
=begin rdoc
Return hash of human readable name and internal provider name.
=end
  def self.provider(name)
    @@provider[name]
  end

=begin rdoc
Return of hash of internal provider name and human readable name.
=end
  def self.inverse_provider(provider)
    @@provider.invert[provider]
  end
  
=begin rdoc
Return the Person that is the primary identity of the user.
=end
  def primary_identity
    identities.first
  end

=begin rdoc
A user is allowed to complete a routine if they
can access it.
=end  
  def can_complete?(routine)
    can_access?(routine)
  end

=begin rdoc
A user is allowed to access a routine if:
* they're connected to the person assigned to the routine.
* Possibly other conditions that are to be defined.
=end  
  def can_access?(routine)
    routine = Routine.find(routine) unless routine.is_a?(Routine)
    return false unless routine
    return people.any? { |p| p.id == routine.person_id }
  end

=begin rdoc
A user is allowed to access a goal if:
* they're connected to the person assigned to the goal.
* Possibly other conditions that are to be defined.
=end  
  def can_access_goal?(goal)
    goal = Routine.find(goal) unless goal.is_a?(Goal)
    return false unless goal
    return people.any? { |p| p.id == goal.person_id }
  end

=begin rdoc
Check if a user is allowed to modify an object.
=end
  def can_modify?(o)
    case o
    when CompletedRoutine, Goal, Routine
      team_member_for?(o.person)
    else
      false
    end
  end
  
=begin rdoc
Is this User on the team for the given person.
=end
  def team_member_for?(person)
    puts "User (self): #{self.to_yaml}\nPerson: #{person.to_yaml}"
    person = Person.find(person) unless person.is_a? Person
    return false unless person
    return people.any? { |p| p == person }
  end
  
=begin rdoc
Link a User to a Person or a User, bidirectionally, so that each entity is connected
to the other.
=end  
  def linkup(other)
    primary_identity.linkup(other)
  end
    
=begin rdoc
Unlink a Person from another Person or a User, bidirectionally, so that each entity is disconnected
to the other.
=end  
  def unlink(other)
    identities.each { |i| i.unlink(other) }
  end

=begin rdoc
Return the Link that joins one User to another.
=end
  def link_to!(user)
    Link.find_by!(person_a_id: self.identities, person_b_id: user.identities)
    # This should return only one link, as the only links between two users should
    # be the forward and backward link. But I'm not so sure... Return the first for now
  end
  
=begin rdoc
A user is allowed to create, modify or delete a link if:
* They're a participant in the link,
* or they created one of the participants in the link, # TODO
* or they're the parent of one of the participants in the link. # TODO
=end  
  def can_modify_link?(link)
#    puts "Self: #{self.inspect}"
#    puts "Link: #{link.inspect}"
    
    link = Link.find(link) unless link.is_a?(Link)
#    puts "Person A: #{link.person_a.inspect}"
#    puts "Person B: #{link.person_b.inspect}"
#    puts "Answer: #{identities.any? { |i| link.person_a == i || link.person_b == i }}"
    
    return true if identities.any? { |i| link.person_a == i || link.person_b == i }
    false
  end

=begin rdoc
A user is allowed to modify or delete a person if:
* They're the creator of the person and no parent defined for the person,
* or they're a parent of the person, # TODO
* or the person is one of the user's identities.S
=end  
  def can_modify_person?(person)
    person = Person.find(person) unless person.is_a?(Person)
    return true if person.creator == self
    return identities.any? { |i| i == person } # This one has to be last or rewrite logic.
  end

=begin rdoc
Validate the given timezone either by Rails city name or TZinfo string. Blank or nil is also okay.
=end
  def validate_time_zone
    unless self.time_zone.blank? || Time.find_zone(self.time_zone)
      errors.add(:validate_time_zone, "#{self.time_zone} is not a valid time zone.")
    end
  end

=begin rdoc
Unread messages.
=end
  def unread_messages(requery = false)
    messages(requery).where(read: false)
  end

=begin rdoc
Send an invitation to someone based on identity provider and name.
Silently do nothing if there is no user that matches.
=end
  def send_invitation(provider, name)
    return unless to = User.find_by(provider: @@providers[provider], name: name)
    Message.create! do |m|
      m.from = self
      m.to = to
      m.body = "#{self.name} would like to connect so you can work together."
      m.message_type = "invitation"
    end
  end
  
=begin rdoc
Return a list of people who have routines and are directly connected to 
the user.
=end
  def team
    
  end
  
  private
    
=begin rdoc
After create callback to add the primary identity of the user.
=end
  def add_primary_identity
    (identities << Person.create!(name: name, creator_id: self.id)).first
  end
end
