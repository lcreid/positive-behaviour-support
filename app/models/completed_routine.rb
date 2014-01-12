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
  
=begin rdoc
Return true if all expectations in the routine were completed successfully,
or weren't able to be completed through no fault of the patient.
=end
  def is_clean?
    completed_expectations.all? { |ce| ce.is_clean? }
  end
end

=begin
A more general way to change keys in a hash is this 
(http://stackoverflow.com/questions/4137824/how-to-elegantly-rename-all-keys-in-a-hash-in-ruby):

ages = { "Bruce" => 32, "Clark" => 28 }
mappings = {"Bruce" => "Bruce Wayne", "Clark" => "Clark Kent"}

Hash[ages.map {|k, v| [mappings[k], v] }]
=end
