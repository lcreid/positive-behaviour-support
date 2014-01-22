=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class CompletedExpectation < ActiveRecord::Base
  belongs_to :completed_routine
  belongs_to :expectation
  scope :clean, -> { where('observation = "Y" or observation = "N/A"') }
  
=begin rdoc
Build a new CompletedExpectation from an Expectation.
=end
  def initialize(params)
    params = params.copyable_attributes if params.is_a? Expectation
    super(params)
  end
  
=begin rdoc
Get the Routine associated with this CompletedExpectation.
=end
  def routine
    completed_routine.routine
  end
  
=begin rdoc
Return a hash of attributes that make sense to compare to an expectation.
=end
  def comparable_attributes
    attributes.slice("description", "expectation_id")
  end
  
=begin rdoc
Override == when the other object is an Expectation, to test only the attributes
that make sense to compare.
=end
  def ==(other)
    return super unless other.is_a? Expectation
    comparable_attributes == other.comparable_attributes
  end

=begin rdoc
Return true if the expectation was completed successfully,
or wasn't' able to be completed through no fault of the patient.
=end
  def is_clean?
    observation == "Y" || observation == "N/A"
  end
end
