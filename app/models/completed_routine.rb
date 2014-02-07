=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class CompletedRoutine < ActiveRecord::Base
  belongs_to :person
  belongs_to :routine
  belongs_to :recorded_by, class_name: User
  belongs_to :updated_by, class_name: User
  has_many :completed_expectations, dependent: :destroy
  accepts_nested_attributes_for :completed_expectations, allow_destroy: true
  scope :most_recent, ->(n = 10000) { reorder(routine_done_at: :desc).limit(n) }

  before_create :set_routine_done_at

=begin rdoc
By default, the routine is given a date and time of when the person began
recording the observations. This field is editable in the form.
=end
  def set_routine_done_at
    self.routine_done_at || self.routine_done_at = Time.now
  end

=begin 
For records created before the routine_done_at column was added,
use the created_at time.
No. Better to fix in the migration de una buena vez.
Also have fix the fixtures, because they don't fire the triggers.
=end
#  def routine_done_at
#    super || self.routine_done_at = self.created_at
#  end
  
#=begin rdoc
#Build a new CompletedRoutine from a Routine.
#=end
#  def initialize(params = nil)
#    params = params.copyable_attributes if params.is_a? Routine
#    super(params)
#  end
  
=begin rdoc
Override == when the other object is a Routine, to test only the attributes
that make sense to compare.
=end
  def ==(other)
#    puts "Self is a #{self.class}. Other is a #{other.class}"
    return super unless other.is_a? Routine
    comparable_attributes == other.comparable_attributes
  end
  
=begin rdoc
Return a hash of attributes that make sense to compare to a routine.
=end
  def comparable_attributes
    attributes.slice("routine_id", "name", "person_id").merge(
      "completed_expectations_attributes" => completed_expectations.collect { |ce| ce.comparable_attributes }
    )
  end
  
=begin rdoc
Return true if all expectations in the routine were completed successfully,
or weren't able to be completed through no fault of the patient.
=end
  def is_clean?
    completed_expectations.all? { |ce| ce.is_clean? }
  end

=begin rdoc
Return all the expectations that have ever existed for the routine associated
with this comopleted routine.
=end
  def expectations
    Expectation.uniq.where(routine_id: self.routine_id)
  end
end

=begin
A more general way to change keys in a hash is this 
(http://stackoverflow.com/questions/4137824/how-to-elegantly-rename-all-keys-in-a-hash-in-ruby):

ages = { "Bruce" => 32, "Clark" => 28 }
mappings = {"Bruce" => "Bruce Wayne", "Clark" => "Clark Kent"}

Hash[ages.map {|k, v| [mappings[k], v] }]
=end
