class CompletedExpectation < ActiveRecord::Base
  belongs_to :completed_routine
  
=begin rdoc
Return a hash of attributes that make sense to compare to an expectation.
=end
  def comparable_attributes
    attributes.slice("description")
  end
  
=begin rdoc
Override == when the other object is an Expectation, to test only the attributes
that make sense to compare.
=end
  def ==(other)
    return super unless other.is_a? Expectation
    comparable_attributes == other.comparable_attributes
  end
end
