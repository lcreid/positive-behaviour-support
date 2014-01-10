class CompletedRoutine < ActiveRecord::Base
  belongs_to :person
  belongs_to :routine
  has_many :completed_expectations
  accepts_nested_attributes_for :completed_expectations
  
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
end
