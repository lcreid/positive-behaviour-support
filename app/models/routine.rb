=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class Routine < ActiveRecord::Base
  belongs_to :person
  belongs_to :goal, inverse_of: :routines
  has_many :completed_routines, dependent: :destroy
  has_many :expectations, dependent: :destroy
  accepts_nested_attributes_for :expectations, allow_destroy: true
  
=begin rdoc
Return a hash of attributes that make sense to compare to a completed routine.
=end
  def comparable_attributes
    copyable_attributes
  end
  
=begin rdoc
Return a hash of attributes that make sense to copy to initialize a completed routine.
Note that this means changing the key of the "id" attribute
to "routine_id".
=end
  def copyable_attributes
    attributes.slice("name", "person_id").merge("routine_id" => attributes["id"]).merge(
      "completed_expectations_attributes" => expectations.collect { |e| e.comparable_attributes }
    )
  end
  
=begin rdoc
Override == when the other object is a CompletedRoutine, to test only the attributes
that make sense to compare.
=end
  def ==(other)
    return super unless other.is_a? CompletedRoutine
#    puts comparable_attributes.to_s
#    puts other.comparable_attributes.to_s
    comparable_attributes == other.comparable_attributes
  end
end
