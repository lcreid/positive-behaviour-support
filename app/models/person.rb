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
    
#  def name
#    "#{self.class}: #{super}"
#  end
end
