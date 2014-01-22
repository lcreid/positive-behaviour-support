=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class Expectation < ActiveRecord::Base
  belongs_to :routine
  has_many :completed_routines, through: :routine

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
    attributes.slice("description").merge("expectation_id" => attributes["id"])
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
