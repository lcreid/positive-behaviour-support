class Routine < ActiveRecord::Base
  belongs_to :person
  has_many :expectations
end
