class CompletedRoutine < ActiveRecord::Base
  belongs_to :person
  belongs_to :routine
  has_many :completed_expectations
end
