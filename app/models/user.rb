# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :identities, class_name: "Person", dependent: :destroy
  has_many :links, through: :identities
  has_many :people, through: :links, source: :person_b
  has_many :users, through: :people, source: :user
  has_many :messages, foreign_key: :to_id # These are received messages
  has_many :sent_messages, foreign_key: :from_id, class_name: "Message"

  # New
  has_many :person_users, dependent: :destroy
  has_many :subjects, through: :person_users, class_name: "Person", inverse_of: :caregivers, source: :person
  has_many :goals, through: :subjects

  validate :validate_time_zone

  after_create :add_primary_identity

  # rdoc
  # Find the user based on the information provided by Omniauth,
  # or create a User based on the information provided by Omniauth if
  # it doesn't exist.
  def self.from_omniauth_or_create(auth)
    from_omniauth(auth) || create_from_omniauth(auth)
  end

  # rdoc
  # Find the user based on the information provided by Omniauth.
  def self.from_omniauth(auth)
    # where(auth.slice("provider", "uid")).first
    where(provider: auth["provider"], uid: auth["uid"]).first
  end

  # rdoc
  # Return true if the user already exists, based on the information
  # provided by Omniauth, false otherwise.
  def self.from_omniauth_exists?(auth)
    from_omniauth(auth) ? true : false
  end

  # rdoc
  # Create a User based on the information provided by Omniauth.
  def self.create_from_omniauth(auth)
    user = create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      case user.provider
      when "twitter", "Training", "facebook", "yahoo"
        user.name = auth["info"]["nickname"]
      when "google_oauth2"
        user.name = auth["info"]["name"]
      else
        raise "Shouldn't happen."
      end
    end
  end

  def patients
    subjects
  end

  private

  @@providers = {
    "Google" => "google_oauth2",
    "Twitter" => "twitter",
    "Testing" => "Testing"
  }

  public

  # rdoc
  # Return hash of human readable name and internal provider name.
  def self.provider(name)
    @@providers[name]
  end

  # rdoc
  # Return of hash of internal provider name and human readable name.
  def self.inverse_provider(provider)
    @@providers.invert[provider]
  end

  # rdoc
  # Return the Person that is the primary identity of the user.
  def primary_identity
    identities.first
  end

  # rdoc
  # A user is allowed to complete a routine if they
  # can access it.
  def can_complete?(routine)
    can_access?(routine)
  end

  # rdoc
  # A user is allowed to access a routine if:
  # * they're connected to the person assigned to the routine.
  # * Possibly other conditions that are to be defined.
  def can_access?(routine)
    routine = Routine.find(routine) unless routine.is_a?(Routine)
    routine.person && team_member_for?(routine.person)
  end

  # rdoc
  # A user is allowed to access a goal if:
  # * they're connected to the person assigned to the goal.
  # * Possibly other conditions that are to be defined.
  def can_access_goal?(goal)
    goal = Routine.find(goal) unless goal.is_a?(Goal)
    return false unless goal
    people.any? { |p| p.id == goal.person_id }
  end

  # rdoc
  # Check if a user is allowed to modify an object.
  def can_modify?(o)
    case o
    when CompletedRoutine, Goal, Routine
      o.person && team_member_for?(o.person)
    else
      false
    end
  end

  # rdoc
  # Is this User on the team for the given person.
  def team_member_for?(person)
    person = Person.find(person) unless person.is_a? Person
    return false unless person
    person.caregivers.include?(self)
    # people.any? { |p| p == person }
  end

  # rdoc
  # Link a User to a Person or a User, bidirectionally, so that each entity is connected
  # to the other.
  def linkup(other)
    primary_identity.linkup(other)
  end

  # rdoc
  # Unlink a Person from another Person or a User, bidirectionally, so that each entity is disconnected
  # to the other.
  def unlink(other)
    identities.each { |i| i.unlink(other) }
  end

  # rdoc
  # Return the Link that joins one User to another.
  def link_to!(user)
    Link.find_by!(person_a: identities, person_b: user.identities)
    # This should return only one link, as the only links between two users should
    # be the forward and backward link. But I'm not so sure... Return the first for now
  end

  # rdoc
  # A user is allowed to create, modify or delete a link if:
  # * They're a participant in the link,
  # * or they created one of the participants in the link, # TODO
  # * or they're the parent of one of the participants in the link. # TODO
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

  # rdoc
  # A user is allowed to modify or delete a person if:
  # * They're the creator of the person and no parent defined for the person,
  # * or they're a parent of the person, # TODO
  # * or the person is one of the user's identities.S
  def can_modify_person?(person)
    person = Person.find(person) unless person.is_a?(Person)
    return true if person.creator == self
    identities.any? { |i| i == person } # This one has to be last or rewrite logic.
  end

  # rdoc
  # Validate the given timezone either by Rails city name or TZinfo string. Blank or nil is also okay.
  def validate_time_zone
    unless time_zone.blank? || Time.find_zone(time_zone)
      errors.add(:validate_time_zone, "#{time_zone} is not a valid time zone.")
    end
  end

  # rdoc
  # Unread messages.
  def unread_messages(_requery = false)
    messages.reload.where(read: false)
  end

  # rdoc
  # Send an invitation to someone based on identity provider and name.
  # Silently do nothing if there is no user that matches.
  def send_invitation(id)
    return unless to = User.find(id)
    Message.create! do |m|
      m.from = self
      m.to = to
      m.body = "#{name} would like to connect so you can work together."
      m.message_type = "invitation"
    end
  end

  private

  # rdoc
  # After create callback to add the primary identity of the user.
  def add_primary_identity
    (identities << Person.create!(name: name, creator_id: id)).first
  end
end
