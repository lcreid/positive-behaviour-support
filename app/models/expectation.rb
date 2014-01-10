class Expectation < ActiveRecord::Base
  belongs_to :routine

=begin rdoc
Return a hash of attributes that make sense to compare to a completed expectation.
=end
  def comparable_attributes
    copyable_attributes
  end
  
=begin rdoc
Return a hash of attributes that make sense to copy to initialize a completed expectation.
=end
  def copyable_attributes
    attributes.slice("description")
  end
  
=begin rdoc
Override == when the other object is a CompletedExpectation, to test only the attributes
that make sense to compare.
=end
  def ==(other)
    return super unless other.is_a? CompletedExpectation
    comparable_attributes == other.comparable_attributes
  end
end
