=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
module PersonHelper
#  def users
#    people.select { |person| ! person.user_id.nil? }
#  end
  
  # The following is deprecated. See "subjects"
  def patients
    people.select { |person| person.user_id.nil? }
  end

=begin rdoc
Return the list of people attached to the person or user, who have
at least one routine attached.
=end  
  def subjects
    people.joins(:routines).distinct    
  end
end
