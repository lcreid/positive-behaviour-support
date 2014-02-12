=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class Goal < ActiveRecord::Base
  belongs_to :person
  has_many :routines, inverse_of: :goal
  has_many :completed_routines, through: :routines
  
  validates :target, numericality: { only_integer: true }, allow_blank: true
  validates :name, presence: true
  
=begin rdoc
Return the number of clean routines for this goal,
minus the number of routines already rewarded, and divide that difference
by the target,
=end
  def pending(ignore_cache = false)
    pending_routines(ignore_cache).count / target
  end
  
=begin rdoc
Return the clean routines for this goal that haven't been
awarded yet.
=end
  def pending_routines(ignore_cache = false)
    clean_routines(ignore_cache).where(awarded: false)
  end
  
  def clean_routines(ignore_cache = false)
#    completed_routines(ignore_cache).select { |cr| cr.is_clean? }
    completed_routines.where(
      "not exists (" + 
        "select * from completed_expectations ce " + 
          "where (ce.observation = 'N' or ce.observation is null) and " +
            "completed_routine_id = completed_routines.id)"
    )
  end
  
  def awarded(ignore_cache = false)
    completed_routines(ignore_cache).count { |cr| cr.awarded }
  end
  
  def award(n = 1)
    n ||= 1
    n = Integer(n) if n.kind_of? String
    return if pending < n
    pending_routines.sort_by { |cr| cr.routine_done_at } .first(n * target).each do |give|
      give.awarded = true
      give.save!
    end
  end
  
  def can_be_completed_by?(user)
    user.primary_identity != self.person && # User can give self awards
      user.people.any? { |x| x == self.person } # Goal is for a user in the user's contact list
  end
end
