require 'person_helper'

class Person < ActiveRecord::Base
  belongs_to :user
  has_many :links, foreign_key: :person_a_id
  has_many :people, through: :links, source: :person_b
  has_many :routines
  has_many :completed_routines, through: :routines
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
    
#  def name
#    "#{self.class}: #{super}"
#  end
end
